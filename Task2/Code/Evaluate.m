function Summary = Evaluate(Results, Labels, Params)
%EVALUATE Compute the results statistics and return them as fields of Summary
%   Summary of classification includes:
%       Most important: the error rate
%       Secondary: the confusion matrix: a matrix of size MªM (M – the number of classes),
%       where M(i,j) is the probability that an example with true label i is predicted to be of label j

%TODO: remove
assert(isequal(size(Results.Predictions), size(Labels')));

Y = Labels'; %NX1
P = Results.Probs;

% calculate AUC curve
[~,Recall,thresh,AUC] = perfcurve(Y == 1,P,true );
target = Y == 1;
Prec = zeros(length(thresh),1);
for i = 1:length(thresh)
    idx     = (P >= thresh(i));
    Prec(i) = sum(target(idx)) / sum(idx);
end

%plot AUC curve
plot(Recall,Prec)

xlabel('Recall rate')
ylabel('precision rate')
title(strcat('Precision/recall curve for Pepper Classification by SVM, AUC= ', num2str(AUC)) )


ConfusionMatrix = confusionmat(int16(Y),int16(Results.Predictions));

Summary.ConfusionMatrix = ConfusionMatrix;

errors = (ConfusionMatrix-diag(diag(ConfusionMatrix)));
Summary.ErrorRate = sum(errors(:)) / length(Y);

%TODO: should be in reportresults
fprintf('ErrorRate: %f\n', Summary.ErrorRate);


%used later in ReportResults()
Summary.Results = Results;
Summary.TestLabels = Labels;
end


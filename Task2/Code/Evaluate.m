function Summary = Evaluate(Results, Labels, Params)
%EVALUATE Compute the results statistics and return them as fields of Summary
%   Summary of classification includes:
%       Most important: the error rate
%       Secondary: the confusion matrix: a matrix of size MªM (M – the number of classes),
%       where M(i,j) is the probability that an example with true label i is predicted to be of label j

%assert(isequal(size(Results.Predictions), size(Labels')));

Y = Labels'; %NX1
P = Results.Probs;

%% calculate AUC curve
[~,Recall,Thresh,AUC] = perfcurve(Y == 1,P, true);

target = Y == 1;
Precision = zeros(length(Thresh),1);
for i = 1:length(Thresh)
    idx     = (P >= Thresh(i));
    Precision(i) = sum(target(idx)) / sum(idx);
end

Summary.ROC.Recall = Recall;
Summary.ROC.Precision = Precision;
Summary.ROC.AUC = AUC;

%% Calc other stats
ConfusionMatrix = confusionmat(int16(Y),int16(Results.Predictions));

Summary.ConfusionMatrix = ConfusionMatrix;

errors = (ConfusionMatrix-diag(diag(ConfusionMatrix)));
Summary.ErrorRate = sum(errors(:)) / length(Y);


%used later in ReportResults()
Summary.Results = Results;
Summary.TestLabels = Labels;
end


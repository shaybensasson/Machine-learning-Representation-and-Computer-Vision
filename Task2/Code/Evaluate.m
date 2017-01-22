function Summary = Evaluate(Results, Labels, Params)
%EVALUATE Compute the results statistics and return them as fields of Summary
%   Summary of classification includes:
%       Most important: the error rate
%       Secondary: the confusion matrix: a matrix of size MªM (M – the number of classes),
%       where M(i,j) is the probability that an example with true label i is predicted to be of label j

%assert(isequal(size(Results.Predicted), size(Labels')));

Y = Labels'; %NX1
P = Results.Probs;


P = 2*round(P)-1; %convert to 1s and zeros
ConfusionMatrix = confusionmat(int16(Y),int16(P));

Summary.ConfusionMatrix = ConfusionMatrix;

errors = (ConfusionMatrix-diag(diag(ConfusionMatrix)));
Summary.ErrorRate = sum(errors(:)) / length(Y);

%TODO: should be in reportresults
fprintf('ErrorRate: %f\n', Summary.ErrorRate);


%used later in ReportResults()
Summary.Results = Results;
Summary.TestLabels = Labels;
end


function Summary = Evaluate(Results, Labels, Params)
%EVALUATE Compute the results statistics and return them as fields of Summary
%   Summary of classification includes:
%       Most important: the error rate
%       Secondary: the confusion matrix: a matrix of size MªM (M – the number of classes),
%       where M(i,j) is the probability that an example with true label i is predicted to be of label j

%assert(isequal(size(Results.Predicted), size(Labels')));
Y = Labels'; %NX1
P = Results.Predicted;

ConfusionMatrix = confusionmat(Y,P);
Summary.ConfusionMatrix = ConfusionMatrix;

errors = (ConfusionMatrix-diag(diag(ConfusionMatrix)));
Summary.ErrorRate = sum(errors(:)) / length(Y);
end


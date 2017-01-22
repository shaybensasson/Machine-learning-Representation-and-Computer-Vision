function [ Predicted, ClassScoreMatrix ] = MClassSVM_Predict(Features, MClassSVM)
%MClassSVM_Predict Predicts classes from features using SVC
%   accepts a set of examples to test as a N*D matrix, and an MClassSVM structure returned by MClassSVM_Train. The function predicts by
%	Apply the M SVMs to the data and put the predictions in an NªM class score matrix.
%	Compute the predicted class (an Nª1 vector) by taking the argmax  over the class score matrix columns (the highest score in the row determines the winning class)
%	Return the  predicted class and the class score matrix

N = size(Features,1);
M = length(MClassSVM.Classifiers);
ClassScoreMatrix = zeros(N, M);
for idxClass=1:M
    %predict using binary classifiers
    fprintf('%d/%d ', idxClass, M);
    
    %figure;
    %histogram(BinaryClasses);
    %title(sprintf('%d', idxClass));
    cls = MClassSVM.Classifiers{idxClass};
    ClassScoreMatrix(:, idxClass) = fwd(cls, Features); %NxD
end

fprintf('\n');

%ArgMax on columns
[~, Predicted] = max(ClassScoreMatrix'); %#ok<UDIM>

Predicted = Predicted'; %NX1
end


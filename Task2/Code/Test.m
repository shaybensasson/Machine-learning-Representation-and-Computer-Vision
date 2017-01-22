function [Results] = Test(Model, Data, Params)
%TEST Tests the classified model
%   for each of data sample representation we predict the class 
%   using the SVM binary classifier

%TODO:
%   returns Results:
%      .Probs: The (softmaxed) score for each test observation


    % loop over all exampals
    fprintf('Testing test data representations using svm model ...\n');
    
    
    %predict using binary classifier
    cls = Model.Classifier;
    scores = fwd(cls, Data); %NxD
    
    %TODO: add -1 column, calc softmax
    
    %ArgMax on columns
    %[~,Predicted] = max(ClassScoreMatrix'); %#ok<UDIM>
    
    scores(:,2) = -scores(:,1);
    softmax = @(X) exp(X)./sum(exp(X),2);
    probs = softmax(scores);
    probs = probs(:,1); %we care only about the probability of being class 1

    Results.Probs = probs;
end


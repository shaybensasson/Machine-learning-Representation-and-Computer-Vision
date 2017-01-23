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
    Results.Scores = scores;
    
    %TODO: add comments

    scores(:,2) = -scores(:,1);
    
    
    %probs = softmax(scores')';
    probs = softmax_with_dim(scores, 2);
    probs = probs(:,1); %we care only about the probability of being class 1
    Results.Probs = probs;
    
    Results.Predictions = 2*round(probs)-1; %convert to 1s and -1
    
end


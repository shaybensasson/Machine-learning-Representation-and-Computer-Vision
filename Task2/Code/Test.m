function [Results] = Test(Model, Data, Params)
%TEST Applies the trained SVM classifier on the test data
%   For each test data sample representation, we yield SVM score, probability and class prediction
%   using the SVM binary classifier
%   returns Results:
%      .Probs: The (softmaxed) score for each test observation
%      .Predictions: The predicted class (+1 or -1) for all test observations
%      .Scores: The SVM scores for all test observations

    %predict using SVM trained binary classifier
    fprintf('Testing test data representations using svm model ...\n');
    
    cls = Model.Classifier;
    scores = fwd(cls, Data);
    Results.Scores = scores; %store SVM model predicted scores
    
    %calc probabilities 
    scores(:,2) = -scores(:,1);
        
    %probs = softmax(scores')';
    probs = softmax_with_dim(scores, 2); % softmax function (matlab built-in function does not allow to choose a specific dimension to work on)
    probs = probs(:,1); %we care only about the probability of being class 1
    Results.Probs = probs;
    
    Results.Predictions = 2*round(probs)-1; %convert to 1s and -1
    
end


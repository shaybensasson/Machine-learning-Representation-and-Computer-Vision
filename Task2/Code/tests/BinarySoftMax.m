ClassScoreMatrix = randn(10,1);

ClassScoreMatrix(:,2) = -ClassScoreMatrix(:,1);
softmax = @(X) exp(X)./sum(exp(X),2);
probs = softmax(ClassScoreMatrix);
probs = probs(:,1) %we care only about the probability of being class 1

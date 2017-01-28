function [Data1, Data2, Labels1, Labels2, Data1Indices, Data2Indices] = ...
    TrainTestSplit(Data, Labels, Params)
%TrainTestSplit Randomly Splits the data and labels according to a ratio defined in Params
%INPUTS: 
% Data: data to be splited
% Labels: the labels of the Data
% Params: Parameters related to this function defined in GetDefaultParameters()
%
%OUPUTS:
% Data1, Labels1: Data and labels group 1
% Data2, Labels2: Data and labels group 2 
% Data1Indices, Data2Indices: Indices variables that keeps 
%   the initial order of the file 
%   (for reporting errornous misclassifications later)

%Store original order
Indices = 1:length(Labels);

%shuffle original data, [perm] is the vector that holds the random order/permutation
perm = randperm(length(Labels));

Labels = Labels(perm);
Data = Data(:,:,:,perm);
Indices = Indices(perm);


% Create vector for train/test
TrainOrTest = ones(1, length(Labels));
TrainOrTest(1:round(length(Labels) * Params.Ratio)) = 2;

% Assign data to train/test
Data1 = Data(:,:,:,TrainOrTest == 1);
Data2 = Data(:,:,:, TrainOrTest == 2);
Labels1 = Labels(1,TrainOrTest == 1);
Labels2 = Labels(1, TrainOrTest == 2);

% Indices variables that keeps the initial order of the file (for reporting errornous misclassifications later)
Data1Indices = Indices(TrainOrTest == 1); 
Data2Indices = Indices(TrainOrTest == 2);
end



function [Data1, Data2, Labels1, Labels2] = ...
    TrainTestSplit(Data, Labels, Params)
%TrainTestSplit Randomly Splits the data and labels according to a ratio defined in Params
%We ensure that the data is splitted by labels, so Ratio will remain whithin label

%Store original order
Indices = 1:length(Labels);

%shuffle original data
perm = randperm(length(Labels));

Labels = Labels(perm);
Data = Data(:,:, :,perm);
Indices = Indices(perm);


% Create vector for train/test
TrainOrTest = ones(1, length(Labels));
TrainOrTest(1:round(length(Labels) * Params.Ratio)) = 2;

% Assign data to train/test
Data1 = Data(:,:,:,TrainOrTest == 1);
Data2 = Data(:,:,:, TrainOrTest == 2);
Labels1 = Labels(1,TrainOrTest == 1);
Labels2 = Labels(1, TrainOrTest == 2);

end


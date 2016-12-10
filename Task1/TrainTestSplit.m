function [Data1, Data2, Labels1, Labels2] = TrainTestSplit(Data, Labels, Params)
%TrainTestSplit Randomly Splits the data and labels according to a ratio defined in Params
    n = size(Data, 3);
    perm = randperm(n); %choose random permutation
    
    ixs = perm(1:ceil(n*Params.Ratio));
    Data1 = Data(:,:,ixs);
    Labels1 = Labels(ixs);
    
    ixs = perm(length(ixs)+1:end);
    Data2 = Data(:,:,ixs);
    Labels2 = Labels(ixs);

end


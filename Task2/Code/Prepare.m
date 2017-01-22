function [DataRep, Labels] = Prepare(Data, IsTrain, Labels, Params)
%PREPARE Forward pass thru nnet and store activations/representations

%TODO: put parameters in Params

% loop over all exampals
fprintf('Preprocessing data (get activation of alexnet last layer) ...\n');
net = load('imagenet-caffe-alex.mat') ;
net.layers(20:21) = [];

if (IsTrain)
    augFact = Params.AugFact;
else
    augFact = 1;
end

DataRep = single(zeros(size(Data,4) * augFact, net.layers{1,18}.size(3)));

for i = 1:augFact
    
    for IndImg = 1:size(Data,4) % turn into AlexNet 19 layer represntation
        % get image
        Img = single(Data(:,:,:,IndImg));
        
        % Augment Data
        if (IsTrain)
            Img = DataAugment(Img, Params.DataAugment);
        end
        
        res = vl_simplenn(net, Img);
        % res(i+1).x: the output of layer i. Hence res(1).x is the network input.
        
        %we are taking the fc activations (next is the 'relu' non linearity)
        DataRep(IndImg + (i -1)*size(Data,4), :) = squeeze(res(19).x);
        
    end
end

% Duplicate labels if needed
Labels = repmat(Labels,[1,augFact]);

end


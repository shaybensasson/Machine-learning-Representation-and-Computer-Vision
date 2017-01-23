function [DataRep, Labels] = Prepare(Data, IsTrain, Labels, Params)
%PREPARE Forward pass thru nnet and store activations/representations

%TODO: Comment heavily

% loop over all exampals
net = load('imagenet-caffe-alex.mat') ;
net.layers(20:21) = [];

if (IsTrain)
    augFact = Params.AugFact;
else
    augFact = 1;
end
if Params.ExtraLayer
    DataRep = single(zeros(size(Data,4) * augFact, net.layers{1,18}.size(3)*2));
    fprintf('Preprocessing data (get activation of alexnet two last layer) ...\n');
else
    DataRep = single(zeros(size(Data,4) * augFact, net.layers{1,18}.size(3)));
    fprintf('Preprocessing data (get activation of alexnet last layer) ...\n');
end

for i = 1:augFact
    
    for IndImg = 1:size(Data,4) % turn into AlexNet 19 layer represntation
        % get image
        Img = single(Data(:,:,:,IndImg));
        
        % Augment Data
        if (IsTrain && augFact > 1) %TODO: talk to gideon we might remove it
            Img = DataAugment(Img, Params.DataAugment);
        end
        
        res = vl_simplenn(net, Img);
        % res(i+1).x: the output of layer i. Hence res(1).x is the network input.
        
        %we are taking the fc activations (next is the 'relu' non linearity)
        
        
        if Params.ExtraLayer
            representation = [squeeze(res(18).x); squeeze(res(20).x) ];
        else
            representation = squeeze(res(18).x);
        end
        
        DataRep(IndImg + (i -1)*size(Data,4), :) = representation;
   end
end

% Duplicate labels if needed
Labels = repmat(Labels,[1,augFact]);

end


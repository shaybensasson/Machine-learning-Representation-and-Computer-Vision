function [DataRep] = Prepare(Data, Params)
%PREPARE Computes the representation function resulting feature space vectors
%   Transform the example image into the input form of the classifier
%   HOG:
%     Create HOG representation from the images and turn into vectors
%   SIFT:
%     Extracting SIFTS of different scales for each image

% loop over all exampals
fprintf('Preprocessing data (get activation of alexnet last layer) ...\n');
net = load('imagenet-caffe-alex.mat') ;
net.layers(20:21) = [];

DataRep = single(zeros(size(Data,4) * Params.AugFact , net.layers{1,18}.size(3)));
for i = 1:Params.AugFact

    for IndImg = 1:size(Data,4) % turn into AlexNet 19 layer represntation
        % get image
        Img = single(Data(:,:,:,IndImg));
        
        % Augment Data
        Img = DataAugment(Img, Params.DataAugment);
        
        res = vl_simplenn(net, Img);
        % res(i+1).x: the output of layer i. Hence res(1).x is the network input.

        %we are taking the fc activations (next is the 'relu' non linearity)
        DataRep(IndImg + (i -1)*size(Data,4), :) = squeeze(res(19).x); 

    end
end
end


function [OutImg] = DataAugment(OrgImg, Params)
% The function takes Raw image and augment it:
% Apply rotation, translation, Noise addition, and random horizontal plip
% Returns the augmented image
OutImg = imrotate(OrgImg,rand(1) * Params.Rot,'bilinear','crop'); % rotation
OutImg(isnan(OutImg))=0;
OutImg = imtranslate(OutImg,[round(rand(1) * Params.Shif), round(rand(1) * Params.Shif)]); % translation
OutImg = OutImg + randn(size(OutImg))*Params.Nois; % add random noise
if logical(randi(2)-1) && (Params.Flip)
    OutImg = flip(OutImg,2); % horizontal flip
end
end
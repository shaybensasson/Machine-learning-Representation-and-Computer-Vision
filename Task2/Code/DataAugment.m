function [OutImg] = DataAugment(OrgImg, Params)
% The function takes Raw image and augment it:
% Apply rotation, translation, Noise addition, and random horizontal plip
% Returns the augmented image

%image(OrgImg)
OutImg = imrotate(OrgImg,rand(1) * Params.Rot,'bilinear','crop');
OutImg(isnan(OutImg))=0;
OutImg = imtranslate(OutImg,[round(rand(1) * Params.Shif), round(rand(1) * Params.Shif)]);
OutImg = OutImg + randn(size(OutImg))*Params.Nois;
if (randi(2) == 2) & (Params.Flip)
    OutImg = flipdim(OutImg,2);
end
end
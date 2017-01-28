% Watch Flowers data

load('FlowerData');
figure;
for i=1:length(Data)
    imshow(Data{i});
    title(sprintf('Image %i label %i',i, Labels(i)));
    waitforbuttonpress;
end
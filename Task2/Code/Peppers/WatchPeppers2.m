

load('PeppersData.mat');

figure;
for i=1:length(Labels)
    image(Images{i});
    if Labels(i)==1
        title('Pepper');
    else
        title('Not Pepper');
    end
    waitforbuttonpress;
end


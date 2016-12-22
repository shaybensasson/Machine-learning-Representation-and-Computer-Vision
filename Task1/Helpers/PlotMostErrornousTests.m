function PlotMostErrornousTests( Results, TestLabels, TestIndices, Metadata, ClassIndices)
%PLOTMOSTERRORNOUSTESTS Plot largest errors per class
%   By largest error I mean the images which got the lowest margin, following this definition:
%	 Class_score(i): For SVM-based system Class_score(i) is defined as the SVM score of the i-th classifier.
%	The margin for an example of class i is Class_score(i)-max(j?i)Class_score(j).
%   This is the difference between the score of the correct class score
%       and the maximal score of incorrect classes.
%   Larger values indicate good classification. A value below 0 is an error.


%%
Predicted = Results.Predicted;
True = TestLabels';

%Using indicator matrix to use/ignore correct scores
Indicator = logical(dummyvar(True));

scores = Results.ClassScoreMatrix;
true_scores = scores(Indicator);

%Putting lowest values so will be ignored on max
scores(Indicator) = -inf;
others_max = max(scores, [], 2);
Error = true_scores - others_max;

%To later show images, we need some kind of reference to the original files
%This is achieved using Matadata and the TestIndices variable.
%This var stored all file numbers/indices pre shuffling.
FileNumber = TestIndices';
T = table(FileNumber ,True, Predicted, Error);

%only neg errors
T = T(T.True~=T.Predicted,:);
T = T(T.Error < 0, :);

fprintf('***** Most Errornous Test Images: **** \n')
T = sortrows(T,{'True','Error'},{'ascend','ascend'});

hf2 = figure;
for idx=1:length(ClassIndices)
    TClass = T(T.True == idx,:); %using 1:M indices, instead of classindices
    
    class = ClassIndices(idx);
    
    if (isempty(TClass))
        fprintf('Class #%d has no errornous test images.\n', class);
        continue;
    end
    
    for i = 1:min(2,size(TClass, 1))
        row = TClass(i,:);

        imshow(Metadata.Filenames{row.FileNumber});
        %MaximizeFigure(hf);
        
        title(sprintf('Most Errornous Test Images: True[%s], Predicted[%s], Lowest Margin: [%f]', ...
            Metadata.Categories{row.True}, Metadata.Categories{row.Predicted}, row.Error), ...
            'Interpreter', 'None', 'FontSize', 10);
        %pause(5);
        fprintf('Press any key to continue ...\n');
        pause();
    end
    
end

end


function PlotMostErrornousTests( Results, TestLabels, TestIndices, Metadata)
%PLOTMOSTERRORNOUSTESTS Plot largest errors for false negative and false positives

%%
Prediction = Results.Predictions;

True = TestLabels';

Prob = Results.Probs; %The "over" confidence of the model (when non errors are removed)
Score = Results.Scores; %The SVM Scores
ErrorType = True - Prediction; %This could be [-2,0,2] or [FP,No error,FN]

%To later show images, we need some kind of reference to the original files
%This is achieved using Matadata and the TestIndices variable.
%This var stored all file numbers/indices pre shuffling.
FileNumber = TestIndices';
T = table(FileNumber,True, Prediction, Prob, Score, ErrorType);

T = T(T.True~=T.Prediction,:);
T = sortrows(T,{'Prob'},{'descend'});

hf2 = figure;

%% FP
for idx=1:5
    row = T(idx, :); 
    image(Metadata.Images{row.FileNumber});
        
    title(sprintf('Most Errornous FP Type-2: Index[%d], Score[%f], Pred[%d], True[%d]', ...
        idx, row.Score, row.Prediction, row.True), ...
        'Interpreter', 'None', 'FontSize', 10);

    fprintf('Press any key to continue ...\n');
    pause();
end


n_totalrows = size(T,1);
for idx=1:5
    row = T((n_totalrows+1)-idx, :); 
    image(Metadata.Images{row.FileNumber});
        
    title(sprintf('Most Errornous FN Type-1: Index[%d], Score[%f], Pred[%d], True[%d]', ...
        idx, row.Score, row.Prediction, row.True), ...
        'Interpreter', 'None', 'FontSize', 10);

    fprintf('Press any key to continue ...\n');
    pause();
end



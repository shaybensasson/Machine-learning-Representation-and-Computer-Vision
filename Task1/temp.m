%%
Predicted = Results.Predicted;
True = TestLabels';
Indicator = logical(dummyvar(True));

%size(Results.ClassScoreMatrix)

scores = Results.ClassScoreMatrix;

true_scores = scores(Indicator);

%%
scores(Indicator) = -inf;
others_max = max(scores, [], 2);
Error = true_scores - others_max;
%[sorted, indexes] = sort(errs);
TrialNum = TestIndices'; %Use splited test indices as column vector
T = table(TrialNum,True, Predicted, Error);

%only neg errors
T = T(T.True~=T.Predicted,:);
T = T(T.Error < 0, :);

fprintf('***** Most Errornous Test Images: **** \n')
T = sortrows(T,{'True','Error'},{'ascend','ascend'});

T = table();
for idx=1:length(ClassIndices)
    class = ClassIndices(idx);
    TClass = T(T.True == class,:);
    
    if (isempty(TClass))
        fprintf('Class #%d has no neg errors\n', class);
        continue;
    end
    
    T = [T; TClass(1,:)];
    
    if (size(TClass,1)>1)
        T = [T; TClass(2,:)];
    end
end

T


%%
f = figure();
for i = 1:size(T, 1)
    row = T(i,:)
    
    %imshow(uint8(TestData(:,:,row.TrialNum)));
    imshow(Metadata.Filenames{row.TrialNum});
    f.Position = [473,156,1010,939];
    title(sprintf('Most Errornous Test Images: True[%s], Predicted[%s], Lowest Margin: [%f]', ...
        Metadata.Categories{row.True}, Metadata.Categories{row.Predicted}, row.Error), ...
        'Interpreter', 'None', 'FontSize', 10);
    pause();
end



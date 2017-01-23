function ReportResults(Summary, TestLabels, TestIndices, Metadata, Params)
%REPORTRESULTS Draws the results figures, reports results to the screen and persists
%   Draws the results figures, reports results to the screen
%   Saves the results to the results path, to a file named according to the experiment name or number

%TODO:  improve comments

%Note that when hyper parameter optimizing - TestIndices is empty
% Because it causes problems when reshuffling the train/test split for val

fprintf('ErrorRate: %f\n', Summary.ErrorRate);
%fprintf('Confusion Matrix: %f', Summary.ConfusionMatrix);
fprintf('AUC: %f\n', Summary.ROC.AUC);

if (~Params.IsHyperParamOptimization)
    fprintf('Plotting Confusion Matrix ...\n');
    %TODO: do we want this later?
    figure;
    %MaximizeFigure(hf);
    PlotConfusionMatrix(Summary.ConfusionMatrix);
    
    
    %% plot AUC curve
    figure;
    plot(Summary.ROC.Recall, Summary.ROC.Precision)
    
    xlabel('Recall rate')
    ylabel('precision rate')
    title(strcat('Precision/recall curve for Pepper Classification by SVM, AUC= ', num2str(Summary.ROC.AUC)));
end

fprintf('Persisting Experiment Results ...\n');

if exist(Params.Report.ROOT_DIR, 'dir') == 0 % create folder if doesnt exist
    mkdir(Params.Report.ROOT_DIR)
end

file_path = fullfile(Params.Report.ROOT_DIR, sprintf('ResultsOf%s.mat', Params.Experiment));
save(file_path, ...
    'Summary', 'Metadata', 'Params');


if (~Params.IsHyperParamOptimization)
    %Error visualization
    PlotMostErrornousTests(Summary.Results, TestLabels, TestIndices, ...
        Metadata)
end


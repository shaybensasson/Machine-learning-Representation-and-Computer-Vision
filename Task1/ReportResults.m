function ReportResults(Summary, TestLabels, TestIndices, Metadata, Params)
%REPORTRESULTS Draws the results figures, reports results to the screen and persists
%   Draws the results figures, reports results to the screen
%   Saves the results to the results path, to a file named according to the experiment name or number

%Note that when hyper parameter optimizing - TestIndices is empty
% Because it causes problems when reshuffling the train/test split for val

fprintf('ErrorRate: %f\n', Summary.ErrorRate);
%fprintf('Confusion Matrix: %f', Summary.ConfusionMatrix);

if (~Params.IsHyperParamOptimization)
    fprintf('Plotting Confusion Matrix ...\n');
    
    hf = figure;
    MaximizeFigure(hf);
    PlotConfusionMatrix(Summary.ConfusionMatrix, Metadata.Categories);
end

confmat = Summary.ConfusionMatrix;
[micro, macro] = MicroMacroPR(confmat); %#ok
fprintf('precision: %f\n', macro.precision)
fprintf('recall: %f\n', macro.recall)
fprintf('fscore: %f\n', macro.fscore)


fprintf('Persisting Experiment Results ...\n');
file_path = fullfile(Params.Report.ROOT_DIR, sprintf('ResultsOf%s.mat', Params.Experiment));
save(file_path, ...
    'Summary', 'Metadata', 'Params');

if (~Params.IsHyperParamOptimization)
    %Error visualization
    PlotMostErrornousTests(Summary.Results, TestLabels, TestIndices, ...
        Metadata, Params.Data.ClassIndices)
end

end


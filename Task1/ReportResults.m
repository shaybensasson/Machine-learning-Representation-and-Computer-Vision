function ReportResults(Summary,Params)
%REPORTRESULTS Draws the results figures, reports results to the screen and persists
%   Draws the results figures, reports results to the screen
%   Saves the results to the results path, to a file named according to the experiment name or number 
    confmat = Summary.ConfusionMatrix;
    fprintf('ErrorRate: %f\n', Summary.ErrorRate);
            
    [micro, macro] = MicroMacroPR(confmat); %#ok
    fprintf('precision: %f\n', macro.precision)
    fprintf('recall: %f\n', macro.recall)
    fprintf('fscore: %f\n', macro.fscore)
    
    FScore = macro.fscore; %#ok
    ErrorRate = Summary.ErrorRate; %#ok
    
    file_path = fullfile(Params.Report.ROOT_DIR, sprintf('%s.mat', Params.Experiment));
    save(file_path, ...
        'Summary', 'Params', 'ErrorRate', 'FScore', 'macro', 'micro');
    
end


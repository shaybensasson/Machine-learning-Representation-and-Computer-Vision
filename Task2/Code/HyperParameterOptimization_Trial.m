function [ErrorRate] = HyperParameterOptimization_Trial(TTS, Params, Metadata, ...
    C, ...
    Kernel, Exp_Id, Kernel_Type, Kernel_Name)

tic;
Params.Experiment = sprintf('Exp_%d', Exp_Id);

Params.Train.SVM.C = C;
Params.Train.SVM.Kernel = Kernel_Type{Kernel};
Params.Train.SVM.KernelName = Kernel_Name{Kernel};

fprintf('-> Running experiment "%s:C[%.3f],Ker[%s]" ...\n', ...
    Params.Experiment, ...
    Params.Train.SVM.C, Params.Train.SVM.KernelName);

%{
%TEST
ErrorRate = rand;
return;
%}

TrainData = TTS.TrainData;
TrainLabels = TTS.TrainLabels;
TestData = TTS.ValData;
TestLabels = TTS.ValLabels;

%%
IsTrain = true;
[TrainDataRep, TrainLabels] = Prepare(TrainData, IsTrain, TrainLabels, Params.Prepare);

Model = Train(TrainDataRep, TrainLabels, Params.Train);

%%
IsTrain = false;
[TestDataRep, TestLabels] = Prepare(TestData, IsTrain, TestLabels, Params.Prepare);

Results = Test(Model, TestDataRep, Params.Test);

Summary = Evaluate(Results, TestLabels, Params.Summary);
ReportResults(Summary, TestLabels, [], Metadata, Params);

ErrorRate = Summary.ErrorRate;

fprintf('-> Experiment "%s" completed. Duration: %f.\n', Params.Experiment, toc);
end
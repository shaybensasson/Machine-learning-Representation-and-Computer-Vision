function [ErrorRate] = HyperParameterOptimization_Trial(TTS, Params, Metadata, ...
    C, ...
    Kernel, Exp_Id, Kernel_Type, Kernel_Name)

tic;
Params.Experiment = sprintf('Exp_%d', Exp_Id);

fprintf('-> Running experiment "%s" ...\n', Params.Experiment);

Params.Train.SVM.C = C;
Params.Train.SVM.Kernel = Kernel_Type{Kernel};
Params.Train.SVM.KernelName = Kernel_Name{Kernel};

TrainData = TTS.TrainData;
TrainLabels = TTS.TrainLabels;
TestData = TTS.ValData;
TestLabels = TTS.ValLabels;

%%
IsTrain = true;
[TrainDataRep, TrainLabels] = Prepare(TrainData, IsTrain, TrainLabels, Params)

Model = Train(TrainDataRep, TrainLabels, Params.Train);

%%
IsTrain = false;
[TestDataRep, TestLabels] = Prepare(TestData, IsTrain, TestLabels, Params)

Results = Test(Model, TestDataRep, Params.Test);

Summary = Evaluate(Results, TestLabels, Params.Summary);
ReportResults(Summary, TestLabels, [], Metadata, Params);

ErrorRate = Summary.ErrorRate;

fprintf('-> Experiment "%s" completed. Duration: %f.\n', Params.Experiment, toc);
end
function [ErrorRate] = HyperParameterOptimization_Trial(TTS, Params, Metadata, ...
    K,C, ...
    Kernel, Exp_Id, Kernel_Type, Kernel_Name)

tic;
Params.Experiment = sprintf('Exp_%d_%d', Params.Data.S, Exp_Id);
%FUTURE: We might make naming wiser

fprintf('-> Running experiment "%s" ...\n', Params.Experiment);

Params.Train.Kmeans.K = K;
Params.Train.SVM.C = C;
Params.Train.SVM.Kernel = Kernel_Type{Kernel};
Params.Train.SVM.KernelName = Kernel_Name{Kernel};

TrainData = TTS.TrainData;
TrainLabels = TTS.TrainLabels;
TestData = TTS.ValData;
TestLabels = TTS.ValLabels;

%%
[TrainDataRep] = Prepare(TrainData, Params.Prepare);

Model = Train(TrainDataRep, TrainLabels, Params.Train);

%%
[TestDataRep] = Prepare(TestData, Params.Prepare);

Results = Test(Model, TestDataRep);

Summary = Evaluate(Results, TestLabels, Params.Summary);
ReportResults(Summary, TestLabels, [], Metadata, Params);

ErrorRate = Summary.ErrorRate;

fprintf('-> Experiment "%s" completed. Duration: %f.\n', Params.Experiment, toc);
end
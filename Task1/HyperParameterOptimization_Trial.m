function [ErrorRate] = HyperParameterOptimization_Trial(TTS, Params, K,C, ...
    Kernel, Exp_Id, Kernel_Type, Kernel_Name)

tic;
Params.Experiment = sprintf('Exp_%d_%d', Params.Data.S, Exp_Id);
%FUTURE: We might make naming wiser

fprintf('-> Running experiment "%s" ...\n', Params.Experiment);

CacheParams = Params.Cache;

Params.Train.Kmeans.K = K;
Params.Train.SVM.C = C;
Params.Train.SVM.Kernel = Kernel_Type{Kernel};
Params.Train.SVM.KernelName = Kernel_Name{Kernel};

TrainData = TTS.TrainData;
TrainLabels = TTS.TrainLabels;
TestData = TTS.ValData;
TestLabels = TTS.ValLabels;

%%
if CacheParams.UseCacheForTrainPrepare && ...
        exist(CacheParams.CacheForTrainPrepare, 'file')
    fprintf('Loading Cache for TrainPrepare ...\n');
    load(CacheParams.CacheForTrainPrepare);
else
    [TrainDataRep] = Prepare(TrainData, Params.Prepare);
    save(CacheParams.CacheForTrainPrepare, 'TrainDataRep');
end

if CacheParams.UseCacheForTrain && ...
        exist(CacheParams.CacheForTrain, 'file')
    fprintf('Loading Cache for Train ...\n');
    load(CacheParams.CacheForTrain);
else
    Model = Train(TrainDataRep, TrainLabels, Params.Train);
    if CacheParams.UseCacheForTrain
        save(CacheParams.CacheForTrain, 'Model');
    end
end

%%
if CacheParams.UseCacheForTestPrepare && ...
        exist(CacheParams.CacheForTestPrepare, 'file')
    fprintf('Loading Cache for TestPrepare ...\n');
    load(CacheParams.CacheForTestPrepare);
else
    [TestDataRep] = Prepare(TestData, Params.Prepare);
    save(CacheParams.CacheForTestPrepare, 'TestDataRep');
end

Results = Test(Model, TestDataRep);

Summary = Evaluate(Results, TestLabels, Params.Summary);
ReportResults(Summary, Params);

ErrorRate = Summary.ErrorRate;

fprintf('-> Experiment "%s" completed. Duration: %f.\n', Params.Experiment, toc);
end
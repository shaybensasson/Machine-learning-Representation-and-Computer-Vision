clc; clear; close all;
%% includes
addpath('Helpers');
%addpath('svm_v0.56');
addpath('AngliaSVM');
run matconvnet-1.0-beta17/matlab/vl_setupnn

%% Prepare Cross experiment Parameters
Params = GetDefaultParameters();

rng(Params.Rseed); % Seed the random number generator

Params.Experiment = 'Exp_00';

CacheParams = Params.Cache; % cache usage parametrs
if (~CacheParams.UseCache)
    fprintf('NOTICE: UseCache IS DISABLED.\n');
end

%create cache dir if missing
if (~exist(CacheParams.CachePath, 'dir'))
    mkdir(CacheParams.CachePath);
end
    
%% Get data and split it
tTotal = tic;

% check if cache exist, if so load previous cached data, else apply the
% relevant function
if (IsGetDataCacheValid(Params.Data, CacheParams))
    fprintf('Loading Cache for GetData ...\n');
    load(CacheParams.CacheForGetData, 'Data', 'Labels', 'Metadata');
else
    [ Data, Labels, Metadata ] = GetData(Params.Data);  % load data from file
    save(CacheParams.CacheForGetData, 'Data', 'Labels', 'Metadata', 'Params'); 
end

% shuffle and split the data for train & test. 
[ TrainData, TestData , TrainLabels, TestLabels, ~, TestIndices] = ...
    TrainTestSplit(Data, Labels, Params.Split);
clearvars Data Labels % delete unused variable, memory cleanup

%% Prepare
% check if cache exist, if so load previous cached data, else apply the
% relevant function
if CacheParams.UseCacheForTrainPrepare && ...
        exist(CacheParams.CacheForTrainPrepare, 'file')
    fprintf('Loading Cache for TrainPrepare ...\n');
    load(CacheParams.CacheForTrainPrepare);
else
    IsTrain = true; % the train flag states if to use data augmentation (clasicly, augmentation is applied only to the training set)
    % Run all train data in the network to get the network data representation after applying data augmentation.
    [TrainDataRep, TrainLabels] = Prepare(TrainData, IsTrain, TrainLabels, Params.Prepare); 
    save(CacheParams.CacheForTrainPrepare, 'TrainDataRep', 'TrainLabels');
end
clearvars TrainData % delete unused variable

%% train

% check if cache exist, if so load previous cached data, else apply the
% relevant function
if CacheParams.UseCacheForTrain && ...
        exist(CacheParams.CacheForTrain, 'file')
    fprintf('Loading Cache for Train ...\n');
    load(CacheParams.CacheForTrain);
else
    Model = Train(TrainDataRep, TrainLabels, Params.Train); % trian the svm model on the representation extracted from alexnet
    save(CacheParams.CacheForTrain, 'Model');
end

%% prepare test data and predict

% check if cache exist, if so load previous cached data, else apply the
% relevant function
if CacheParams.UseCacheForTestPrepare && ...
        exist(CacheParams.CacheForTestPrepare, 'file')
    fprintf('Loading Cache for TestPrepare ...\n');
    load(CacheParams.CacheForTestPrepare);
else
    IsTrain = false; % the train flag states if to use data augmentation (clasicly, augmentation is applied only to the training set)
        % Run all train data in the network to get the network data representation without applying data augmentation.
    [TestDataRep, ~] = Prepare(TestData, IsTrain, TestLabels, Params.Prepare);
    save(CacheParams.CacheForTestPrepare, 'TestDataRep');
end

% apply the SVM trained on the test data
Results = Test(Model, TestDataRep, Params.Test);

%% Calc stats and report results

%Compute the results statistics and return them as fields of Summary
Summary = Evaluate(Results, TestLabels, Params.Summary);

fprintf('The experiment took %.2f seconds.\n', toc(tTotal));

%Draws the results figures, reports results to the screen and persists 
ReportResults(Summary, TestLabels, TestIndices, Metadata, Params);






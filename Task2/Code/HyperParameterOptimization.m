clc; clear; close all;
%% includes
addpath('Helpers');
%addpath('svm_v0.56');
addpath('AngliaSVM');
run ../matconvnet-1.0-beta17/matlab/vl_setupnn


%% Prepare Cross experiment Parameters
Params = GetDefaultParameters();

Params.IsHyperParamOptimization = true;
%CACHING Is NOT USED INSIDE HyperParameterOptimization_Trial
%Params.Cache.UseCacheForTrain = false;
%Params.Cache.UseCacheForTrainPrepare = false;
%Params.Cache.UseCacheForTestPrepare = false;

rng(Params.Rseed);     % Seed the random number generator

CacheParams = Params.Cache;
if (~CacheParams.UseCache)
    fprintf('NOTICE: UseCache IS DISABLED.\n');
end

%create cache dir if missing
if (~exist(CacheParams.CachePath, 'dir'))
    mkdir(CacheParams.CachePath);
else
    PurgeCache(Params.Cache); %Purging cache when optimaizng
end

    
%% Get data and split it
tTotal = tic;

if (IsGetDataCacheValid(Params.Data, CacheParams))
    fprintf('Loading Cache for GetData ...\n');
    load(CacheParams.CacheForGetData, 'Data', 'Labels', 'Metadata');
else
    [ Data, Labels, Metadata ] = GetData(Params.Data); 
    save(CacheParams.CacheForGetData, 'Data', 'Labels', 'Metadata', 'Params');
end


TTS = struct();

[ TrainData, ~, TrainLabels, ~] = ...
    TrainTestSplit( Data, Labels, Params.Split);

%IMPORTANT: Validation set is sub set of the train
[ TTS.TrainData, TTS.ValData, TTS.TrainLabels, TTS.ValLabels] = ...
    TrainTestSplit( TrainData, TrainLabels, Params.Split);

%% Gridseach hyper parameter space
C = [0.1, 1, 5, 10]; %SVM tradeoff param

%Test
%C = [1]; %SVM tradeoff param
%Kernel = [2];

Kernel_Type = {linear, polynomial(2), polynomial(3), rbf(0.5), rbf(2)};
Kernel_Name = {'lin', 'poly(2)', 'poly(3)', 'rbf(0.5)', 'rbf(2)'};
Kernel = 1:length(Kernel_Type);

[C_,Kernel_] = ndgrid(C, Kernel);

%% Test every quad combination
Exp_Id = reshape(1:numel(C_), size(C_));
fitresult = arrayfun(@(c,kernel,exp_id)  ...
    HyperParameterOptimization_Trial( ...
        TTS,Params, Metadata, ...
        c,kernel,exp_id, Kernel_Type, Kernel_Name), ...
    C_,Kernel_, Exp_Id); 

[~, minidx] = min(fitresult(:));

C_ = C_(:);
Kernel_ = Kernel_(:);

fitresult = fitresult(:);

N_TRIALS = length(fitresult);
TrialNum = transpose(1:N_TRIALS);
T = table(TrialNum, C_, Kernel_,fitresult);
%T


c = fitresult;
scatter(TrialNum, fitresult, 40, c, 'd', ...
    'filled', 'MarkerEdgeColor',[0 0 0],...
              'LineWidth',0.5);
alpha(0.7);
xlabel('Trial#');
ylabel('ErrorRate');
xlim([0, N_TRIALS+1]);
ylim([min(fitresult)*0.95, max(fitresult)*1.05]);
colormap(jet);
set(gca,'YTickLabel', arrayfun(@(v) strcat(sprintf('%.2f',v*100),'%'), get(gca,'YTick'), 'UniformOutput', false) ); % Define the tick labels based on the user-defined format
title('HyperParameter gridsearch evaluations');

for i=TrialNum'
    txt = sprintf('C=%d\nKernel=%s', C_(i), ...
        Kernel_Name{Kernel_(i)});
        
    if (i == minidx)
        txt = sprintf('BEST:\n%s', txt);
        fprintf('\n%s\nErrorRate:%f\n', txt, fitresult(i));
        h = text(i+(N_TRIALS*0.01), fitresult(i), txt);
        h.Color = 'red';
        h.FontSize = 9;
    else
        h = text(i+(N_TRIALS*0.01), fitresult(i), txt);
        h.FontSize = 8;
    end
end

fprintf('-> HyperParam Optim completed. Duration: %f.\n', toc(tTotal));
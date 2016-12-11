clc; clear; close all;
%% includes
addpath('Helpers');
%addpath('svm_v0.56');
addpath('AngliaSVM');

addpath('vlfeat-0.9.20/toolbox');
vl_setup();

%% Prepare Cross experiment Parameters
tic;

ClassIndices = 1:10;

Params = GetDefaultParameters();
Params.Data.ClassIndices = ClassIndices;

%Do not use caching here
Params.Cache.UseCacheForTrain = false;

rng(Params.Rseed);     % Seed the random number generator

%ClassIndices = GetRandomCatsPermutation(Params);

CacheParams = Params.Cache;

if (IsGetDataCacheValid(Params.Data, CacheParams))
    fprintf('Loading Cache for GetData ...\n');
    load(CacheParams.CacheForGetData, 'Data', 'Labels');
else
    [ Data, Labels ] = GetData(Params.Data);
    save(CacheParams.CacheForGetData, 'Data', 'Labels', 'Params');
end

TTS = struct();
[ TTS.TrainData, TTS.ValData, TTS.TrainLabels, TTS.ValLabels] = ...
    TrainTestSplit( Data, Labels, Params.Split);

%% Gridseach hyper parameter space
%TODO: REMEMBER TO CLEAR CACHE WHEN CHANGING S!!!
%S = [100, 200]; %the image size
Params.Data.S = 200;
%we do not optimize S in here, because data loading must be before TTS,
% and TTS runs before any experiment runs

K = [100, 200, 300, 500, 700, 900]; %K representatives for Kmeans
C = [0.1, 1, 5, 10]; %SVM tradeoff param

%Test
%K = [200, 300];
%C = [1]; %SVM tradeoff param
%Kernel = 1:1;

Kernel_Type = {linear, polynomial(2), polynomial(3), rbf(0.5), rbf(2)};
Kernel_Name = {'lin', 'poly(2)', 'poly(3)', 'rbf(0.5)', 'rbf(2)'};
Kernel = 1:length(Kernel_Type);

[K_,C_,Kernel_] = ndgrid(K, C, Kernel);

%% Test every quad combination
Exp_Id = reshape(1:numel(K_), size(K_));
fitresult = arrayfun(@(k,c,kernel,exp_id)  ...
    HyperParameterOptimization_Trial( ...
        TTS,Params, k,c,kernel,exp_id, Kernel_Type, Kernel_Name), ...
    K_,C_,Kernel_, Exp_Id); 

[~, minidx] = min(fitresult(:));

K_ = K_(:);
C_ = C_(:);
Kernel_ = Kernel_(:);

fitresult = fitresult(:);

N_TRIALS = length(fitresult);
TrialNum = transpose(1:N_TRIALS);
T = table(TrialNum, K_, C_, Kernel_,fitresult);
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
    txt = sprintf('K=%d\nC=%d\nKernel=%s', K_(i), C_(i), ...
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

fprintf('-> HyperParam Optim completed. Duration: %f.\n', toc);
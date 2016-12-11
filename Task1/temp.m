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

%{
[ TrainData2, ValData, TrainLabels, ValLabels  ]= TrainTestSplit( TrainData, Params.Split), 
loop(values of a field in parameters): 
    TrainDataRep2 = Prepare(TrainData2, Params.Prepare);
    Model = Train( TrainDataRep2, TrainLabels, Params.Train)
    ValDataRep = Prepare(ValidationData, Params.Preapre);
    Results = Test(Model , ValDataRep)
    Summary(i)  = Evaluate(Results, ValLabels, Params.Summary), 
%}

%print BestParams
%%


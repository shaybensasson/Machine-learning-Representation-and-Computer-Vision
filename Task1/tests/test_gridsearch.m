%firstparam = [1, 2, 3.3, 3.7, 8, 21];  %list of places to search for first parameter
%secondparam = linspace(0,1,20);        %list of places to search for second parameter


firstparam = [1,2,3,4]; 
secondparam = [3, 6];

%%
[F,S] = ndgrid(firstparam, secondparam);

%run a fitting on every pair fittingfunction(F(J,K), S(J,K))
fitresult = arrayfun(@(p1,p2) fittingfunction(p1,p2), F, S); 

[~, minidx] = min(fitresult(:));
bestFirst = F(minidx);
bestSecond = S(minidx);

F = F(:);
S = S(:);
fitresult = fitresult(:);

%[fitresult, indexes] = sort(fitresult, 'ascend');
%F = F(indexes);
%S = S(indexes);

N_TRIALS = length(fitresult);
TrialNum = transpose(1:N_TRIALS);
T = table(TrialNum, F,S, fitresult);
T

title('HyperParameter gridsearch evaluations');
c = fitresult;
scatter(TrialNum, fitresult, 40, c, 'd', ...
    'filled', 'MarkerEdgeColor',[0 0 0],...
              'LineWidth',0.5);
alpha(0.6);
xlabel('Trial#');
ylabel('Cost');
xlim([0, N_TRIALS+1]);
ylim([min(fitresult)*1.05, max(fitresult)*0.95]);

colormap(jet);

for i=TrialNum'
    txt = sprintf('F=%d\nS=%d', F(i), S(i));
    
    if (i == minidx)
        
        txt = {'BEST:', txt};
        h = text(i+(N_TRIALS*0.01), fitresult(i), txt);
        h.Color = 'red';
        h.FontSize = 12;
    else
        h = text(i+(N_TRIALS*0.01), fitresult(i), txt);
    end
end

%x = [0.3,0.5];
%y = [0.6,0.5];

x = [0.3, 0.5];
y = [0.3, 0.5];

function cost = fittingfunction(p1,p2)
    cost = -1*(p1+p2);
end


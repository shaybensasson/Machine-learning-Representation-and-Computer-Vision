load('Results\workspace_smaller_c.mat');


N_TRIALS = length(fitresult);
TrialNum = transpose(1:N_TRIALS);
T = table(TrialNum, C_, Kernel_,fitresult);
%T


sz = C_;
c = Kernel_;

figure;
marker_types = {'s','o','d','p','h', 'x'};
for k=1:length(Kernel)
    Tk = T(T.Kernel_ == k, :);
    
    %sz = Tk.C_ * 100;
    sz = 100;
    scatter(Tk.TrialNum, Tk.fitresult, sz, marker_types{k}, ...
        'filled', 'MarkerEdgeColor',[0 0 0],...
        'LineWidth',0.5);
    alpha(0.7)
    
    
    for i=1:length(Tk.TrialNum)
        txt = stripzeros(sprintf('C=%.3f', ...
            Tk.C_(i)));
        
        h = text(Tk.TrialNum(i), Tk.fitresult(i)*1.01, txt);
        h.FontSize = 10;
    end
    
    
    colormap jet
    hold on
end

set(gca,'XTickLabel',{' '})
ylabel('Validation Error Rate');
xlim([0, N_TRIALS+1]);
%ylim([0, max(fitresult)*1.05]);

set(gca,'YTickLabel', arrayfun(@(v) strcat(sprintf('%.2f',v*100),'%'), get(gca,'YTick'), 'UniformOutput', false) ); % Define the tick labels based on the user-defined format
title('HyperParameter gridsearch evaluations', 'FontSize', 14);

h = legend(Kernel_Name, 'Location', 'best', 'Orientation', 'horizontal');
h.FontSize = 12;

%%
txt = sprintf('BEST PARAMS (ValErr=%.3f%s):\nC=%.3f, Kernel=%s', ...
    fitresult(minidx)*100, '%', C_(minidx), Kernel_Name{Kernel_(minidx)});

scatter(T.TrialNum(minidx, 1), T.fitresult(minidx, 1), T.C_(minidx), 'red', marker_types{T.Kernel_(minidx,1)}, ...
    'filled', 'MarkerEdgeColor',[0 0 0],...
    'LineWidth',0.5);


fprintf('\n%s\nErrorRate: %f\n', txt, fitresult(minidx));
h = text(minidx+(N_TRIALS*0.01), fitresult(minidx)*0.8, txt);
h.Color = 'red';
h.FontSize = 12;

%{
%interesting_points = [1, 62]; %100
interesting_points = [1, 61]; %200
for i=1:length(interesting_points)
    idx = interesting_points(i);
    
    txt = sprintf('%.3f%s', ...
        fitresult(idx)*100, '%');
    
    h = text(idx+(N_TRIALS*0.01), fitresult(idx), txt);
    h.FontSize = 12;
end
%}


funcFormatPoint = @(idx) sprintf('#%d (Err=%.5f%s):\nC=%.3f, Kernel=%s', ...
    TrialNum(idx), fitresult(idx)*100, '%', C_(idx), Kernel_Name{Kernel_(idx)});

dcm_obj = datacursormode(gcf);
set(dcm_obj,'enable','on')
set(dcm_obj,'UpdateFcn',{@UpdateToolTip, funcFormatPoint})

function output_txt = UpdateToolTip(obj,event_obj, funcFormat)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text (character vector or cell array of character vectors).

pos = get(event_obj,'Position');
idx = pos(1);
output_txt = funcFormat(idx);

end

function str = stripzeros(strin)
%STRIPZEROS Strip trailing zeros, leaving one digit right of decimal point.
% Remove trailing zeros while leaving at least one digit to the right of
% the decimal place.

% Copyright 2010 The MathWorks, Inc.

str = strin;
n = regexp(str,'\.0*$');
if ~isempty(n)
    % There is nothing but zeros to the right of place itself.
    % Remove all trailing zeros except for the first one.the decimal place;
    % the value in n is the index of the decimal
    str(n+2:end) = [];
else
    % There is a non-zero digit to the right of the decimal place.
    m = regexp(str,'0*$');
    if ~isempty(m)
        % There are trailing zeros, and the value in m is the index of
        % the first trailing zero. Remove them all.
        str(m:end) = [];
    end
end
end

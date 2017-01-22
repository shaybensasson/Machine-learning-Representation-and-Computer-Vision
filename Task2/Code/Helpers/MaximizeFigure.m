function MaximizeFigure(hf, iMonitor)
%MAXIMIZEFIGURE maximizes a figure on a given screen
if (nargin == 0) %DEMO
    close all;
    hf = figure('Name', 'Monitor1');
    imagesc(randi(10, 100, 100)); axis tight;
    maximizeFigure(hf);
        
    hf = figure('Name', 'Monitor2');
    imagesc(randi(10, 100, 100)); axis tight;
    maximizeFigure(hf, 2);
    
    return;
end

if (nargin < 2)
    iMonitor = 1;
end

MP = get(0, 'MonitorPositions');

if size(MP, 1) == 1  % Single monitor
    iMonitor = 1;
end

curPos = get(hf, 'Position');
%ensure figure on selected monitor
set(hf, 'Position', [MP(iMonitor, 1:2), curPos(3:4)]);

pause(0.00001);

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');

jFig = get(hf, 'JavaFrame');
jFig.setMaximized(true);

warning('on','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
end
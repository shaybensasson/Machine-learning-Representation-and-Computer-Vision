function PlotConfusionMatrix(conf_mat,classes_names)
%This function allows to compute and plot confusion matrix after
%Downloaded from https://www.mathworks.com/matlabcentral/fileexchange/48632-multiclass-svm-classifier/content/DSVM/confusion_matrix.m
%classification process
%Inputs:
%conf_mat: confusion matrix
%classes_names: cell array cotaining names of classes Example: {'AWA','S1','S2','SWS','Rem'}
%Outputs:
%Cmat: confusion matrix values

if (nargin == 0) %DEMO
    conf_mat = eye(5);
    classes_names = {'class1','class2','class3','class5','class5'};
end

conf_mat_prop = zeros(size(conf_mat));

L=size(conf_mat, 1);
for i=1:L
    conf_mat_prop(i,:)=conf_mat(i,:)./sum(conf_mat(i,:));
end

imagesc(conf_mat_prop);colormap(flipud(summer));caxis([0,1])
textstr=num2str(conf_mat(:),'%d');
textstr=strtrim(cellstr(textstr));
[x,y]=meshgrid(1:L);
hstrg=text(x(:),y(:),textstr(:),'HorizontalAlignment','center','FontSize',16,'FontName','Times New Roman');
midvalue=mean(get(gca,'Clim'));
textColors=repmat(conf_mat_prop(:)>midvalue,1,3);
set(hstrg,{'color'},num2cell(textColors,2));
set(gca,'XTick',1:L,'XTickLabel',classes_names,'YTick',1:L,'YTickLabel',classes_names,'TickLength',[0,0],'FontSize',13,'FontName','Times New Roman');
colorbar;
xlabel('Predicted');
ylabel('Actual');
set(gca,'XAxisLocation','top');
title('Confusion matrix');
end
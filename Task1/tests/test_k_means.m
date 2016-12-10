close all; clear; clc;
numData = 5000 ;
dimension = 2 ;
A = rand(dimension,numData) ;

numClusters = 30;
[centers, assignments, E] = vl_kmeans(A, numClusters); %dimsXsamples

scatter(A(1,:), A(2,:), [], assignments);
colormap hsv
hold on;
scatter(centers(1,:), centers(2,:), [], 'k', 'filled');


%Given a new data point x, this can be mapped to one of the clusters by looking for the closest center:
x = rand(dimension, 10) ;

[~, k] = min(vl_alldist(x, centers)) ; 
k
%hold off
scatter(x(1,:), x(2,:), 80, 'r', 'd', 'filled', ...
              'MarkerEdgeColor', 'k',...
              'MarkerFaceColor', 'r',...
              'LineWidth',1.5);
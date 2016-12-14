clc; close all; clear;

%randn('state',0) ;
%rand('state',0) ;
%{
% read a test image
img = imread(fullfile(vl_root,'data','roofs1.jpg')) ;
image(img);

img = rgb2gray(img);
%img = imresize(img, [200 200]);
%imshow(img)

hold on;

img = single(img);
%}

img = zeros(100,500) ;
for i=[10 20 30 40 50 60 70 80 90]
img(50-round(i/3):50+round(i/3),i*5) = 1 ;
end
img = 2*pi*8^2 * vl_imsmooth(img,8) ;
img = single(255 * img) ;
image(img)

scale = 8;
stride = 1;

%[fOLD,dOLD] = vl_sift(img, 'verbose') ;
vl_twister('STATE', 2016); %Seed the random number generator of KMEANS, EXTEREMLY IMPORTANT!

[f, d] = vl_dsift(img, ...
    'size', scale, ...
    'step', stride, ...
    'floatdescriptors', ...
    'norm', ...
    'fast', ...
    'verbose');
            
%sel = randperm(size(f,2), 10);
rng(2016);
sel = randperm(size(f,2), 10);
h1 = vl_plotframe(f(:,sel)) ;
h2 = vl_plotframe(f(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;

h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
set(h3,'color','g') ;
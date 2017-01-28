% Try out Alexnet


vl_testnn
%%

%http://www.cc.gatech.edu/~hays/compvision/proj6/

% run the CNN

tic
res = vl_simplenn(net, single(TrainData(:,:,:,2))) ;
toc
% res(i+1).x: the output of layer i. Hence res(1).x is the network input.

VecRep = squeeze(res(22).x);




%%

opts.modelType = 'alexnet' ;
opts.networkType = 'simplenn' ;
opts.batchNormalization = true ;
opts.weightInitMethod = 'gaussian' ;
[opts, varargin] = vl_argparse(opts, varargin) ;

sfx = opts.modelType ;
if opts.batchNormalization, sfx = [sfx '-bnorm'] ; end
sfx = [sfx '-' opts.networkType] ;
opts.expDir = fullfile('data', ['imagenet12-' sfx]) ;
[opts, varargin] = vl_argparse(opts, varargin) ;

opts.numFetchThreads = 12 ;
opts.lite = false ;
%opts.imdbPath = fullfile(opts.expDir, 'imdb.mat');
opts.train = struct([]) ;
[opts] = vl_argparse(opts, varargin) ;

% -------------------------------------------------------------------------
%                                                             Prepare model
% -------------------------------------------------------------------------

net = cnn_imagenet_init('model', opts.modelType, ...
                        'batchNormalization', opts.batchNormalization, ...
                        'weightInitMethod', opts.weightInitMethod, ...
                        'networkType', opts.networkType) ;
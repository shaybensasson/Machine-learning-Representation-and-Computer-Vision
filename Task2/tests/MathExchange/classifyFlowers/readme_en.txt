< Description of each programs >

classifyFlowers.m
--> Classify the similar flowers, 'Dandelion' and 'ColtsFoot'

searchSimilarFlowers.m
--> Search flowers similar to a certain flower using KNN
--> This program uses the image data folder 'FlowerMixed'

detectAnomaly.m
--> Sort flowers according to anomaly scores which 1-class SVM calculates
--> This program uses the image data folder 'ImagesWithAnomalies'

We use the pretrained model, Alex Net which MatConvNet provides.
Alex Net is used as the base model of transfer learning.

About MatConvNet :
http://www.vlfeat.org/matconvnet/

We also use image data from Oxford Flower Dataset.

About Oxford Flower Dataset :
http://www.robots.ox.ac.uk/~vgg/data/flowers/17/index.html

< What's You Need >

- MATLAB newer than R2016a
- Neural Network Toolbox
- Parallel Computing Toolbox
- Statistics and Machine Learning Toolbox
- Image Processing Toolbox
- Computer Vision System Toolbox

- GPU Card (Compute Capability >= 3.0)

Caution!!) You cannot use GPUs of new architecture Pascal (Geforce GTX 1080/1070/1060 and new Titan X)


< Patches >

If you are using R2016a, please apply these patches:

Computer Vision System Toolbox : 1373603
Neural Network Toolbox : 1350931, 1353529

You can download patches from here:

http://jp.mathworks.com/support/bugreports/


< Preparation >

1. Download the pretrained model

>> url = 'http://www.vlfeat.org/matconvnet/models/beta16/imagenet-caffe-alex.mat'
>> websave('imagenet-caffe-alex.mat', url)

2. Setting up data folders (Download image data)

>> setupScript


Copyright 2016 The MathWorks, Inc.

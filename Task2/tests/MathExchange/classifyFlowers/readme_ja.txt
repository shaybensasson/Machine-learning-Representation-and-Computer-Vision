< 各プログラムの概要 >

classifyFlowers.m
--> タンポポとフキタンポポという似た花を分類します

searchSimilarFlowers.m
--> KNNを使って、特定の花の画像に似た花の画像を見つけ出します
--> このコードは、FlowerMixed というフォルダにあるデータを使います

detectAnomaly.m
--> 1クラス SVM の計算する異常スコアに沿って画像をソートします（異常検出）
--> このコードは、ImagesWithAnomalies というフォルダにあるデータを使います。

このコードでは、MatConvNetが提供している学習済みのモデル（Alex Net）を使います。
Alex Net は転移学習のベースとして使うモデルです。

MatConvNet について :
http://www.vlfeat.org/matconvnet/

画像データは Oxford Flower Dataset のものを使っています。

Oxford Flower Dataset について :
http://www.robots.ox.ac.uk/~vgg/data/flowers/17/index.html

< 必要となるもの >

- MATLAB newer than R2016a
- Neural Network Toolbox
- Parallel Computing Toolbox
- Statistics and Machine Learning Toolbox
- Image Processing Toolbox
- Computer Vision System Toolbox

- GPU Card (Compute Capability >= 3.0)

注意!!) Geforce GTX 1080/1070/1060 や新しい Titan X などの新しいアーキテクチャのGPUは使えません。


< パッチについて >

R2016a をご利用の場合は、次のパッチを当てて下さい。

Computer Vision System Toolbox : 1373603
Neural Network Toolbox : 1350931, 1353529

パッチはこちらからダウンロードできます。

http://jp.mathworks.com/support/bugreports/


< 準備作業 >

1. 学習済みモデルのダウンロード

>> url = 'http://www.vlfeat.org/matconvnet/models/beta16/imagenet-caffe-alex.mat'
>> websave('imagenet-caffe-alex.mat', url)

2. データフォルダのセットアップ（画像のダウンロード）

>> setupScript


Copyright 2016 The MathWorks, Inc.


< �e�v���O�����̊T�v >

classifyFlowers.m
--> �^���|�|�ƃt�L�^���|�|�Ƃ��������Ԃ𕪗ނ��܂�

searchSimilarFlowers.m
--> KNN���g���āA����̉Ԃ̉摜�Ɏ����Ԃ̉摜�������o���܂�
--> ���̃R�[�h�́AFlowerMixed �Ƃ����t�H���_�ɂ���f�[�^���g���܂�

detectAnomaly.m
--> 1�N���X SVM �̌v�Z����ُ�X�R�A�ɉ����ĉ摜���\�[�g���܂��i�ُ팟�o�j
--> ���̃R�[�h�́AImagesWithAnomalies �Ƃ����t�H���_�ɂ���f�[�^���g���܂��B

���̃R�[�h�ł́AMatConvNet���񋟂��Ă���w�K�ς݂̃��f���iAlex Net�j���g���܂��B
Alex Net �͓]�ڊw�K�̃x�[�X�Ƃ��Ďg�����f���ł��B

MatConvNet �ɂ��� :
http://www.vlfeat.org/matconvnet/

�摜�f�[�^�� Oxford Flower Dataset �̂��̂��g���Ă��܂��B

Oxford Flower Dataset �ɂ��� :
http://www.robots.ox.ac.uk/~vgg/data/flowers/17/index.html

< �K�v�ƂȂ���� >

- MATLAB newer than R2016a
- Neural Network Toolbox
- Parallel Computing Toolbox
- Statistics and Machine Learning Toolbox
- Image Processing Toolbox
- Computer Vision System Toolbox

- GPU Card (Compute Capability >= 3.0)

����!!) Geforce GTX 1080/1070/1060 ��V���� Titan X �Ȃǂ̐V�����A�[�L�e�N�`����GPU�͎g���܂���B


< �p�b�`�ɂ��� >

R2016a �������p�̏ꍇ�́A���̃p�b�`�𓖂Ăĉ������B

Computer Vision System Toolbox : 1373603
Neural Network Toolbox : 1350931, 1353529

�p�b�`�͂����炩��_�E�����[�h�ł��܂��B

http://jp.mathworks.com/support/bugreports/


< ������� >

1. �w�K�ς݃��f���̃_�E�����[�h

>> url = 'http://www.vlfeat.org/matconvnet/models/beta16/imagenet-caffe-alex.mat'
>> websave('imagenet-caffe-alex.mat', url)

2. �f�[�^�t�H���_�̃Z�b�g�A�b�v�i�摜�̃_�E�����[�h�j

>> setupScript


Copyright 2016 The MathWorks, Inc.


S = [100, 200]; %the image size
K = [200, 300, 500, 700, 900]; %K representatives for Kmeans
C = [0.1, 1, 5, 10]; %SVM tradeoff param
Kernel = 


%{
[ TrainData2, ValidationData, TrainLabels, ValLabels  ]= TrainTestSplit( TrainData, Params.Split), 
loop(values of a field in parameters): 
    TrainDataRep2 = Prepare(TrainData2, Params.Prepare);
    Model = Train( TrainDataRep2, TrainLabels, Params.Train)
    ValDataRep = Prepare(ValidationData, Params.Preapre);
    Results = Test(Model , ValDataRep)
    Summary(i)  = Evaluate(Results, ValLabels, Params.Summary), 
%}

BestParams
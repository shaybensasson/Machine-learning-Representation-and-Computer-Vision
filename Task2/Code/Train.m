function [Model] = Train(Data, Labels, Params)
%TRAIN Trains binary SVM classifier on nnet representations
    %Store data for svm train
    X = double(Data); %NOTE: svm train requires single
    Y = Labels';
    
    %get params
    tutor = Params.SVM.tutor;
    kernel = Params.SVM.kernel;
    C = Params.SVM.C;
    
    fprintf('training support vector machine on the AlexNet representations ...\n');
            
    %% train binary classifier
    BinaryClasses = double(2*(Y==1)-1); %0,1 to -1,1 column vector
    
    Model.Classifier = train(svc, tutor, X, BinaryClasses, C, kernel);
end


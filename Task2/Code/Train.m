function [Model] = Train(Data, Labels, Params)
%TRAIN Trains binary SVM classifier on nnet representations
    %Store data for svm train
    X = double(Data); %NOTE: svm train requires single
    Y = Labels';
    
    %get params
    tutor = Params.SVM.tutor; %param required by AngliaSVM classifer
    kernel = Params.SVM.kernel; %The underline kernel
    C = Params.SVM.C; %Penalty parameter C of the error term.
    
    fprintf('training support vector machine on the AlexNet representations ...\n');
            
    %% train binary classifier
    BinaryClasses = double(2*(Y==1)-1); %0,1 to -1,1 column vector
    
    Model.Classifier = train(svc, tutor, X, BinaryClasses, C, kernel); %  train SVM
end


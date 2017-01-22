function [Model] = Train(Data, Labels, Params)
%TRAIN Trains binary classifiers of SVM
%   HOG:
%       train binary classifier on the HOG representation in
%       one-versus-all method for each catagory, the function returns the
%       trained model
%   SIFT:
%       Clustering training extracted SIFTS into K clusters, so later we
%       could build histogram for each image that will act as features that
%       will be fed into the SV 1-versus-all binary classifier


    %Turn data to numeric vectors
    X = double(Data); %svm train requires single
    Y = Labels';
    
    tutor = Params.SVM.tutor;
    kernel = Params.SVM.kernel;
    C = Params.SVM.C;
    
    fprintf('training support vector machine on the HOG...\n');
    Cats = [1, -1];
    NumCatag = length(Cats);
    Model.Classifiers = cell(NumCatag,1);
    
    for IndCatag=1:NumCatag
        %train binary classifier in one-versus-all method
        BinaryClasses = double(2*(Y==Cats(IndCatag))-1); %0,1 to -1,1 column vector
        
        %figure;
        %histogram(BinaryClasses);
        %title(sprintf('%d', idxClass));
        Model.Classifiers{IndCatag} = train(svc, tutor, X, BinaryClasses, C, kernel);
        fprintf('%d/%d ', IndCatag, NumCatag);
    end
    fprintf('\n');

end


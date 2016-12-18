function [ MClassSVM ] = MClassSVM_Train( Features, Classes, Params )
%MClassSVM_Train loops through the M classes and trains M binary classifiers in one-versus-all method
%   That is: for classifier i, the examples of class i get the label +1, and the rest of the classes get -1 label.
%	The function returns an MClassSVM structure containing all the M SVM models as fields 
    C = Params.SVM.C;
    kernel = Params.SVM.kernel;
    tutor = Params.SVM.tutor;
    
    M = length(unique(Classes));
    MClassSVM.Classifiers = cell(M,1);
    for idxClass=1:M
        %train binary classifier in one-versus-all method
        fprintf('%d/%d ', idxClass, M);
        BinaryClasses = double(2*(Classes==idxClass)-1)'; %0,1 to -1,1 column vector
        
        %figure;
        %histogram(BinaryClasses);
        %title(sprintf('%d', idxClass));
        MClassSVM.Classifiers{idxClass} = train(svc, tutor, Features, BinaryClasses, C, kernel);
    end
    
    fprintf('\n');
end


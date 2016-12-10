function [ micro, macro ] = MicroMacroPR(confmat)
%computes micro and macro: precision, recall and fscore
%Sandy wltongxing@163.com
%micro>macro?
%mat=confusionmat(orig_label, pred_label);
%label_unique=unique([orig_label(:);pred_label(:)]);
%     microTP=0;
%     microFP=0;
%     microFN=0;

%{
http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.104.8244&rep=rep1&type=pdf

Micro-averaged F-measure gives equal weight to each document and is therefore
considered as an average over all the document/category pairs. It tends to be
dominated by the classifier’s performance on common categories.

Macro-averaged F-measure gives equal
weight to each category, regardless of its frequency. It is influenced more by the
classifier’s performance on rare categories. We provide both measurement scores
to be more informative.
%}
len=size(confmat,1);
macroTP=zeros(len,1);
macroFP=zeros(len,1);
macroFN=zeros(len,1);
macroP=zeros(len,1);
macroR=zeros(len,1);
macroF=zeros(len,1);
for i=1:len
    macroTP(i)=confmat(i,i);
    macroFP(i)=sum(confmat(:, i))-confmat(i,i);
    macroFN(i)=sum(confmat(i,:))-confmat(i,i);
    macroP(i)=macroTP(i)/(macroTP(i)+macroFP(i));
    macroR(i)=macroTP(i)/(macroTP(i)+macroFN(i));
    macroF(i)=2*macroP(i)*macroR(i)/(macroP(i)+macroR(i));
end
macroP(isnan(macroP)) = 0;
macro.precision=mean(macroP);
macroR(isnan(macroR)) = 0;
macro.recall=mean(macroR);
macroF(isnan(macroF)) = 0;
macro.fscore=mean(macroF);

micro.precision=sum(macroTP)/(sum(macroTP)+sum(macroFP));
micro.recall=sum(macroTP)/(sum(macroTP)+sum(macroFN));
micro.fscore=2*micro.precision*micro.recall/(micro.precision+micro.recall);
end
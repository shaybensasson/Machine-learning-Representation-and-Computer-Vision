clc; clear;
A = [randperm(5); randperm(5); randperm(5)]
[M,I] = min(A') %#ok<UDIM>
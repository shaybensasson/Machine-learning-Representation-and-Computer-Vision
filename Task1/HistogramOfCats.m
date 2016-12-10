clc; clear; close all;

rng(2016);
ROOT_DIR = '.\101_ObjectCategories\';
dirs = dir(ROOT_DIR);
dirs = dirs(2:end); %discard . and ..
%N_TOTAL = 30;
N_TOTAL = length(dirs);
perm = randperm(length(dirs), N_TOTAL); %choose random permutation of 30 idxs
dirs = dirs(perm);

%cats_train = {dirs(1:10).name};
%cats_valid = {dirs(11:20).name};
%cats_test = {dirs(21:30).name};

idxs = 1:length(perm);
cats = {dirs(idxs).name};
cnt = zeros(1, length(cats));
for i=1:length(cats)
    d = fullfile(ROOT_DIR, cats{i});
    cnt(i) = length(dir(d));
end

bar(idxs, cnt);


xticks(0:length(cats));
%yticks(0:max(cnt));
axis tight;

set(gca, 'XTickLabel', cats)
set(gca, 'XTickLabelRotation', 45)



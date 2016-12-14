function [cats] = GetAllCategories(ROOT_DIR)
%GetAllCategories Scans all subdirs and returns category names
    if (nargin == 0) %DEMO
        ROOT_DIR = '../101_ObjectCategories/';
    end
    dirs = dir(ROOT_DIR);
    dirs = dirs(3:end); %discard . and ..
    cats = {dirs.name};
end

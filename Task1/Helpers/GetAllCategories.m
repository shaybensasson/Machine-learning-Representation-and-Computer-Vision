function [cats] = GetAllCategories(ROOT_DIR)
%GetAllCategories Scans all subdirs and returns category names
    if (nargin == 0) %DEMO
        ROOT_DIR = '../101_ObjectCategories/';
    end
    dirs = dir(ROOT_DIR);
    dirs = dirs(3:end); %discard . and ..
    dirFlags = [dirs.isdir]; % check if dir
    dirs = dirs(dirFlags);
    cats = {dirs.name};
    
    % Extra filtering
    crit = '^[^.]+';
    
    % return cell array of results, [] if no match
    rxResult = regexp( cats, crit ); 

    % loop over all cells, set true if regex matched
    nodot = (cellfun('isempty', rxResult)==0);

    rxResult = strfind(cats, 'BACKGROUND_Google');
    noDriveFile =  (cellfun('isempty', rxResult)==0);

    % The `nodot` array is a logical array telling us which are "good" files. 
    cats = cats(nodot & ~noDriveFile);
    
end

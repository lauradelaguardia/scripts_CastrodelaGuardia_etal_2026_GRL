% definition of the stations. 

function [STNx]=select_stations(fjordname,type)

if strcmp(type,'all')
    % take all stations sampled
    if strcmp(fjordname,'3Miippugut')
        STNx = [10 9 8 7 6 5 4 3 2 1 11]; % order as in Lea's data
    elseif strcmp(fjordname,'Flado')
        STNx = [7 6 5 4 3 2 1 8]; % do not plot sataion 8
    elseif strcmp(fjordname,'Kivioq')
        STNx = [1 2 3 4 5 6];
    end
    %take the stations from the GF front
elseif strcmp(type,'GF')
    % Only stations at the glacier front (excludes river and far stations)
    if strcmp(fjordname,'3Miippugut')
        STNx = [7 6 5 4 3 2 1]; 
    elseif strcmp(fjordname,'Flado')
        STNx = [7 6 5 4 3 2 1]; 
    elseif strcmp(fjordname,'Kivioq')
        STNx = [1 2 3 4 5 6];
    end

    % take stations from where there is no plume
elseif strcmp(type,'NoPlume') % no plume
    if strcmp(fjordname,'3Miippugut')
        STNx = [7 5 4 3 2 1]; 
    elseif strcmp(fjordname,'Flado')
        STNx = [6 5 3 2 1]; 
      
    elseif strcmp(fjordname,'Kivioq')
        STNx = [1 2 3];
    end
    % take the stations with the plume
elseif strcmp(type,'Plume') %plume station
    if strcmp(fjordname,'3Miippugut')
        STNx = [6];
    elseif strcmp(fjordname,'Flado')
        STNx = [4]; 
    elseif strcmp(fjordname,'Kivioq')
        STNx = [4 5 6];
    end

    % take the stations to contract far and close from the glacier front
elseif strcmp(type,'Far') % far from glacier front
    if strcmp(fjordname,'3Miippugut')
        STNx = [11,4]; % 8 contrast with 7, 11 contrast with 4 (based on the map)
    elseif strcmp(fjordname,'Flado')
        STNx = [8,7]; % contrast with  7
    elseif strcmp(fjordname,'Kivioq')
        STNx = []; % no stations far from GF

    end
elseif strcmp(type, 'river')
    if strcmp(fjordname,'3Miippugut')
        STNx = [10 9 8]; % order as in Lea's data
    elseif strcmp(fjordname,'Flado')
        STNx = [7]; % do not plot sataion 8
    else
        STNx = [];
    end

end
function setOfPlanes = myTest(inputDataName)
%inputDataName = 'cub_minus_cyl';
    inputDirectory = dir(inputDataName);
    
    % Remove files instead of directories
    indices = zeros(1,numel(inputDirectory));
    for i = 1:numel(inputDirectory)
        indices(i) = inputDirectory(i).isdir;
    end
    inputDirectory = inputDirectory(logical(indices));
    
    % Get a point-cloud labeled into plane and info about plane
    num_data = numel(inputDirectory);
    input_pc = zeros(1,8); %initialization for concatenating matrices vertically
    setOfPlanes = zeros(1,11); %initialization for concatenating matrices vertically
    for i = 3 : num_data % the idx of the 1st data starts from 3
        % Load data if the current cluster is labeled into plane.
        currClusterPath = append(inputDataName, '/', inputDirectory(i).name);
        currPriInfoPath = append(currClusterPath, '/pc.fit');
        fileID = fopen(currPriInfoPath,'r'); %After reading 'plane', read plane parameter
        currPriType = fscanf(fileID, '%s', [1 1]);
        if strcmp(currPriType, 'plane')
            planeInfo = fscanf(fileID, '%f', [4 1]);
            planeInfo = planeInfo';
            fclose(fileID);
            
            % Load a PC
            currPCPath = append(currClusterPath, '/pc.segps');
            fileID = fopen(currPCPath,'r');
            curr_pc = fscanf(fileID, '%f', [8 Inf]);
            curr_pc = curr_pc';
            fclose(fileID);
            input_pc = [input_pc; curr_pc];
            
            % Load info about the plane
            xlim = [min(curr_pc(:,1)), max(curr_pc(:,1))];
            ylim = [min(curr_pc(:,2)), max(curr_pc(:,2))];
            zlim = [min(curr_pc(:,3)), max(curr_pc(:,3))];
            setOfPlanes = [setOfPlanes; i-2, planeInfo, xlim, ylim, zlim]; % the idx of the 1st data starts from 3
        else
            fclose(fileID);
        end
    end
    input_pc = input_pc(2:end,:);  %Remove the extra rows
    setOfPlanes = setOfPlanes(2:end,:);  %Remove the extra rows
    inputPC = pointCloud(input_pc(:,1:3), 'Normal', input_pc(:,4:6));
    
    findUnionOfCuboids(inputPC,setOfPlanes(:,2:11));
end
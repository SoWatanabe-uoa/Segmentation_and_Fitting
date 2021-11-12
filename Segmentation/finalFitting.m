function finalFitting(inputDirectoryName, outputDirectoryName)
% This script and a "input" directory should be the same directory.
%
% A "input" directory has 1 sub-directory per input point-cloud. 
% Each sub-directory has the clustered point-cloud and a .conf file for RANSAC.
%
% A "output" directory has 1 sub-directory per point-cloud. 

    inputDirectory = dir(inputDirectoryName);
    num_data = numel(inputDirectory);
    mkdir(outputDirectoryName);
    
    %Create the output directory
    for i = 3 : num_data % the idx of the 1st data starts from 3
        subDirectoryPath = append(outputDirectoryName, '/', inputDirectory(i).name);
        mkdir(subDirectoryPath);
    end
    
    % Do final fitting per each data
    for i = 3 : num_data
        % Load a point-cloud
        currDataPath = append(inputDirectoryName, '/', inputDirectory(i).name);
        curr_data = append(currDataPath, '/pc-clustered2.segps');
        fileID = fopen(curr_data,'r');
        curr_pc = fscanf(fileID, '%f', [8 Inf]);
        curr_pc = curr_pc';
        fclose(fileID);
        
        % Create the sub-directoies which include a point-cloud with
        % normals on each cluster
        cids = curr_pc(:,8);
        uniq_cids = unique(cids);
        num_cids = length(uniq_cids);
        for j = 1:num_cids
            curr_id = uniq_cids(j);
            subDirectoryPath = append(outputDirectoryName, '/', inputDirectory(i).name, '/cluster', string(curr_id));
            mkdir(subDirectoryPath);
            curr_cluster = curr_pc(curr_pc(:,8)==curr_id, 1:6);
            %Write the current cluster data into the output file
            output_fileName = append(subDirectoryPath, '/pc.xyzn');
            fileID = fopen(output_fileName,'w');
            point_num = size(curr_cluster, 1);
            for k = 1:point_num
                fprintf(fileID,'%f %f %f %f %f %f\n',curr_cluster(k,:));
            end
            fclose(fileID);
        end
        
        % Run RANSAC on each cluster
        %{
        clusterDirectory = dir(currDataPath);
        num_cluster = numel(clusterDirectory);
        for j = 3 : num_cluster
            ransacInputDataPath = append(currDataPath, '/', clusterDirectory(j).name);
            outputResultPath = ransacInputDataPath;
            command = append('orig_ransac_command.exe ', ransacInputDataPath, '/', 'pc.xyzn ', outputResultPath, '/', 'pc.segps ', currDataPath, '/', 'parameters.conf');
            diary ransac_log.txt
            system(command);
            diary off
            movefile('ransac_log.txt',outputResultPath);
        end
        
        % Combine the results on each cluster into one .segps file
        
        % Merging procedure
        %}
    end

end
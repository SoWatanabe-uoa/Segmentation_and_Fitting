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
        outputSubDirectoryPath = append(outputDirectoryName, '/', inputDirectory(i).name);
        mkdir(outputSubDirectoryPath);
    end
    
    % Do final fitting per each data
    for i = 3 : num_data
        % Load a point-cloud
        currInputDataPath = append(inputDirectoryName, '/', inputDirectory(i).name);
        curr_data = append(currInputDataPath, '/pc-clustered2.segps');
        fileID = fopen(curr_data,'r');
        curr_pc = fscanf(fileID, '%f', [8 Inf]);
        curr_pc = curr_pc';
        fclose(fileID);
        
        % Create the sub-directoies which include a point-cloud with
        % normals and on each cluster
        cids = curr_pc(:,8);
        uniq_cids = unique(cids);
        num_cids = length(uniq_cids);
        for j = 1:num_cids
            curr_id = uniq_cids(j);
            clusterDirectoryPath = append(outputDirectoryName, '/', inputDirectory(i).name, '/cluster', string(curr_id));
            mkdir(clusterDirectoryPath);
            curr_cluster = curr_pc(curr_pc(:,8)==curr_id,:);
            uniq_pid = mode(unique(curr_cluster(:,7)));
            %if length(uniq_pids) == 1 %if points in a given cluster do NOT have different primitive types
                % Write the current cluster data and .conf file with parameters corresponding to 
                % the fixed primitive type into the output file
                output_fileName = append(clusterDirectoryPath, '/pc.xyzn');
                fileID = fopen(output_fileName,'w');
                point_num = size(curr_cluster, 1);
                for k = 1:point_num
                    fprintf(fileID,'%f %f %f %f %f %f\n',curr_cluster(k,1:6));
                end
                fclose(fileID);
                
                inputConfFilePath = append(currInputDataPath, '/parameters.conf');
                copyfile(inputConfFilePath, clusterDirectoryPath);
                outputConfFilePath = append(clusterDirectoryPath, '/parameters.conf');
                fileID = fopen(outputConfFilePath,'a');
                switch uniq_pid
                    case 0
                        use_plane = '# bool use_plane 1';
                        use_sphere = '# bool use_sphere 0';
                        use_cylinder = '# bool use_cylinder 0';
                        use_cone = '# bool use_cone 0';
                        use_torus = '# bool use_torus 0';
                    case 1
                        use_plane = '# bool use_plane 0';
                        use_sphere = '# bool use_sphere 1';
                        use_cylinder = '# bool use_cylinder 0';
                        use_cone = '# bool use_cone 0';
                        use_torus = '# bool use_torus 0';
                    case 2
                        use_plane = '# bool use_plane 0';
                        use_sphere = '# bool use_sphere 0';
                        use_cylinder = '# bool use_cylinder 1';
                        use_cone = '# bool use_cone 0';
                        use_torus = '# bool use_torus 0';
                    case 3
                        use_plane = '# bool use_plane 0';
                        use_sphere = '# bool use_sphere 0';
                        use_cylinder = '# bool use_cylinder 0';
                        use_cone = '# bool use_cone 1';
                        use_torus = '# bool use_torus 0';
                    case 4
                        use_plane = '# bool use_plane 0';
                        use_sphere = '# bool use_sphere 0';
                        use_cylinder = '# bool use_cylinder 0';
                        use_cone = '# bool use_cone 0';
                        use_torus = '# bool use_torus 1';
                    otherwise
                        exit(1);
                end
                use_merge = '# bool use_merge 1';
                fprintf(fileID, '\n\n%s\n\n%s\n\n%s\n\n%s\n\n%s\n\n%s', use_plane, use_sphere, use_cylinder, use_cone, use_torus, use_merge);
                fclose(fileID);
            %end
        end
        
        
        % Run RANSAC on each cluster with a fixed primitive type
        outputSubDirectoryPath = append(outputDirectoryName, '/', inputDirectory(i).name);
        clusterDirectory = dir(outputSubDirectoryPath);
        num_cluster = numel(clusterDirectory);
        for j = 3 : num_cluster
            ransacInputDataPath = append(outputSubDirectoryPath, '/', clusterDirectory(j).name);
            outputResultPath = ransacInputDataPath;
            command = append('orig_ransac_command.exe ', ransacInputDataPath, '/', 'pc.xyzn ', outputResultPath, '/', 'pc.segps ', ransacInputDataPath, '/', 'parameters.conf');
            diary ransac_log.txt
            system(command);
            diary off
            movefile('ransac_log.txt',outputResultPath);
        end
        
        
        % Combine the results on each cluster into one .segps file
        final_pc = zeros(1,8); %initialization for concatenating matrices vertically
        for j = 3 : num_cluster
            % Load a point-cloud on each cluster
            currClusterPath = append(outputSubDirectoryPath, '/', clusterDirectory(j).name, '/pc.segps');
            %disp(currClusterPath);
            fileID = fopen(currClusterPath,'r');
            pc = fscanf(fileID, '%f', [8 Inf]);
            pc = pc';
            fclose(fileID);
            
            pc(:,8) = str2num(erase(clusterDirectory(j).name, 'cluster'));
            final_pc = [final_pc; pc];
        end
        final_pc = final_pc(2:end,:);  %Remove the extra rows
        %Write the combined point-cloud into the output file
        output_fileName = append(outputSubDirectoryPath, '/final_fitted_pc.segps');
        fileID = fopen(output_fileName,'w');
        point_num = size(final_pc, 1);
        for j = 1:point_num
            fprintf(fileID,'%f %f %f %f %f %f %d %d\n',final_pc(j,:));
        end
        fclose(fileID);
    end

end
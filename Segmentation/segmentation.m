function segmentation(inputDirectoryName, outputDirectoryName)
% This script automates the full pipeline of segmentation.
%
% This script and a "input" directory should be the same directory.
% A "input" directory has 1 sub-directory per input point-cloud. 
% Each sub-directory has the input point-cloud and a .conf file for RANSAC.
%
% A "output" directory has 1 sub-directory per point-cloud. 
% Each sub-directory should contain the final segmentation and primitive list, 
% as well as files for any intermediate step of the pipeline.

    inputDirectory = dir(inputDirectoryName);
    num_data = numel(inputDirectory);
    mkdir(outputDirectoryName);
    
    %Create the output directory
    for i = 3 : num_data % the idx of the 1st data starts from 3
        subDirectoryPath = append(outputDirectoryName, '/', inputDirectory(i).name);
        mkdir(subDirectoryPath);
    end
    
    %Clean extra data throught the pre-processing
    
    %Run the RANSAC program on each data
    for i = 3 : num_data
        inputDataPath = append(inputDirectoryName, '/', inputDirectory(i).name);
        outputResultPath = append(outputDirectoryName, '/', inputDirectory(i).name);
        command = append('orig_ransac_command.exe ', inputDataPath, '/', 'pc.xyzn ', outputResultPath, '/', 'pc.segps');
        %, inputDataPath, '/', 'parameters.conf');
        diary ransac_log.txt
        system(command);
        diary off
        movefile('ransac_log.txt',outputResultPath);
    end
    
    %Run the 2 varieties of clustering on each data obtained from RANSAC
    for i = 3 : num_data
        inputDataPath = append(outputDirectoryName, '/', inputDirectory(i).name, '/', 'pc.segps');
        outputResultPath1 = append(outputDirectoryName, '/', inputDirectory(i).name, '/', 'pc-clustered1.segps');
        outputResultPath2 = append(outputDirectoryName, '/', inputDirectory(i).name, '/', 'pc-clustered2.segps');
        clustering1(inputDataPath, outputResultPath1, 0.1, 50);
        clustering2(inputDataPath, outputResultPath2, 0.1, 50);
    end
end
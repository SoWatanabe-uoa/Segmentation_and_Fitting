function cleanData(input_fileName, output_fileName)
%input_fileName = 'cube_minus_cylinder.xyzn';
%output_fileName = 'cube_minus_cylinder-cleaned.xyzn';

    %Load a point-cloud with coordinates, normals
    fileID = fopen(input_fileName,'r');
    pc = fscanf(fileID, '%f', [6 Inf]);
    pc = pc';
    fclose(fileID);
    
    %Remove normal vector which is 0 (length is 0)
    normals = pc(:,4:6)';
    lengths = vecnorm(normals)';
    indices = abs(lengths) > eps;
    pc = pc(indices,:);
    
    %Normalize each vector
    normals = pc(:,4:6)';
    lengths = vecnorm(normals)';
    pc(:,4:6) = pc(:,4:6) ./ lengths;
    
    %Remove ourliers
    ptCloud = pointCloud([pc(:,1), pc(:,2), pc(:,3)]);
    [ptCloudOut,inlierIndices,outlierIndices_temp] = pcdenoise(ptCloud);
    pc = pc(inlierIndices',:);
    
    %Write the cleaned data into the output file
    fileID = fopen(output_fileName,'w');
    for i = 1:ptCloudOut.Count
        fprintf(fileID,'%f %f %f %f %f %f\n',pc(i,:));
    end
    fclose(fileID);
end
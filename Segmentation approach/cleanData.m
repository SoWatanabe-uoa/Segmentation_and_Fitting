function cleanData(input_fileName, output_fileName)
    %Load a point-cloud with coordinates, normals
    fileID = fopen(input_fileName,'r');
    pc = fscanf(fileID, '%f', [6 Inf]);
    pc = pc';
    fclose(fileID);
    
    %Remove normal vector which is 0 (length is 0)
    normals = pc(:,4:6)';
    lengths = vecnorm(normals)';
    indices = abs(lengths(:,1)) > eps;
    pc = pc(indices,:);
    
    %Normalize each vector
    normals = pc(:,4:6)';
    lengths = vecnorm(normals)';
    pc(:,4:6) = pc(:,4:6) ./ lengths;
    
    %Write the cleaned data into the output file
    fileID = fopen(output_fileName,'w');
    point_num = size(pc);  point_num = point_num(1,1);
    for i = 1:point_num
        fprintf(fileID,'%f %f %f %f %f %f\n',pc(i,:));
    end
    fclose(fileID);
end
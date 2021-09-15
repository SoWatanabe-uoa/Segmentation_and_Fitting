function clustering(input_fileName, output_fileName, epsilon, minpts)

%{
input_fileName = 'cube_m_cyl.segps';
output_fileName = 'cube_m_cyl-clustered.segps';
epsilon = 1.35;
minpts = 50;
%}
    %Load a point-cloud with coordinates, (normals), cluster ids and primitive ids
    fileID = fopen(input_fileName,'r');
    point_num = fscanf(fileID, '%d', [1 1]);
    
    pc = fscanf(fileID, '%f', [8 Inf]);
    pc = pc';
    fclose(fileID);
    
    %Cluster using dbscan and write (the lines whose cluster ID is except
    %for -1)
    labels = dbscan(pc(:,1:3), epsilon, minpts);
    pc(:,8) = labels;
    fileID = fopen(output_fileName,'w');
    fprintf(fileID,'%d\n', point_num);
    for i = 1:point_num
        fprintf(fileID,'%f %f %f %f %f %f %d %d\n',pc(i,:));
    end
    fclose(fileID);
end
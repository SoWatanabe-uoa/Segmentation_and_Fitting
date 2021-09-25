function clustering1(input_fileName, output_fileName, epsilon, minpts)
%{
input_fileName = 'cub_m_cyl.segps';
output_fileName = 'cub_m_cyl_clustered.segps';
epsilon = 0.1;
minpts = 50;
%}

    %Load a point-cloud with coordinates, normals, cluster ids and primitive ids
    fileID = fopen(input_fileName,'r');
    point_num = fscanf(fileID, '%d', [1 1]);
    pc = fscanf(fileID, '%f', [8 Inf]);
    pc = pc';
    fclose(fileID);
    
    %Normalize the spatial coordinates such that the objects fits inside the unit box centered at the origin
    pc = normalizeSpatialCoordinate(pc);
    
    %Convert the input primitive-type id by one-hot encoding
    pc = append_onehotencoded(pc);
    
    %Run dbscan on points in dimension 11
    cids = dbscan(pc(:,1:11), epsilon, minpts);
    pc = [pc, cids];
    
    %Remove points which doesn't belong to any clusters
    pc = pc(pc(:,12)~=-1,:);
    
    %Write the clustered point-cloud data into the output file
    fileID = fopen(output_fileName,'w');
    point_num = size(pc, 1);
    fprintf(fileID,'%d\n', point_num);
    for i = 1:point_num
        fprintf(fileID,'%f %f %f %f %f %f %d %d %d %d %d %d\n',pc(i,:));
    end
    fclose(fileID);
end
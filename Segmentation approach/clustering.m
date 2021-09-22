%function clustering(input_fileName, output_fileName, epsilon, minpts)

input_fileName = 'cub_m_cyl.segps';
output_fileName = 'cub_m_cyl-clustered.segps';
epsilon = 0.1;
minpts = 100;

    %Load a point-cloud with coordinates, normals, cluster ids and primitive ids
    fileID = fopen(input_fileName,'r');
    point_num = fscanf(fileID, '%d', [1 1]);
    pc = fscanf(fileID, '%f', [8 Inf]);
    pc = pc';
    fclose(fileID);
    
    %Normalize the spatial coordinates such that the objects fits inside the unit box centered at the origin
    %Calculate the center of mass
    center = [mean(pc(:,1)), mean(pc(:,2)), mean(pc(:,3))];
    %Translate all points such that the center of mass is at the origin
    pc(:,1:3) = [pc(:,1)-center(1,1), pc(:,2)-center(1,2), pc(:,3)-center(1,3)];
    %Divide each coordinate by the length of the maximum side length of the point-cloud bounding box
    ptCloud = pointCloud([pc(:,1), pc(:,2), pc(:,3)]);
    side_len_max = max([ptCloud.XLimits(1,2) - ptCloud.XLimits(1,1), ptCloud.YLimits(1,2) - ptCloud.YLimits(1,1), ptCloud.ZLimits(1,2) - ptCloud.ZLimits(1,1)]);
    pc(:,1:3) = pc(:,1:3) ./ side_len_max;
    
    %Convert the input primitive-type id by one-hot encoding
    pids = pc(:,7);
    pids = categorical(pids);
    pids = onehotencode(pids,2);
    p_type_num = length(pids(1,:));
    pc = [pc(:,1:6),pids,zeros(point_num, 5-p_type_num)];
    
    %Cluster using dbscan
    cids = dbscan(pc(:,1:3), epsilon, minpts);

    %Write the clustered point-cloud data into the output file
    %{
    fileID = fopen(output_fileName,'w');
    fprintf(fileID,'%d\n', point_num);
    for i = 1:point_num
        fprintf(fileID,'%f %f %f %f %f %f %d %d\n',pc(i,:));
    end
    fclose(fileID);
    %}
%end
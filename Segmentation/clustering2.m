function clustering2(input_fileName, output_fileName, epsilon, minpts)
%{
input_fileName = 'cub_m_cyl.segps';
output_fileName = 'cub_m_cyl-clustered.segps';
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
    
    % Run dbscan on points made of the points coordinates (x, y, z) and their normal coordinates (nx, ny, nz)
    cids = dbscan(pc(:,1:6), epsilon, minpts);
    pc(:,8) = cids;
    pc = pc(pc(:,8)~=-1,:); %Remove points which doesn't belong to any clusters
    cids = pc(:,8);
    
    %For each obtained cluster, if points in a given cluster have different primitive types, 
    %then run dbscan on that cluster on points made of the points coordinates (x, y, z) and the one-hot
    %encoded primitive types (t1, t2, t3, t4, t5)
    final_pc = zeros(1,12); %initialization for concatenating matrices vertically
    uniq_cids = unique(cids);
    num_cids = length(uniq_cids);
    for i = 1:num_cids
        curr_id = uniq_cids(i);
        curr_pc = pc(pc(:,8)==curr_id, :);
        uniq_pids = unique(curr_pc(:,7));
        if length(uniq_pids) > 1 %if points in a given cluster have different primitive types
            curr_pc = append_onehotencoded(curr_pc);
            curr_pc_cp = [curr_pc(:,1:3),curr_pc(:,7:11)]; %points coordinates (x, y, z) and the one-hot encoded primitive types (t1, t2, t3, t4, t5)
            final_cids = dbscan(curr_pc_cp, epsilon, minpts); %Assume this dbscan doesn't create more than 10 clusters
            curr_pc = [curr_pc, final_cids];
            curr_pc = curr_pc(curr_pc(:,12)~=-1,:); %Remove points which doesn't belong to any clusters
            final_pc = [final_pc; curr_pc(:,1:11), curr_pc(:,12) + i*10];
        else
            curr_pc = append_onehotencoded(curr_pc);
            curr_pc = [curr_pc, ones(size(curr_pc,1),1)*i*10];
            final_pc = [final_pc; curr_pc];
        end
    end
    
    %Remove the extra rows
    final_pc = final_pc(2:end,:);
    
    %Write the clustered point-cloud data into the output file
    fileID = fopen(output_fileName,'w');
    point_num = size(final_pc, 1);
    fprintf(fileID,'%d\n', point_num);
    for i = 1:point_num
        fprintf(fileID,'%f %f %f %f %f %f %d %d %d %d %d %d\n',final_pc(i,:));
    end
    fclose(fileID);
end
function visualizeClusteredPointCloud(filePath,visualize_id, titleName)
    fileID = fopen(filePath);
    num_point = fscanf(fileID, '%d', [1 1]);

    % Load a point-cloud with coordinates, normals, primitive ID, cluster ID
    pc = fscanf(fileID, '%f', [12 Inf]);
    pc = pc';
    fclose(fileID);

    %Plot each 3D point per cluster ID
    %When visualize_id = 'p', plot in terms of primitive ids
    %When visualize_id = 'c', plot in terms of cluster ids
    switch visualize_id
        case 'p'
            pc = append_onehotdecoded(pc);
            visualize_id = 7;
        case 'c'
            visualize_id = 12;
        otherwise
            disp('Invalid argument');
            return;
    end
    
    cids = pc(:,visualize_id);
    uniq_ids = unique(cids);
    num_ids = length(uniq_ids);
    for l = 1:num_ids
        curr_id = uniq_ids(l);
        curr_pc = pc(pc(:,visualize_id)==curr_id, :);
        plot3(curr_pc(:,1),curr_pc(:,2),curr_pc(:,3),'x');
        hold on
    end
    uniq_ids = string(uniq_ids);
    legend(uniq_ids);
    title(titleName);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
end
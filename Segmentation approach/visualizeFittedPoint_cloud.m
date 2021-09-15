function visualizeFittedPoint_cloud(fileName,visualize_id)
    fileID = fopen(fileName);
    num_point = fscanf(fileID, '%d', [1 1]);

    % Create matrices whose line contains a coodinate of a 3D point, a
    % primitive-type ID and a cluster ID

    pc = fscanf(fileID, '%f', [8 Inf]);
    pc = pc';
    fclose(fileID);

    %Plot each 3D point per cluster ID
    %When visualize_id = 7, plot in terms of primitive ids
    %When visualize_id = 8, plot in terms of cluster ids
    switch visualize_id
        case 'p'
            visualize_id = 7;
        case 'c'
            visualize_id = 8;
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
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
end
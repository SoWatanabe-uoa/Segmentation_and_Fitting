function kDistanceGraph(fileName, minpts)
    %Load a point-cloud with coordinates, (normals), cluster ids and primitive ids
    fileID = fopen(fileName);
    num_point = fscanf(fileID, '%d', [1 1]);
    
    pc = fscanf(fileID, '%f', [8 Inf]);
    pc = pc';
    fclose(fileID);

    %Plot the k-distance graph
    % The minpts-th smallest pairwise distances
    kD = pdist2(pc(:,1:3), pc(:,1:3),'euc','Smallest',minpts);
    
    plot(sort(kD(end,:)));
    title('k-distance graph')
    xlabel(['Points sorted with ', num2str(minpts), 'th nearest distances'])
    ylabel([num2str(minpts), 'th nearest distances'])
    grid
end
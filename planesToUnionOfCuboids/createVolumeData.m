function V = createVolumeData(X,Y,Z,unionOfCuboids,setOfPlanes)
    % Inputs are 
    %unionOfCuboid : x : best creature
    %  
    % Output are
    nx = size(X, 1);
    ny = size(X, 2);
    nz = size(X, 3);
    V = ones(nx, ny, nz); %Initialize V
    
    %Calculate signed distances between nodes of the regular grid and planes
    distances = zeros(nx*ny*nz,size(setOfPlanes,1));
    pointIndex = 1;
    for i = 1:nx
        for j = 1:ny
            for k = 1:nz           
                P = [X(i,j,k), Y(i,j,k), Z(i,j,k)];
                for l = 1:size(setOfPlanes,1)
                    A = setOfPlanes(l,1);
                    B = setOfPlanes(l,2);
                    C = setOfPlanes(l,3);
                    D = setOfPlanes(l,4);
                    distances(pointIndex,l) = (A*P(1)+B*P(2)+C*P(3)-D)/norm([A,B,C]);
                end
                pointIndex = pointIndex + 1;
            end
        end
    end
    
    % Calculate signed distances between nodes of the regular grid and
    % union of cuboids
    pointIndex = 1;
    for i = 1:nx
        for j = 1:ny
            for k = 1:nz
                d_Cs = zeros(size(unionOfCuboids,1),1);
                for l = 1:numel(d_Cs)
                    %{
                    dis_min = Inf;
                    index_min = 0;
                    for m = 1:6
                        if dis_min > abs( distances(pointIndex,unionOfCuboids(l,m)) )
                            dis_min = abs( distances(pointIndex,unionOfCuboids(l,m)) );
                            index_min = m;
                        end
                    end
                    d_Cs(l) = distances(pointIndex,unionOfCuboids(l,index_min));
                    %}
                    
                    d_Cs(l) = min([
                        distances(pointIndex,unionOfCuboids(l,1)), ...
                        distances(pointIndex,unionOfCuboids(l,2)), ...
                        distances(pointIndex,unionOfCuboids(l,3)), ...
                        distances(pointIndex,unionOfCuboids(l,4)), ...
                        distances(pointIndex,unionOfCuboids(l,5)), ...
                        distances(pointIndex,unionOfCuboids(l,6))
                    ]);
                    
                end
                V(i,j,k) = max(d_Cs);
                pointIndex = pointIndex + 1;
            end
        end
    end
    
end
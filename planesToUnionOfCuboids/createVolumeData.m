function V = createVolumeData(x,y,z,unionOfCuboids,setOfPlanes)
    % Inputs are 
    %  
    % Output are
    
    V = ones(numel(x), numel(y), numel(z) ); %Initialize V
    
    %Calculate signed distances between nodes of the regular grid and planes
    distances = zeros(numel(x)*numel(y)*numel(z),size(setOfPlanes,1));
    pointIndex = 1;
    for i = 1:numel(x)
        for j = 1:numel(y)
            for k = 1:numel(z)           
                P = [x(i), y(j), z(k)];
                for l = 1:size(setOfPlanes,1)
                    A = setOfPlanes(l,1);
                    B = setOfPlanes(l,2);
                    C = setOfPlanes(l,3);
                    D = setOfPlanes(l,4);
                    distances(pointIndex,l) = (A*P(1)+B*P(2)+C*P(3)+D)/norm([A,B,C]);
                end
                pointIndex = pointIndex + 1;
            end
        end
    end
    
    % Calculate signed distances between nodes of the regular grid and
    % union of cuboids
    pointIndex = 1;
    for i = 1:numel(x)
        for j = 1:numel(y)
            for k = 1:numel(z)
                d_Cs = zeros(size(unionOfCuboids,1),1);
                for l = 1:numel(d_Cs)
                    %disp(min(unionOfCuboids(i, :)));
                    %disp(max(unionOfCuboids(i, :)));
                    % Consider the signed distance when the normal direction
                    % become oppesite.
                    d_Cs(l) = min([
                            distances(pointIndex,unionOfCuboids(l,1)), ...
                            (-1)*distances(pointIndex,unionOfCuboids(l,1)), ...
                            distances(pointIndex,unionOfCuboids(l,2)), ...
                            (-1)*distances(pointIndex,unionOfCuboids(l,2)), ...
                            distances(pointIndex,unionOfCuboids(l,3)), ...
                            (-1)*distances(pointIndex,unionOfCuboids(l,3)), ...
                            distances(pointIndex,unionOfCuboids(l,4)), ...
                            (-1)*distances(pointIndex,unionOfCuboids(l,4)), ...
                            distances(pointIndex,unionOfCuboids(l,5)), ...
                            (-1)*distances(pointIndex,unionOfCuboids(l,5)), ...
                            distances(pointIndex,unionOfCuboids(l,6)), ...
                            (-1)*distances(pointIndex,unionOfCuboids(l,6))
                        ]);
                end
                V(i,j,k) = max(d_Cs);
                pointIndex = pointIndex + 1;
            end
        end
    end
    
end
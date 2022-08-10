function d_U = signedDistanceFunc(pointIndex,unionOfCuboids,distances)
    % Inputs are 
    %   pointIndex: Index of a point
    %   unionOfCuboids: Matrix of indice of planes
    % Output are
    %   d_U: distance between the point and the union of cuboids
    
    d_Cs = zeros(size(unionOfCuboids,1),1);
    for i = 1:numel(d_Cs)
        %disp(min(unionOfCuboids(i, :)));
        %disp(max(unionOfCuboids(i, :)));
        % Consider the signed distance when the normal direction
        % become oppesite.
        d_Cs(i) = min([
                distances(pointIndex,unionOfCuboids(i,1)), ...
                distances(pointIndex,unionOfCuboids(i,2)), ...
                distances(pointIndex,unionOfCuboids(i,3)), ...
                distances(pointIndex,unionOfCuboids(i,4)), ...
                distances(pointIndex,unionOfCuboids(i,5)), ...
                distances(pointIndex,unionOfCuboids(i,6)), ...
            ]);
    end
    
    d_U = max(d_Cs);
end
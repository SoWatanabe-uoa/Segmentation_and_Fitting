function state = unionOfCuboids_plot(unionOfCuboids,setOfPlanes)
%   TRAVELING_SALESMAN_PLOT Custom plot function for traveling salesman.
%   STATE = TRAVELING_SALESMAN_PLOT(OPTIONS,STATE,FLAG,LOCATIONS) Plot city
%   LOCATIONS and connecting route between them. This function is specific
%   to the traveling salesman problem.
%
%   The inputs are
%       setOfPlanes: (Number of planes)x10 Matrix. The 1st to 4th column
%       values are the cofficients of the plane equation ax + by + cz + d =
%       0. The 5th and 6th are the min and max of x coordinate in
%       the point-cloud labeled into the plane. The 7th and 8th are the min
%       and max of y coordinate in the point-cloud labeled into the plane.
%       The 9th and 10th are the min and max of z coordinate 
%       in the point-cloud labeled into the plane.

    %{
    [unused,idx] = min(state.Score);
    unionOfCuboids = state.Population{idx};
    disp('Result')
    disp(unionOfCuboids)
%}
    
    % Determine the bounding box surrounding the obtained union of cuboids 
    xLim = [Inf,-Inf];
    yLim = [Inf,-Inf];
    zLim = [Inf,-Inf];
    for i = 1:size(unionOfCuboids,1)
        cuboid = unionOfCuboids(i,:);
        for j = 1:6
            if xLim(1) > setOfPlanes(cuboid(j),5)
                xLim(1) = setOfPlanes(cuboid(j),5); %xmin
            end
            if xLim(2) < setOfPlanes(cuboid(j),6)
                xLim(2) = setOfPlanes(cuboid(j),6); %xmax
            end
            if yLim(1) > setOfPlanes(cuboid(j),7)
                yLim(1) = setOfPlanes(cuboid(j),7); %ymin
            end
            if yLim(2) < setOfPlanes(cuboid(j),8)
                yLim(2) = setOfPlanes(cuboid(j),8); %ymax
            end
            if zLim(1) > setOfPlanes(cuboid(j),9)
                zLim(1) = setOfPlanes(cuboid(j),9); %zmin
            end
            if zLim(2) < setOfPlanes(cuboid(j),10)
                zLim(2) = setOfPlanes(cuboid(j),10); %zmax
            end
        end
    end
    %}
    
    %Create the regular 3D grid
    interval = 100;
    % Extend the bounding box larger than the model
    x = xLim(1): (xLim(2)-xLim(1))/interval: xLim(2);
    y = yLim(1): (yLim(2)-yLim(1))/interval: yLim(2);
    z = zLim(1): (zLim(2)-zLim(1))/interval: zLim(2);
    [X,Y,Z] = meshgrid(x,y,z);
    
    
    % Calculate signed distances between nodes of the regular grid and
    % union of cuboids
    V = createVolumeData(x,y,z,unionOfCuboids,setOfPlanes);
    
    %disp(V(1:101,1:101,1:3))
    figure
    %isosurface(X,Y,Z,min(Z,V),0.0);
    isosurface(X,Y,Z,V,0.0);
    grid on
end
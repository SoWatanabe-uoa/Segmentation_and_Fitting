function state = unionOfCuboids_plot(options,state,flag,setOfPlanes)
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

    [unused,idx] = min(state.Score);
    unionOfCuboids = state.Population{idx};
    %disp('Result')
    %disp(unionOfCuboids)
    
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
    interval = 20;
    x = xLim(1):(xLim(2)-xLim(1))/interval:xLim(2);
    y = yLim(1):(yLim(2)-yLim(1))/interval:yLim(2);
    z = zLim(1):(zLim(2)-zLim(1))/interval:zLim(2);
    [X,Y,Z] = meshgrid(x,y,z);
    
    % Calculate signed distances between nodes of the regular grid and
    % union of cuboids
    V = createVolumeData(x,y,z,unionOfCuboids,setOfPlanes);
    
    isosurface(X,Y,Z,V,0.0);
    grid on
    %{
    for i = 1:size(unionOfCuboids,1)
        cuboid = unionOfCuboids(i,:);
        for j = 1:6
            %Find all coefficients of plane equation    
            A = setOfPlanes(cuboid(j),1);
            B = setOfPlanes(cuboid(j),2);
            C = setOfPlanes(cuboid(j),3);
            D = setOfPlanes(cuboid(j),4);
            %Decide on a suitable showing range
            xLim = setOfPlanes(cuboid(j),5:6);
            yLim = setOfPlanes(cuboid(j),7:8);
            zLim = setOfPlanes(cuboid(j),9:10);
            % Create the bounding box from max & min value of xyz coordinates of the
            % point in a given input PC
            interval = 20;
            x = xLim(1):(xLim(2)-xLim(1))/interval:xLim(2);
            y = yLim(1):(yLim(2)-yLim(1))/interval:yLim(2);
            z = zLim(1):(zLim(2)-zLim(1))/interval:zLim(2);
            [X,Y,Z] = meshgrid(x,y,z);
            % When AX+BY+CZ+D = 0, return 1(true) at the 3D coodinate in
            % the bounding box.
            V = zeros(numel(x),numel(y),numel(z));
            for k = 1:numel(x)
                for l = 1:numel(y)
                    for m = 1:numel(z)
                        if (-1e-3 < (A*X+B*Y+C*Z+D)) && ((A*X+B*Y+C*Z+D) < 1e-3)
                            V(k,l,m) = 1;
                        end
                    end
                end
            end
            isosurface(x,y,z,V,1);
            hold on
        end
    end
    hold off
    grid on
    
    for i = 1:size(unionOfCuboids,1)
        cuboid = unionOfCuboids(i,:);

        for j = 1:6
            %Find all coefficients of plane equation    
            A = setOfPlanes(cuboid(j),1);
            B = setOfPlanes(cuboid(j),2);
            C = setOfPlanes(cuboid(j),3);
            D = setOfPlanes(cuboid(j),4);
            %Decide on a suitable showing range
            xLim = [setOfPlanes(cuboid(j),5:6)];
            yLim = [setOfPlanes(cuboid(j),7:8)];
            zLim = [setOfPlanes(cuboid(j),9:10)];
            %[X,Y,Z] = meshgrid(xLim,yLim,zLim);

            [X,Y] = meshgrid(xLim,yLim);
            Z = (A * X + B * Y + D)/ (-C);
            
            if(Z < zLim(1))
                Z = zLim(1) * ones(2);
            elseif(Z > zLim(2))
                Z = zLim(2) * ones(2);
            end
            reOrder = [1 2 4 3 1];
            %check = [X(reOrder),Y(reOrder),Z(reOrder)];
            %disp(check)
            plot3(X(reOrder),Y(reOrder),Z(reOrder));
            hold on
        end
        end
    %}

end
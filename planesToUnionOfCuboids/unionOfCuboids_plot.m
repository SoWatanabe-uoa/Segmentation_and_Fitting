function state = unionOfCuboids_plot(options,state,flag,setOfPlanes)
%   TRAVELING_SALESMAN_PLOT Custom plot function for traveling salesman.
%   STATE = TRAVELING_SALESMAN_PLOT(OPTIONS,STATE,FLAG,LOCATIONS) Plot city
%   LOCATIONS and connecting route between them. This function is specific
%   to the traveling salesman problem.
%
%   The inputs are
%       setOfPlanes: (Number of planes)x8 Matrix. The 1st to 4th column
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
    
    % Calculate the bounding box from max & min value of xyz coordinates of the
    % point in a given input PC
    
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
            V = (-1e-3 < (A*X+B*Y+C*Z+D) && (A*X+B*Y+C*Z+D) < 1e-3);
            isosurface(x,y,z,V,1);
            hold on
        end
    end
    hold off
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
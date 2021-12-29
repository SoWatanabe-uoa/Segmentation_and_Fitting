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

[unused,idx] = min(state.Score);
unionOfCuboids = state.Population{idx};
disp(unionOfCuboids)

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
        
        %{
        check = ['A=',num2str(A),' B=',num2str(B),' C=',num2str(C), ' D=',num2str(D), ...
            ' Xlim=',num2str(xLim), ' Ylim=',num2str(yLim),];
        disp(check)
        %}
        
        [X,Y] = meshgrid(xLim,yLim);
        Z = (A * X + B * Y + D)/ (-C);
        reOrder = [1 2 4 3 1];
        %check = [X(reOrder),Y(reOrder),Z(reOrder)];
        %disp(check)
        plot3(X(reOrder),Y(reOrder),Z(reOrder));
        hold on
    end
end
hold off
grid on


end
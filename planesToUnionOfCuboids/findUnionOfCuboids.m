function findUnionOfCuboids(inputPC, setOfPlanes)
    % The arguments are
    % inputPC: PointCloud object with normals
    %
    % setOfPlanes: setOfPlanes: (Number of planes)x8 Matrix. The 1st to 4th column
    %       values are the cofficients of the plane equation ax + by + cz + d =
    %       0. The 5th and 6th are the min and max of x coordinate in
    %       the point-cloud labeled into the plane. The 7th and 8th are the min
    %       and max of y coordinate in the point-cloud labeled into the plane.
    %       The 9th and 10th are the min and max of z coordinate 
    %       in the point-cloud labeled into the plane.
    
    % Calculate signed distances between points and planes
    distances = zeros(inputPC.Count,size(setOfPlanes,1));
    for i = 1:inputPC.Count
        P = [inputPC.Location(i,1), inputPC.Location(i,2), inputPC.Location(i,3)];
        %N = [inputPC.Normal(i,1), inputPC.Normal(i,2), inputPC.Normal(i,3)];
        for j = 1:size(setOfPlanes,1)
            A = setOfPlanes(j,1);
            B = setOfPlanes(j,2);
            C = setOfPlanes(j,3);
            D = setOfPlanes(j,4);
            distances(i,j) = (A*P(1)+B*P(2)+C*P(3)+D)/norm([A,B,C]);
            
            
            %{
            bbox_len = sqrt( ...
            (inputPC.XLimits(2)-inputPC.XLimits(1))^2 + ...
            (inputPC.YLimits(2)-inputPC.XLimits(1))^2 + ...
            (inputPC.ZLimits(2)-inputPC.ZLimits(1))^2 );
            % Check if the segment PR parallel to the line (x,y,z) = p + tn(t>0) intersects the plane
            % Point Q on the plane and R on the line (x,y,z) = p + tn(t>0)
            Q = [-A*D, -B*D, -C*D];
            R = [P(1)+bbox_len*N(1), P(2)+bbox_len*N(2), P(3)+bbox_len*N(3)];

            % QP QR vector
            QP = [P(1)-Q(1),P(2)-Q(2),P(3)-Q(3)];
            QR = [R(1)-Q(1),R(2)-Q(2),R(3)-Q(3)];

            dot_QP_planeNormal = dot(QP,[A,B,C]);
            dot_QR_planeNormal = dot(QR,[A,B,C]);
            
            if (dot_QP_planeNormal >= 0.0 && dot_QR_planeNormal <= 0.0) || ...
                (dot_QP_planeNormal <= 0.0 && dot_QR_planeNormal >= 0.0)
                 % signed distance > 0 if inside
            else
                % signed distance < 0 if outside
                distances(i,j) = -distances(i,j);
            end
            %}
        end
    end
    
    SDF = @(pointIndex,unionOfCuboids) signedDistanceFunc(pointIndex,unionOfCuboids,distances);
    FitnessFcn = @(x) unionOfCuboids_fitness(x,inputPC.Count,SDF);
    my_plot = @(options,state,flag) unionOfCuboids_plot(options,state,flag,setOfPlanes);
    
    options = optimoptions(@ga, 'PopulationType', 'custom'); %, ...
                        %'InitialPopulationRange', [1:(np-rem(np,6))/6, 1:6]);
    options = optimoptions(options,'CreationFcn',@create_unionOfCuboids, ...
                        'CrossoverFcn',@crossover_unionOfCuboids, ...
                        'MutationFcn',@mutate_unionOfCuboids, ...
                        'PlotFcn', my_plot, ...
                        'MaxGenerations',100,'PopulationSize',60, ...
                        'MaxStallGenerations',40,'UseVectorized',true); %set Tolerance
                    
    np = size(setOfPlanes,1);    
    numberOfVariables = np/6; % Number of cuboids
    [x,fval,reason,output] = ga(FitnessFcn,numberOfVariables,[],[],[],[],[],[],[],options);
end
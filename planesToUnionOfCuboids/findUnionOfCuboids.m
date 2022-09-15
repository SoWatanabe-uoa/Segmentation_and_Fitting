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
            distances(i,j) = (A*P(1)+B*P(2)+C*P(3)-D)/norm([A,B,C]);
        end
    end
    
    SDF = @(pointIndex,unionOfCuboids) signedDistanceFunc(pointIndex,unionOfCuboids,distances);
    FitnessFcn = @(x) unionOfCuboids_fitness(x,inputPC.Count,SDF);
    %my_plot = @(options,state,flag) unionOfCuboids_plot(options,state,flag,setOfPlanes);
    
    options = optimoptions(@ga, 'PopulationType', 'custom'); %, ...
                        %'InitialPopulationRange', [1:(np-rem(np,6))/6, 1:6]);
    options = optimoptions(options,'CreationFcn',@create_unionOfCuboids, ...
                        'CrossoverFcn',@crossover_unionOfCuboids, ...
                        'MutationFcn',@mutate_unionOfCuboids, ...
                        'MaxGenerations',50,'PopulationSize',120, ...  % MaxGenerations:MaxStallGenerations = 5:2 PopulationSize:60
                        'MaxStallGenerations', 20,'UseVectorized',true); %set Tolerance
                    
    np = size(setOfPlanes,1);   
    numberOfVariables = floor((np/6)/2); % Number of cuboids. We divide by 2 since we consider both of the given normal direction and the oposite direction.
    diary ga_log.txt
    [x,fval,reason,output] = ga(FitnessFcn,numberOfVariables,[],[],[],[],[],[],[],options)
    unionOfCuboids = x{1};
    disp('Result');
    disp(unionOfCuboids);
    diary off
    
    %Save the result of ga
    fileID = fopen('unionOfCuboids.txt','w');
    for i = 1:size(unionOfCuboids,1)
        fprintf(fileID,'%d %d %d %d %d %d\n', unionOfCuboids(i,:));
    end
    fclose(fileID);
    fileID = fopen('setOfPlanes.txt','w');
    for i = 1:size(setOfPlanes,1)
        fprintf(fileID,'%d %f %f %f %f %f %f %f %f %f %f \n', i, setOfPlanes(i,:));
    end
    fclose(fileID);
    
    unionOfCuboids_plot(unionOfCuboids,setOfPlanes);
end
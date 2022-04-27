function pop = create_unionOfCuboids(NVARS,FitnessFcn,options)
    %   This function creates a population
    %  of a set of cuboids POP with the NVARS cuboids. 
    %
    %   The arguments to the function are 
    %     NVARS: Number of variables
    %     FITNESSFCN: Fitness function 
    %     OPTIONS: Options structure used by the GA

    totalPopulationSize = sum(options.PopulationSize);
    pop = cell(totalPopulationSize,1);
    numOfCuboids = NVARS;
    
    for i = 1:totalPopulationSize
        %{
        % Constructive approach
        remainingPlanes = 1:size(setOfPlanes,1);
        cuboid = randsample(remainingPlanes,6);
        remainingPlanes = remainingPlanes(~ismember(remainingPlane,cuboid));
        %}
        unionOfCuboids = zeros(numOfCuboids,6);
        for j = 1:numOfCuboids
            unionOfCuboids(j,:) = randsample(numOfCuboids*6,6); 
        end
        
        pop{i} = unionOfCuboids;
    end
end
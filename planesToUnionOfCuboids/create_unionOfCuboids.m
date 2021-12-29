function pop = create_unionOfCuboids(NVARS,FitnessFcn,options)
    %CREATE_PERMUTATIONS Creates a population of permutations.
    %   POP = CREATE_PERMUTATION(NVARS,FITNESSFCN,OPTIONS) creates a population
    %  of permutations POP each with a length of NVARS. 
    %
    %   The arguments to the function are 
    %     NVARS: Number of planes
    %     FITNESSFCN: Fitness function 
    %     OPTIONS: Options structure used by the GA

    %   Copyright 2004-2007 The MathWorks, Inc.

    totalPopulationSize = sum(options.PopulationSize);
    pop = cell(totalPopulationSize,1);
    
    for i = 1:totalPopulationSize
        %{
        % Constructive approach
        remainingPlanes = 1:size(setOfPlanes,1);
        cuboid = randsample(remainingPlanes,6);
        remainingPlanes = remainingPlanes(~ismember(remainingPlane,cuboid));
        %}
        planes = 1:NVARS;
        num_planes = numel(planes);
        unionOfCuboids = randsample(planes, num_planes - rem(num_planes,6));
        pop{i} = reshape(unionOfCuboids,[numel(unionOfCuboids)/6,6]);
    end
end
function xoverKids  = crossover_unionOfCuboids(parents,options,NVARS, ...
    FitnessFcn,thisScore,thisPopulation)
%   This function crossovers PARENTS to produce
%   the children XOVERKIDS.
%
%   The arguments to the function are 
%     PARENTS: Parents chosen by the selection function
%     OPTIONS: Options created from OPTIMOPTIONS
%     NVARS: Number of variables (number of cuboids)
%     FITNESSFCN: Fitness function 
%     STATE: State structure used by the GA solver 
%     THISSCORE: Vector of scores of the current population 
%     THISPOPULATION: Matrix of individuals in the current population
 

    nKids = length(parents)/2;
    xoverKids = cell(nKids,1); % Normally zeros(nKids,NVARS);
    index = 1;
    numOfCuboids = NVARS;
    
    % If the number of cuboids is less than 2, not create children.
    if numOfCuboids < 2
        for i=1:nKids
            parent = thisPopulation{parents(index)};
            index = index + 2;
            xoverKids{i} = parent;
        end
    else
        for i=1:nKids
            % here is where the special knowledge that the population is a cell
            % array is used. Normally, this would be thisPopulation(parents(index),:);
            parent1 = thisPopulation{parents(index)};
            parent2 = thisPopulation{parents(index+1)};
            index = index + 2;

            %Picking one cuboid in one creature, another cuboid in the other creature, and exchanging the planes.
            indicesOfCrossoveredCuboids = randsample(numOfCuboids,2);
            % Two-point crossover
            p1 = randi(5);
            p2 = randi([(p1+1) 6]);
            child = parent1;
            child(indicesOfCrossoveredCuboids(1),p1:p2) = parent2(indicesOfCrossoveredCuboids(2),p1:p2);
            xoverKids{i} = child; % Normally, xoverKids(i,:);
        end
    end
end
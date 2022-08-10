function mutationChildren = mutate_unionOfCuboids(parents ,options,NVARS, ...
    FitnessFcn, state, thisScore,thisPopulation,mutationRate)
%   This function mutates the
%   PARENTS to produce mutated children MUTATIONCHILDREN.
%
%   The arguments to the function are 
%     PARENTS: Parents chosen by the selection function
%     OPTIONS: Options created from OPTIMOPTIONS
%     NVARS: Number of variables 
%     FITNESSFCN: Fitness function 
%     STATE: State structure used by the GA solver 
%     THISSCORE: Vector of scores of the current population 
%     THISPOPULATION: Matrix of individuals in the current population
%     MUTATIONRATE: Rate of mutation

    alpha = 0.4; % Probability that the 1st process is done
    beta = 0.3; % Probability that the 2nd process is done
    % gumma = 1-alpha-beta : Probability that the 3rd process is done

    mutationChildren = cell(length(parents),1);% Normally zeros(length(parents),NVARS);
    numOfCuboids = NVARS;

    for i=1:length(parents)
        parent = thisPopulation{parents(i)}; % Normally thisPopulation(parents(i),:)
        probability = rand; % Probability that one out of the following 3 processes is done
        
        % Randomly select a plane in a cuboid and replace it by another plane (picked at random)
        if(0 < probability && probability < alpha)
            indexOfMutatedCuboid = randi(numOfCuboids);
            indexOMutatedPlane = randi(6);
            child = parent;
            % We multiple by 2 since we consider both of the given normal direction and the oposite direction.
            child(indexOfMutatedCuboid,indexOMutatedPlane) = randsample(numOfCuboids*6*2,1);
            mutationChildren{i} = child; % Normally mutationChildren(i,:)
        
        % Randomly select a cuboid in a creature, and replace it by a new randomly formed cuboid
        elseif(alpha < probability && probability < (alpha+beta))
            indexOfMutatedCuboid = randi(numOfCuboids);
            child = parent;
            % We multiple by 2 since we consider both of the given normal direction and the oposite direction.
            child(indexOfMutatedCuboid,:) = randsample(numOfCuboids*6*2,6);
            mutationChildren{i} = child; % Normally mutationChildren(i,:)
        
        % Randomly create a new creature (set of cuboids)
        elseif((alpha+beta) < probability && probability < 1)
            newUnionOfCuboids = zeros(numOfCuboids,6);  
            for j = 1:numOfCuboids
                % We multiple by 2 since we consider both of the given normal direction and the oposite direction.
                newUnionOfCuboids(j,:) = randsample(numOfCuboids*6*2,6); 
            end
            mutationChildren{i} = newUnionOfCuboids; % Normally mutationChildren(i,:)
        end
    end
end
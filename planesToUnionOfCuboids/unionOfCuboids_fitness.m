function scores = unionOfCuboids_fitness(x,num_point,SDF)
%TRAVELING_SALESMAN_FITNESS  Custom fitness function for TSP. 
%   SCORES = TRAVELING_SALESMAN_FITNESS(X,DISTANCES) Calculate the fitness 
%   of an individual. The fitness is the total distance traveled for an
%   ordered set of cities in X. DISTANCE(A,B) is the distance from the city
%   A to the city B.

    scores = zeros(size(x,1),1);
    for j = 1:size(x,1)
        % here is where the special knowledge that the population is a cell
        % array is used. Normally, this would be pop(j,:);
        unionOfCuboids = x{j};
        disp(unionOfCuboids)
        f = 0.0;
        for i = 1:num_point
            f = f + exp(-1*SDF(i,unionOfCuboids));
        end
        %disp(f)
        scores(j) = -f;
    end
end
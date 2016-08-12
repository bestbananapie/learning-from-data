function hybrid_model(num_points = 10, num_iterations = 1000);

    for i = 1:num_iterations
        % Create pseudo learning data
        [X,Y] = create_learning_data(num_points);

        % Calculate initial weights for pla algorithm
        w = pinv(X) * Y;
        
        % Run pla algorithm and save number of iterations
        iterations(i) = pla(X,Y,w);
    endfor

    iterations = mean(iterations)

endfunction 

function i = pla(X, target_Y,w)
    max_iter = 2000;
    i = 0; 
    do 
    %Check if there are still misclassified points

        % Find learned categorisation
        learnt_Y = sign(X * w);

        % Identify incorrect assignment
        incorrect_assignment = (learnt_Y != target_Y)';

    % If there are still incorrect assignments, do further learning
        if ( sum(incorrect_assignment) != 0 )
            % Increase Iteration count
            i = i + 1;

            % Create index of incorrect points
            incorrect_points = find(incorrect_assignment);

            % Randomly select a wrong point
            wrongx = incorrect_points(randi(length(incorrect_points)));

            % Update weights
            w(1) = w(1) + target_Y(wrongx);
            w(2) = w(2) + target_Y(wrongx) * X(wrongx,2);
            w(3) = w(3) + target_Y(wrongx) * X(wrongx,3);
            
        endif

    % Repeat until all points or correctly assigned or max iter reach
    until ( sum(incorrect_assignment) == 0 | i > max_iter ) 

endfunction

%This is a pesudo function, actually generates random learning data
function [X,Y] = create_learning_data(num_points,p);
    %Generate decision boundary
    p = domain_transfer(rand(2, 2));

    %Generate random input space
    X = domain_transfer(rand(num_points, 2));

    %Add bais input
    X = [ones(length(X),1) X];

    %decision boundary function
    f = zeros(1,2); 

    % Find decision bounday in form y = f(2) * x + f(1)
    f(2) = ( p(2,2) - p(1,2) ) / ( p(2,1) - p(1,1) );
    f(1) = p(1,2) - f(2) * p(1,1);

    Y = zeros(length(X), 1);
    % Compute 'distance' to decision boundary
    Y = f(2) .* X(:,1) .+ f(1) - X(:,2);

    % Assign accordingly
    Y = sign(Y);
endfunction

%Remap [0,0] x [1,1] domain space to desired domain space
function P = domain_transfer(P)
    P = P * 2 - 1;
endfunction

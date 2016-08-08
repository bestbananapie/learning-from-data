function [iterations, probability] = pla(num_points = 10)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate target function

    % Generate Random points for target function
    target_func_points = rand(2,2) .* 2 - 1;

    % Find Target Function
    target_func = find_target_func( target_func_points );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create Training Data

    % Generate random input points (x,y) coordinates and remap to domain
    X = rand(num_points,2) .* 2 .- 1;

    % Find input points category/assignment
    target_Y = find_assignment(X, target_func);

    % Plot Training Data for reference
    %figure;
    %pla_plot(X, zeros(num_points,1), target_Y, target_func, 'Training Data')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do training

    [learnt_f, iterations] = learn_function(X, target_Y);
        
    [target_func ; learnt_f];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimate Probability

    probability = calc_prob(target_func, learnt_f);


endfunction

function prob = calc_prob(f, g);
    num_points = 1000;
    
    X = rand(num_points,2) .* 2 .- 1;

    incorrect_assignment = [find_assignment(X, f) ~= find_assignment(X, g)];

    prob = sum(incorrect_assignment) / num_points;


endfunction

function [learnt_f, i] = learn_function(X, target_Y)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 

    % Initialise learnt_func
    learnt_f = zeros(1,2);

    incorrect_assignment = zeros(length(X),1);

    i = 0; 
    do 
    %%%%%%%%%%%%%%%%%%%
    % Check if learning is complete

        % Find learned categorisation
        learnt_Y = find_assignment(X,learnt_f);

        % Identify incorrect assignment
        incorrect_assignment = (learnt_Y ~= target_Y);


        % Update plot
        %figure
        %pla_plot(X, incorrect_assignment, target_Y, learnt_f,i)

    %%%%%%%%%%%%%%%%%%%
    % Learn if needed
        if ( sum(incorrect_assignment) ~= 0 )
            % Increase Iteration count
            i = i + 1;

            % Find index of incorrect points
            incorrect_points = find(incorrect_assignment);

            % Randomly select a wrong point
            wrongx = incorrect_points(randi(length(incorrect_points)));

            %update learnt function
            w = zeros(3,1);
            w(1) = -learnt_f(1);
            w(2) = -learnt_f(2);
            w(3) = 1;

            w(1) = w(1) - target_Y(wrongx);
            w(2) = w(2) - target_Y(wrongx) * X(wrongx,1);
            w(3) = w(3) - target_Y(wrongx) * X(wrongx,2);

            learnt_f(1) = - w(1) / w(3);
            learnt_f(2) = - w(2) / w(3);

        endif

    until ( sum(incorrect_assignment) == 0 | i > 2000 ) 
    %figure;
    %pla_plot(X, incorrect_assignment, target_Y, learnt_f,"final")

endfunction

function pla_plot(X, incorrect_assignment, target_Y, target_func, plot_title)
    hold on
    fplot(@(x) target_func(1) + target_func(2) .* x, [-1,1])
    legend("hide")
    %Plot all targety -1 as red and others blue
    %plot incorrect assignment as filled
    red_filled    = [ target_Y == -1 & incorrect_assignment == 0 ];
    blue_filled   = [ target_Y == +1 & incorrect_assignment == 0 ];
    red_unfilled  = [ target_Y == -1 & incorrect_assignment == 1  ];
    blue_unfilled = [ target_Y == +1 & incorrect_assignment == 1  ];

    scatter( X([red_filled],1) , X([red_filled],2),'r', 'filled' )
    scatter( X([blue_filled],1) , X([blue_filled],2), 'filled' )
    scatter( X([red_unfilled],1) , X([red_unfilled],2), 'r' )
    scatter( X([blue_unfilled],1) , X([blue_unfilled],2) )
    axis([-1,1,-1,1])
    title(plot_title)

endfunction

function Y = find_assignment(X,f);
    Y = zeros(length(X), 1);
    Y = f(2) .* X(:,1) .+ f(1) - X(:,2);

    Y( [Y > 0] ) = 1;
    Y( [Y <= 0] ) = -1;

endfunction


function f = find_target_func(X)
    f(2) = ( X(2,2) - X(1,2) ) / ( X(2,1) - X(1,1) );
    f(1) = X(1,2) - f(2) * X(1,1);
endfunction

function [] = pla()

    clc; close all
    input_points = 10;

    % Generate Random points for target function
    target_func_points = rand(2,2);

    % Remap to target domain
    target_func_points = target_func_points .* 2 - 1;

    % Find Target Function
    target_func = find_target_func( target_func_points )


    % Generate random input points and remap to domain
    X = rand(input_points,2);
    X = X .* 2 .- 1

    % Find input points category/assignment
    target_Y = find_assignment(X,target_func);

    % Initialise learnt_func
    learnt_f = zeros(1,2);

    incorrect_assignment = zeros(length(X),1)

    figure;
    pla_plot(X, incorrect_assignment, target_Y, target_func)
    % Plot Desired Outcome
    %pla_plot(X, target_Y, target_func)
    %figure;

    i = -1; 
    do 
        % Increase Iteration count
        i = i + 1
        % Find learned categorisation
        learnt_Y = find_assignment(X,learnt_f);

        % Identify incorrect assignment
        incorrect_assignment = (learnt_Y ~= target_Y);

        %Check if learning is still possible (to catch if we are right first time)
        if ( sum(incorrect_assignment) ~= 0 )

            % Find Incorrect points
            incorrect_points = find(incorrect_assignment);

            wrongx = incorrect_points(randi(length(incorrect_points)));

            w = zeros(3,1);
            w(1) = -learnt_f(1);
            w(2) = -learnt_f(2);
            w(3) = 1;

            w(1) = w(1) - target_Y(wrongx);
            w(2) = w(2) - target_Y(wrongx) * X(wrongx,1);
            w(3) = w(3) - target_Y(wrongx) * X(wrongx,2);

            learnt_f(1) = - w(1) / w(3);
            learnt_f(2) = - w(2) / w(3);

            % Update plot
            figure
            pla_plot(X, incorrect_assignment, target_Y, learnt_f)
        endif

        [target_func ; learnt_f]

    until ( sum(incorrect_assignment) == 0 ) 


endfunction

function pla_plot(X, incorrect_assignment, target_Y, target_func)
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

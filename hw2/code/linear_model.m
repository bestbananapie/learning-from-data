function linear_model(num_points = 100,
                      out_sample_points = 1000,
                      num_iterations = 1000);
    num_points
    out_sample_points
    num_iterations

    for i = 1:num_iterations
        % Create articifical training data
        [X_all,Y_all] = create_learning_data(num_points+out_sample_points);

        % Seperate training data into in sample and out of sample points
        X.in = X_all(1:num_points,1);
        Y.in = Y_all(1:num_points,1);

        X.out = X_all(num_points+1:end,1);
        Y.out = Y_all(num_points+1:end,1);

        % Calculate learning model weights
        w = pinv(X.in) * Y.in;

        % Find Assignment from calculated weights
        y.in = sign(X.in * w);
        y.out = sign(X.out * w);

        % Find In sample error
        E_in(i) = sum( [y.in!=Y.in] ) / num_points;

        % Estimate out of sample error
        E_out(i) = sum( [y.out!=Y.out] ) / out_sample_points;

    endfor

    %Print Results
    E_in = mean(E_in)
    E_out = mean(E_out)

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

function nonlinear_notransformation(num_points = 1000,
                      out_sample_points = 0,
                      num_iterations = 1000);
    num_points
    out_sample_points
    num_iterations

    for i = 1:num_iterations
        % Create articifical training data
        [X_all,Y_all] = create_learning_data(num_points+out_sample_points);

        % Seperate training data into in sample and out of sample points
        X.in = X_all(1:num_points,:);
        Y.in = Y_all(1:num_points,:);

        if (out_sample_points != 0) 
            X.out = X_all(num_points+1:end,:);
            Y.out = Y_all(num_points+1:end,:);
        endif

        % Calculate learning model weights
        w = pinv(X.in) * Y.in;

        % Find Assignment from calculated weights
        y.in = sign(X.in * w);
        if (out_sample_points != 0) 
            y.out = sign(X.out * w);
        endif

        % Find In sample error
        E_in(i) = sum( [y.in!=Y.in] ) / num_points;

        % Estimate out of sample error
        if (out_sample_points != 0) 
            E_out(i) = sum( [y.out!=Y.out] ) / out_sample_points;
        endif

    endfor

    %Print Results
    E_in = mean(E_in)
    if (out_sample_points != 0) 
        E_out = mean(E_out)
    endif

endfunction

%This is a pesudo function, actually generates random learning data
function [X,Y] = create_learning_data(num_points);
    %Generate random input space
    X = domain_transfer(rand(num_points, 2));

    %Add bais input
    X = [ones(length(X),1) X];

    % Assign according to target function
    Y = sign(X(:,2).^2 + X(:,3).^2 - 0.6);

    % Add noise
    n = randi(length(Y),[length(Y * 0.1),1]);
    Y(n) = -1 * Y(n);

endfunction

%Remap [0,0] x [1,1] domain space to desired domain space
function P = domain_transfer(P)
    P = P * 2 - 1;
endfunction

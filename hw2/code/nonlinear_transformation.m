function nonlinear_transformation(num_points = 1000,
                      out_sample_points = 1000,
                      num_iterations = 1000);
    num_points
    out_sample_points
    num_iterations

    for i = 1:num_iterations
        % Create articifical training data
        [X_all,Y_all] = create_learning_data(num_points+out_sample_points);

        %Add bais input
        X_all = [ones(length(X_all),1) X_all];

        %Add non-linear features
        X_all = [X_all X_all(:,2).*X_all(:,3) X_all(:,2).^2 X_all(:,3).^2];

        % Seperate training data into in sample and out of sample points
        X_in = X_all(1:num_points,:);
        Y_in = Y_all(1:num_points,:);

        if (out_sample_points != 0) 
            X_out = X_all(num_points+1:end,:);
            Y_out = Y_all(num_points+1:end,:);
        endif

        % Calculate learning model weights
        w = pinv(X_in' * X_in) * X_in' * Y_in;
        w_avg(i,:) = w;

        % Find Assignment from calculated weights
        y_in = sign(X_in * w);
        if (out_sample_points != 0) 
            y_out = sign(X_out * w);
        endif

        % Find In sample error
        E_in(i) = sum( [y_in!=Y_in] ) / num_points;

        % Estimate out of sample error
        if (out_sample_points != 0) 
            E_out(i) = sum( [y_out!=Y_out] ) / out_sample_points;
        endif

    endfor

    %Print Results
    E_in = mean(E_in)
    w_avg = mean(w_avg,1)
    if (out_sample_points != 0) 
        E_out = mean(E_out)
    endif

endfunction

%This is a pesudo function, actually generates random learning data
function [X,Y] = create_learning_data(num_points);
    %Generate random input space
    X = domain_transfer(rand(num_points, 2));

    % Assign according to target function
    Y = sign(X(:,1).^2 + X(:,2).^2 - 0.6);

    % Add noise
    n = randi(length(Y),length(Y) * 0.1);
    Y(n) = -1 * Y(n);

    %figure;
    %hold on
    %plot( X([Y==1],1), X([Y==1],2), 'o' ) 
    %plot( X([Y!=1],1), X([Y!=1],2), '+' ) 

endfunction

%Remap [0,0] x [1,1] domain space to desired domain space
function P = domain_transfer(P)
    P = P * 2 - 1;
endfunction

function linear_model(num_points = 10, num_iterations = 1000)

num_points
num_iterations

%Generate decision points/boundary
    p = domain_transfer(rand(2,2));

[X,Y] = import_learning_data(num_points, p)



endfunction


%This is a pesudo function, actually generates random learning data
function [X,Y] = import_learning_data(num_points,p);

%Generate random input space
X = domain_transfer(rand(num_points, 2));

% Calculate learning input
Y = find_assignement(X,p);


endfunction

function P = domain_transfer(P)
    P = P * 2 - 1;
endfunction

                                
function Y = find_assignment(X,f);
     ( p(2,2) - p(1,2) ) / ( p(2,1) - p(1,1) );
    f(1) = X(1,2) - f(2) * X(1,1);

    Y = f(2) .* X(:,1) .+ f(1) - X(:,2);

    Y = zeros(length(X), 1);
    Y =  ( p(2,2) - p(1,2) ) / ( p(2,1) - p(1,1) ) .* X(:,1) .+ f(1) - X(:,2);

    Y( [Y > 0] ) = 1;
    Y( [Y <= 0] ) = -1;

endfunction
                                    
                                  
                                    
                                    
                                  
                                  ee
                                  

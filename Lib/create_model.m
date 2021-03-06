%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Joshua Fagan
% Date:   06/09/2016
%
% Description: Create a neural network model using the backpropagation algorithm
%
% Parameter: opts - Structure storing user specified hyperparameter values
% Parameter: L    - Cell array storing neural network layers values
% Parameter: W    - Cell array storing neural network weight valeus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [W] = create_model( opts, Test, Train, Val )
    % Create weight and layer matrices
    num_layer = length( opts.arch );
    W = cell( 1, num_layer-1 );
    L = cell( 1, num_layer );
    Z = cell( 1, num_layer-1 );

    % Seed random number generator
    rng( opts.seed );

    for i = 1:num_layer-1
        % Initialize weight to random number between -1 and 1
        W{i} = ( rand( opts.arch(i)+1, opts.arch(i+1) ) * 2 - 1 );

        % Normalize weights by number of nodes they connect to
        W{i} = W{i} ./ ( opts.arch(i) ^ (1/2) );

        % Layer values will be set before operations so just initialize to one 
        L{i} = ones( opts.arch(i)+1, 1 );
        Z{i} = ones( opts.arch(i+1), 1 );
    end
    L{num_layer} = ones( opts.arch(num_layer), 1 ); % No bias for output layer

    % For specified number of iterations, or until convergence
    for iteration = 1:opts.max_iter
        % For each data point
        for sample = 1:size(Train.points, 1)
            % Set input layer to current sample
            L{1} = Train.points( sample, : )';
            T = Train.labels( sample, : )';

            % Perform forward pass
            [L, Z] = forward_pass( L, W, Z );

            % Perform backpropagation of errors
            backprop( opts.alpha, L, T, W, Z )
        end

        % Discount learning rate
    end
end

function x3 = linear_interpret(X, Y)
    arguments
        X (1, 2) % Restrict X to a 1x2 array
        Y (1, 3) % Restrict Y to a 1x3 array
    end
    
    x3 = (Y(2)-Y(3))*X(1) + (Y(3)-Y(1))*X(2) / (Y(2)-Y(1));
end
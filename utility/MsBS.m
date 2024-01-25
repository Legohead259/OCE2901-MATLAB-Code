n = 5; % number of variables

for k = 1:n
    % generate every combination of k variables
    combinations = combnk(1:n, k);
    
    % display the combinations
    fprintf('Combinations of %d variables:\n', k);
    disp(combinations);
end
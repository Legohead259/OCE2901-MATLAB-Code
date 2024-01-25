% Homework 2 for OCE 2901 Surf Engineering Analysis
% Braidan Duffy
% Due: 01-22-2021

%% Question 1

rolls_10 = roll_die(10);        % Generate array of 10 dice rolls
rolls_1000 = roll_die(1000);    % Generate array of 1000 dice rolls

% Calculate mean for each set of rolls
mean_10 = mean(rolls_10)
mean_1000 = mean(rolls_1000)

% Calculate standard deviation for each set of rolls
stdev_10 = std(rolls_10)
stdev_1000 = std(rolls_1000)

% Generate histograms of results
figure(1)
hist_10 = histogram(rolls_10);
xlabel('Roll Value')
ylabel('Count')
title('Histogram of 10 Dice Rolls')
figure(2)
hist_1000 = histogram(rolls_1000);
xlabel('Roll Value')
ylabel('Count')
title('Histogram of 1000 Dice Rolls')

%% Question 2

rolls_two_10 = roll_two_dice_sum(10);       % Generate array of 10 dice rolls
rolls_two_1000 = roll_two_dice_sum(1000);   % Generate array of 1000 dice rolls

% Calculate mean for each set of rolls
mean_two_10 = mean(rolls_two_10)
mean_two_1000 = mean(rolls_two_1000)

% Calculate standard deviation for each set of rolls
stdev_two_10 = std(rolls_two_10)
stdev_two_1000 = std(rolls_two_1000)

% Generate histograms of results
figure(3)
hist_two_10 = histogram(rolls_two_10);
xlabel('Roll Value')
ylabel('Count')
title('Histogram of Two Summed Dice Rolls (10x)')
figure(4)
hist_two_1000 = histogram(rolls_two_1000);
xlabel('Roll Value')
ylabel('Count')
title('Histogram of Two Summed Dice Rolls (1000x)')


%% Utility

% Rolls a singular dice a specified number of times
% @param itr: number of times dice is rolled
% @return an array of dice rolls
function rolls = roll_die(itr)
    rolls = [];
	for x = 1:itr
        rolls(end+1) = randi(6);
    end
end

% Rolls two dice and sums their values a specified number of times
% @param itr: number of times dice is rolled
% @return an array of two summed dice rolls
function rolls = roll_two_dice_sum(itr)
    rolls = [];
    for x = 1:itr
        rolls(end+1) = randi(6) + randi(6);
    end
end
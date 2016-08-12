num_flips = 10;

num_coins = 1000;
num_experiments = 100000;

v = zeros(num_experiments,3);

for i = 1:num_experiments
    flips = rand(num_coins,num_flips);
    flips = round(flips);

    frequency = sum(flips,2) ./ 10;

    v_1 = frequency(1);
    v_rand = frequency(randi(num_coins));
    v_min = min(frequency);

    v(i,:) = [v_1 v_rand v_min];
endfor

mean(v(:,3));

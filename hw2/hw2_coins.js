// Setup Variables
var num_flips = 10;
var num_coins = 1000;
var num_experiments = 100;

// Declare Working variables
var mean_v = [0,0,0];
var frequency = [];
var v_min = 1;

/* For every experiment we flip X many coins Y times. To avoid storing the
 * frequency of each coin, we precompute the random coin, to be able to save
 * that result during runtime. We continuously scan for the minimum results*/

for(var exp = 0; exp < num_experiments; exp++){
    randi = Math.floor(Math.random() * num_coins);
    for(var coin = 0; coin < num_coins; coin++){

        // Routine to calculate the head frequency from flipping the coing N times
        frequency = 0;
        for(var flips = 0; flips < num_flips; flips++){
            frequency += Math.round(Math.random());

        }
        frequency /= num_flips;

        // If the coin is of intrest to the experiment, save the results
        switch(coin){
            case 0:
                mean_v[0] += frequency;
                break
            case randi:
                mean_v[1] += frequency;
                break
        }

        // Look for minium coin
        if (frequency < v_min){
            v_min = frequency;
        }
    }
    
    mean_v[2] += v_min;
}

// Normalise the mean to number of experiments
mean_v[0] /= num_experiments;
mean_v[1] /= num_experiments; 
mean_v[2] /= num_experiments;

console.log("v0 = " + mean_v[0]);
console.log("v_rand = " + mean_v[1]);
console.log("v_min = " + mean_v[2]);

function average_pla(num_points = 10, repeats = 100)

    avg_p = 0;
    avg_i = 0;

    for n =  1:repeats
        n
        [i, p] = pla(num_points);
        avg_p = avg_p + p;
        avg_i = avg_i + i;

    endfor

    avg_p= avg_p / repeats
    avg_i= avg_i / repeats

endfunction

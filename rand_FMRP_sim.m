function FMRP_sim = rand_FMRP_sim(spine_cor,FMRP_cor,n)

    %% INPUT
    % timepoint be k
    % spine_cor be coordinates of spine
    % FMRP_cor be coordinates of FMRP
    % n be number of simulations

    %% OUTPUT
    % mindistofSIMarray be computed distance from sim data
    % sim_post be simulated FMRP coordinate matrix

    % find boundaries for simulation
    lb = min(spine_cor);
    ub = max(spine_cor);

    % simulate desired spine (with n simulations)

    FMRP_sim = lb + (ub - lb).*rand(size(FMRP_cor, 1),n);

end
function [LE_cor ,sim_post, target_type] = rand_spine_sim(timepoint,spine_cor,spine_type_A,spine_type_B,spine_type_C,n, target_type)

    %% INPUT
    % timepoint be k
    % spine_ref_type be reference time point spines
    % target_type be type of targeted spine
    % n be number of simulations

    %% OUTPUT
    % mindistofSIMarray be computed distance from sim data
    % sim_post be simulated data matrix
    % target_type be targeted type simulated (and computed)

    type_ind = zeros(size(spine_cor,1),timepoint);

    % target_type='L.....LE', find correct target of type
    if timepoint == 1
        type_ind = cell2mat(spine_type_A) == 'E';
        target_type = 'E';
    else
        type_ind = (cell2mat(spine_type_A) == target_type(1)).*(cell2mat(spine_type_B) == target_type(2));
    end


    % find correct type (for both conditions)
    type_ind = find(type_ind);  % find indicator
    type_num = length(type_ind);    % find number of desired type

    % find boundaries for simulation
    lb = min(spine_cor);
    ub = max(spine_cor);

    % simulate desired spine (with n simulations)

    sim_post = lb + (ub - lb).*rand(type_num,n);

    %% Extract actual data positions between

    LE_cor = spine_cor(type_ind);
end
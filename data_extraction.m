function [spine_cor, FMRP_cor, spine_type] = data_extraction(time_point, current_data, division_index)
    
    position_m = 4*(time_point+1) - 1;
    type_m = 4*(time_point+1);

    spine_cor = current_data(1:division_index - 1,position_m);  % extract spine cor
    FMRP_cor = current_data(division_index + 1:end,position_m);  % extract FMRP cor
    spine_type = current_data(1:division_index - 1,type_m); % extract spine type

    % convert spine type notation
    spine_type = table2array(spine_type);
    spine_type = extractBefore(spine_type(strlength(spine_type)>1),2);

    % convert to array
    spine_cor = table2array(spine_cor);
    FMRP_cor = table2array(FMRP_cor);
    
    FMRP_cor = rmmissing(FMRP_cor); % remove NaNs

end
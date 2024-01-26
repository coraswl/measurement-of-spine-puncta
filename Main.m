clear all
close all


% simulate newly formed spine
% i) simulate position of newly formed spine
% ii) every newly formed spine measured distance to closest FMRP
% iii) compare to actual data and conduct KS test

group_type = "GroupA"; % group name
timepoint = 2;
target_type = 'LE';%timepoint2/3: 'LE': form; 'EE': stable; 'EL':elim; 
cd(group_type)

sim_num = 1000;

Files=dir('*.xlsx*');   % extract file information
sim_dis_array = [];
dis_array = [];
LE_cor_all = [];
FMRP_cor_use_all = [];
%% Simulation Data (point i and ii)

for k = 1:size(Files,1) % loop through files
    current_file_name = Files(k).name;  % extract file names
    
    [~,sheet_name] = xlsfinfo(current_file_name); % extract sheet names

    for j = 1:numel(sheet_name)

        current_data = readtable(current_file_name,'Sheet',sheet_name{j});    % extract data set from the sheet

        cd ..   % extraction completed, return to original file

        % extract data set

        %% find division line
        NaN_array = find(isnan(table2array(current_data(:,2))) == 1);  % find the array of NaN
        division_index = NaN_array(1);  % find division index
        clear NaN_array

        %% Extract information for given time point
        [spine_cor_1, FMRP_cor_1, spine_type_1] = data_extraction(1, current_data, division_index); % the second column refers to timepoint 1(H0)
        [spine_cor_2, FMRP_cor_2, spine_type_2] = data_extraction(2, current_data, division_index);
        [spine_cor_3, FMRP_cor_3, spine_type_3] = data_extraction(3, current_data, division_index);

        %% Simulation

        if timepoint == 1
            spine_cor_use = spine_cor_1;
            FMRP_cor_use = FMRP_cor_1;
        elseif timepoint == 2
            spine_cor_use = spine_cor_2;
            FMRP_cor_use = FMRP_cor_2;
        else
            spine_cor_use = spine_cor_3;
            FMRP_cor_use = FMRP_cor_3;
        end

         %timepoint2/3: target_type 'LE': form; 'EE': stable; 'EL':elim; 
        [LE_cor ,sim_post, target_type] = rand_spine_sim(timepoint,spine_cor_use,spine_type_1,spine_type_2,spine_type_3,sim_num, target_type);

        FMRP_sim = rand_FMRP_sim(spine_cor_use,FMRP_cor_use,sim_num);
        LE_cor_all = [LE_cor_all; LE_cor];
        FMRP_cor_use_all = [FMRP_cor_use_all; FMRP_cor_use];
        % compute min dist of every LLE spine to closest FMRP (for
        % simulation)

        mindistofSIMarray = [];
        for loop_count = 1:sim_num
            mindistofSIMarray = [mindistofSIMarray; A2Bdist(LE_cor,FMRP_sim(:,loop_count))];
        end


        % compute min dist of every LLE spine to closest FMRP (for actual)
        MinDistArray = A2Bdist(LE_cor,FMRP_cor_use);

        % export simulated FMRP data

        mkdir(append(group_type,"_SIMULATED_FMRP_time",num2str(timepoint)))
        cd(append(group_type,"_SIMULATED_FMRP_time",num2str(timepoint)))
        csvwrite(append(group_type,"_timepoint_",num2str(timepoint),"_file_",current_file_name(1:end-5),"_sheet_",sheet_name{j},"_SIMULATED_FMRP_POSTITION.csv"),FMRP_sim)
        cd ..

        % export min dist computation
        mkdir(append(group_type,"SIMULATED_newly_formed_mindist2FMRP_time",num2str(timepoint)))
        cd(append(group_type,"SIMULATED_newly_formed_mindist2FMRP_time",num2str(timepoint)))
        csvwrite(append(group_type,"_timepoint_",num2str(timepoint),"_file_",current_file_name(1:end-5),"_sheet_",sheet_name{j},"_SIMULATED_DISTANCES_target_",target_type,".csv"),mindistofSIMarray)
        cd ..

        sim_dis_array = [sim_dis_array;mindistofSIMarray];
        dis_array = [dis_array; MinDistArray];

        %% This loop is completed, return to data file
        cd(group_type)

    end

end
cd ..

mkdir("RESULTS")
cd("RESULTS")

csvwrite(append(group_type,"_timepoint_",num2str(timepoint),"_SIMULATED_DISTANCES_target_",target_type,".csv"),sim_dis_array)
csvwrite(append(group_type,"_timepoint_",num2str(timepoint),"_ACTUAL_DISTANCES_target_",target_type,".csv"),dis_array)

[h,p] = kstest2(dis_array,sim_dis_array);

f = figure;
cdfplot(dis_array)
hold on
cdfplot(sim_dis_array)
legend("Minimal Distance","Simulated Minimal Distance")
title(append(group_type," timepoint = ",num2str(timepoint)," minimal distances of ",target_type," spines to closest FMRP"))
text(15,0.5,append("KS-test p-value = ",num2str(p)))
saveas(f,append(group_type,"_",target_type,"_timepoint_",num2str(timepoint),".fig"))
saveas(f,append(group_type,"_",target_type,"_timepoint_",num2str(timepoint),".jpeg"))


cd ..



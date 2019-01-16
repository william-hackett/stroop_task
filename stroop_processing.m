current_directory = dir('PsychtoolboxStroopData');
current_directory = current_directory(3:end);

control_RT = zeros(1,5);
conflict_RT = zeros(1,5);
noconflict_RT = zeros(1,5);

control_error = zeros(1,5);
conflict_error = zeros(1,5);
noconflict_error = zeros(1,5);

control_RT_std = zeros(1,5);
control_error_std = zeros(1,5);

conflict_RT_std = zeros(1,5);
conflict_error_std = zeros(1,5);

noconflict_RT_std = zeros(1,5);
noconflict_error_std = zeros(1,5);

for ii = 1:5
    filename = current_directory(ii).name;
    fid = fopen(filename, 'r');
    raw_data = textscan(fid, '%f %f %s %.4f %f', 'Headerlines', 1, 'Delimiter', ',');
    fclose(fid);
    
    frameID = raw_data{1};
    condition = raw_data{2};
    stimulus = raw_data{3};
    reaction_time = raw_data{4};
    error = raw_data{5};
    
    conflict_index = [];
    noconflict_index = [];
    control_index = []
    for kk = 1:30
        if condition(kk) == 0
            control_index = [control_index kk];
        elseif condition(kk) == 1
            conflict_index = [conflict_index kk];
        elseif condition(kk) == 2
            noconflict_index = [noconflict_index kk];
        end
    end
    
    data_control = [reaction_time(control_index), error(control_index)];
    data_conflict = [reaction_time(conflict_index), error(conflict_index)];
    data_noconflict = [reaction_time(noconflict_index), error(noconflict_index)];
    
    control_RT(ii) = mean(data_control(:,1));
    conflict_RT(ii) = mean(data_conflict(:,1));
    noconflict_RT(ii) = mean(data_noconflict(:,1));
    
    control_error(ii) = mean(data_control(:,2));
    conflict_error(ii) = mean(data_conflict(:,2));
    noconflict_error(ii) = mean(data_noconflict(:,2));
    
    control_RT_std(ii) = std((data_control(:,1)));
    control_error_std(ii) = std(double(data_control(:,2)));
    
    conflict_RT_std(ii) = std(double(data_conflict(:,1)));
    conflict_error_std(ii) = std(double(data_conflict(:,2)));
    
    noconflict_RT_std(ii) = std(double(data_noconflict(:,1)));
    noconflict_error_std(ii) = std(double(data_noconflict(:,2)));
end

control_RT = mean(control_RT);
conflict_RT = mean(conflict_RT);
noconflict_RT = mean(noconflict_RT);

control_error = mean(control_error);
conflict_error = mean(conflict_error);
noconflict_error = mean(noconflict_error);

control_RT_std = mean(control_RT_std);
control_error_std = mean(control_error_std);

conflict_RT_std = mean(conflict_RT_std);
conflict_error_std = mean(conflict_error_std);

noconflict_RT_std = mean(noconflict_RT_std);
noconflict_error_std = mean(noconflict_error_std);

a = figure();
bar(1, conflict_RT);
hold on;
errorbar([1],conflict_RT, conflict_RT_std);
hold on;

bar(2, noconflict_RT);
hold on;
errorbar([2],noconflict_RT, noconflict_RT_std);
hold on;

bar(3, control_RT);
hold on;
errorbar([3],control_RT, control_RT_std);
hold on;

ylim([0 max(conflict_RT,noconflict_RT)+1.5*conflict_RT_std]);
xlim([0 4]);
xticks([0 1 2 3 4]);
xticklabels({'','Conflict','No Conflict','Control', ''});
xlabel('Condition'); ylabel('Mean Reaction Time (ms)'); title('Within-Subject: Reaction time');

b =figure();
bar(1, conflict_error);
hold on;
errorbar([1],conflict_error, conflict_error_std);
hold on;

bar(2, noconflict_error);
hold on;
errorbar([2],noconflict_error, noconflict_error_std);
hold on;

bar(3, control_error);
hold on;
errorbar([3],control_error, control_error_std);
hold on;

ylim([-.2 0.6]);
xlim([0 4]);
xticks([0 1 2 3 4]);
xticklabels({'','Conflict','No Conflict','Control', ''});
xlabel('Condition'); ylabel('Mean Error'); title('Within-Subject: Error');
%% PROCESS_HUMAN_DATA  Process human force plate data to obtain
%                      intersection-point heights for each trail of each
%                      subject
%
% Authors: Kaymie Shiozawa (kaymies@mit.edu), 
%          Rika Sugimoto Dimitrova (rikasd@mit.edu),
%          Kreg G. Gruben
% 2025-07-22
% Last updated: 2025-08-13

clear zIP_all zIP_p_all zIP_np_all

run setup

ind_time = 1;

ind_Fx_d = 2;
ind_Fz_d = 3;
ind_CP_d = 4;
ind_Fx_nd = 5;
ind_Fz_nd = 6;
ind_CP_nd = 7;

ind_Fx_p = 2;
ind_Fz_p = 3;
ind_CP_p = 4;
ind_Fx_np = 5;
ind_Fz_np = 6;
ind_CP_np = 7;

%% Controls
dosSantos_data_info = load('dosSantos2017_old_data_info.mat');

N_subj = dosSantos_data_info.NumSubjects;
N_trials = dosSantos_data_info.NumTrials;

count = 1;

for iSubj = 1:N_subj 

for itrial = 1:N_trials

clear data_ip

data_raw = ...
    importdata(['Control ' num2str(iSubj-1) ' trial ' num2str(itrial-1) '.txt']);

time_s = data_raw.data(:,ind_time)';
data_ip.sampFreq_Hz = 1/(time_s(2) - time_s(1));
data_ip.COM = zeros([2,length(time_s)]) + [0; 0.56*dosSantos_data_info.DataInfo.Height(iSubj)];

% Dominant leg
data_ip.COP = data_raw.data(:,ind_CP_d)';
data_ip.FootForce(1,:) = -data_raw.data(:,ind_Fx_d)';
data_ip.FootForce(2,:) =  data_raw.data(:,ind_Fz_d)';

[f_zIP,zIP] = getZIPfromData(data_ip,params_ip);
zIP_all(:,count) = zIP;

% Non-dominant leg
data_ip.COP = data_raw.data(:,ind_CP_nd)';
data_ip.FootForce(1,:) = -data_raw.data(:,ind_Fx_nd)';
data_ip.FootForce(2,:) =  data_raw.data(:,ind_Fz_nd)';

[~,zIP] = getZIPfromData(data_ip,params_ip);
zIP_all(:, count + N_subj*N_trials) = zIP;

count = count + 1;

end

end

%%
zIP_mean = mean(zIP_all,2,'omitnan');
zIP_SD = std(zIP_all,[],2,'omitnan');

% Remove data that is 3 standard deviations away from the mean
zIP_all(zIP_all < zIP_mean - 3*zIP_SD) = NaN;
zIP_all(zIP_all > zIP_mean + 3*zIP_SD) = NaN;
zIP_mean = mean(zIP_all,2,'omitnan');
zIP_SD = std(zIP_all,[],2,'omitnan');

% Save results
controls_zIP_struct = struct(...
    'DataInfo', dosSantos_data_info.DataInfo,...
    'Frequency', f_zIP,...
    'IP', zIP_all,...
    'IPDataAverage', zIP_mean,...
    'IPMethod', params_ip.method,...
    'MeanHeight_m', dosSantos_data_info.MeanHeight_m,...
    'MeanMass_kg', dosSantos_data_info.MeanMass_kg,...
    'NumSubjects', N_subj,...
    'Plane', 'sgt',...
    'Pose', 'pose_I',...
    'StandardDeviation', zIP_SD,...
    'SubjectType', dosSantos_data_info.SubjectType );
save([zIPdata_dir '/' data_filenames{1}], '-struct', 'controls_zIP_struct');
disp(['Saved unimpaired zIP data at ' zIPdata_dir '/' data_filenames{1} '.mat'])

%% Post-stroke
Bartloff_p_data_info = load('Bartloff2024_paretic_data_info.mat');
Bartloff_np_data_info = load('Bartloff2024_nonparetic_data_info.mat');

N_subj = Bartloff_p_data_info.NumSubjects;

count = 1;

for iSubj = 1:N_subj

clear data_ip

data_raw = importdata(['Stroke ' num2str(iSubj-1) '.txt']);

time_s = data_raw.data(:,ind_time)';
data_ip.sampFreq_Hz = 1/(time_s(2) - time_s(1));
data_ip.COM = zeros([2,length(time_s)]) + [0; 0.56*Bartloff_p_data_info.DataInfo.Height(iSubj)];

% Paretic leg
data_ip.COP = data_raw.data(:,ind_CP_p)';
data_ip.FootForce(1,:) = -data_raw.data(:,ind_Fx_p)';
data_ip.FootForce(2,:) =  data_raw.data(:,ind_Fz_p)';

[f_zIP,zIP] = getZIPfromData(data_ip,params_ip);
zIP_p_all(:,count) = zIP;

% Non-paretic leg
data_ip.COP = data_raw.data(:,ind_CP_np)';
data_ip.FootForce(1,:) = -data_raw.data(:,ind_Fx_np)';
data_ip.FootForce(2,:) =  data_raw.data(:,ind_Fz_np)';

[~,zIP] = getZIPfromData(data_ip,params_ip);
zIP_np_all(:, count) = zIP;

count = count + 1;

end

%%
zIP_p_mean  = mean(zIP_p_all,2,'omitnan');
zIP_p_SD    = std(zIP_p_all,[],2,'omitnan');
zIP_np_mean = mean(zIP_np_all,2,'omitnan');
zIP_np_SD   = std(zIP_np_all,[],2,'omitnan');

% Remove data that is 3 standard deviations away from the mean
zIP_p_all(zIP_p_all < zIP_p_mean - 3*zIP_p_SD) = NaN;
zIP_p_all(zIP_p_all > zIP_p_mean + 3*zIP_p_SD) = NaN;
zIP_p_mean = mean(zIP_p_all,2,'omitnan');
zIP_p_SD = std(zIP_p_all,[],2,'omitnan');
zIP_np_all(zIP_np_all < zIP_np_mean - 3*zIP_np_SD) = NaN;
zIP_np_all(zIP_np_all > zIP_np_mean + 3*zIP_np_SD) = NaN;
zIP_np_mean = mean(zIP_np_all,2,'omitnan');
zIP_np_SD = std(zIP_np_all,[],2,'omitnan');

% Save results
paretic_zIP_struct = struct(...
    'DataInfo', Bartloff_p_data_info.DataInfo,...
    'Frequency', f_zIP,...
    'IP', zIP_p_all,...
    'IPDataAverage', zIP_p_mean,...
    'IPMethod', params_ip.method,...
    'MeanHeight_m', Bartloff_p_data_info.MeanHeight_m,...
    'MeanMass_kg', Bartloff_p_data_info.MeanMass_kg,...
    'NumSubjects', N_subj,...
    'Plane', 'sgt',...
    'Pose', 'pose_I',...
    'StandardDeviation', zIP_p_SD,...
    'SubjectType', Bartloff_p_data_info.SubjectType );
save([zIPdata_dir '/' data_filenames{2}], '-struct', 'paretic_zIP_struct');
disp(['Saved post-stroke paretic limb zIP data at ' zIPdata_dir '/' data_filenames{2} '.mat'])

nonparetic_zIP_struct = struct(...
    'DataInfo', Bartloff_np_data_info.DataInfo,...
    'Frequency', f_zIP,...
    'IP', zIP_np_all,...
    'IPMethod', params_ip.method,...
    'IPDataAverage', zIP_np_mean,...
    'MeanHeight_m', Bartloff_np_data_info.MeanHeight_m,...
    'MeanMass_kg', Bartloff_np_data_info.MeanMass_kg,...
    'NumSubjects', N_subj,...
    'Plane', 'sgt',...
    'Pose', 'pose_I',...
    'StandardDeviation', zIP_np_SD,...
    'SubjectType', Bartloff_np_data_info.SubjectType );
save([zIPdata_dir '/' data_filenames{3}], '-struct', 'nonparetic_zIP_struct');
disp(['Saved post-stroke nonparetic limb zIP data at ' zIPdata_dir '/' data_filenames{3} '.mat'])
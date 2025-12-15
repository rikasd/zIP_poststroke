data_dir = './data_raw';
zIPdata_dir = './data_zIP';
bestfitparams_dir = './bestfitparams';
figure_dir = './figure';

addpath(genpath(data_dir))
addpath(genpath(zIPdata_dir))
addpath(genpath(bestfitparams_dir))
addpath(genpath('./data_processing'))
addpath(genpath('./model'))
addpath(genpath('./visuals'))
addpath(genpath('./zIP'))

% Set figure properties
set(0, 'DefaultLineLineWidth', 2);
set(groot,'DefaultAxesFontSize',16);
set(0,'Defaultfigurecolor',[1 1 1]);

%% zIP parameters
params_ip.method = 'bpf';
params_ip.detrend_option = 2;      % 1: no detrend, 2: zeromean, 3: linear detrend
params_ip.window_taper_option = 1; % 1: rectangular, 2: Hann, 3: Hamming
params_ip.f_int = 0.5; % frequency interval
params_ip.f_min = 1;   % minimum frequency
params_ip.f_max = 6;   % maximum frequency

%% Constant parameters used throughout
data_filenames = {...
    'dosSantos2017_old',...
    'Bartloff2024_paretic',...
    'Bartloff2024_nonparetic'...
    };
data_types = {'Unimpaired','Paretic','Non-paretic'};
colors = [ 0.500    0.500    0.500
               0    0.447    0.741
           0.850    0.325    0.098];
alpha = 1e6;

%% Simulation parameters
input_struct.simFreq_Hz         = 1000;
input_struct.sampFreq_Hz        = 1000;
input_struct.simDuration_s      = 1000;
input_struct.motorNoiseLvL_Nm   = 1;
input_struct.noise_type         = 'w';
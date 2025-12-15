function [f_zIP, zIP_ratio] = getZIPfromData(data,params)
%% GETZIPFROMDATA Get zIP over freq from data
% Obtain intersection-point height (zIP) at different frequencies from
% standing data
%
% Inputs:
% data = a struct containing a single trial of data, or
%        a cell with M structs (one struct per trial, for M trials of data)
%        containing the following info:
%      - COM = 2xN COM position in the 2D plane of interest
%              with the first row corresponding to the horizontal direction
%              and the second row to the vertical direction.
%      - COP = 1xN COP position in the 2D plane of interest
%      - FootForce = 2xN Foot-force vector
%              with first row corresponding to the horizontal component
%              and the second row to the vertical component.
%      - sampFreq_Hz = sampling frequency of data, in Hz
% params = struct containing parameters for zIP analysis
%      - method = string that specifies the method for computing zIP from
%                 experimental data; choose from:
%                 'cpsd' (default) = co-spectral density method 
%                 'bpf'      = band-pass-filter (BPF) method 
%      - window_size = CPSD window size (default: 2^9)
%      - detrend_option = 1: no detrend, 2: zeromean, 3: linear detrend (default)
%      - window_taper_option = 1: rectangular, 2: Hann (default), 3: Hamming
%      - f_int = BPF bandwidth (default: 0.2)
%      - f_min = lowest frequency at which to compute zIP with BPF methods
%      - f_max = highest frequency at which to compute zIP with BPF methods
%
% Outputs:
% f_zIP     = frequencies at which zIP is evaluated
% zIP_ratio = zIP/zCOM; intersection-point height normalized by COM height
%
% Rika Sugimoto Dimitrova
% 2024-02-06
% Last updated: 2025-08-13

% detrend settings
iRAW = 1;
iZEROMEAN = 2;
iDETREND = 3;

% window taper settings
iRECTWIN = 1;
iHANNWIN = 2;
iHAMMWIN = 3;

iX = 1; % index of horizontal direction
iZ = 2; % index of vertical direction

% Default parameters
method = 'cpsd';
window_size = 2^9;
detrend_option = iDETREND;
window_taper_option = iHANNWIN;
f_int = 0.2; % BPF frequency interval
f_min = 0.5;
f_max = 6;

if iscell(data)
    data_cell = data;
elseif isstruct(data)
    data_cell{1} = data;
else
    ME = MException('getZIPfromData:incorrectInputType', ...
        'data argument should be of type cell or struct');
    throw(ME)
end

if nargin > 1 && isfield(params,'method')
    method = params.method;
end

if strcmp(method,'bpf') || strcmp(method,'cpsd2bpf')
    window_size = length(data_cell{1}.COP);   % Use full data length
elseif nargin > 1 && isfield(params,'window_size')
    window_size = params.window_size;
end

if nargin > 1 && isfield(params,'detrend_option')
    detrend_option = params.detrend_option;
end

if nargin > 1 && isfield(params,'window_taper_option')
    window_taper_option = params.window_taper_option;
end

if nargin > 1 && isfield(params,'f_int')
    f_int = params.f_int;
end

if nargin > 1 && isfield(params,'f_min')
    f_min = params.f_min;
end

if nargin > 1 && isfield(params,'f_max')
    f_max = params.f_max;
end

switch window_taper_option
    case iRECTWIN
        windowtaper = rectwin(window_size);
    case iHANNWIN
        windowtaper = hann(window_size);
    case iHAMMWIN
        windowtaper = hamming(window_size);
end

nfft = window_size*2;
noverlap = 0.5*window_size;

% BPF frequency bins
f_i = f_min - f_int/2; f_f = f_max - f_int/2; % starting freq, frequency range
f_bpf = (f_i:f_int:f_f)'; % frequency bins
        
Fs_Hz = data_cell{1}.sampFreq_Hz;
dt = 1/Fs_Hz;

switch method
    case 'cpsd'

        for iTrial = 1:length(data_cell)
            COM_z = data_cell{iTrial}.COM(iZ,:);    % vertical CoM
            COP_x = data_cell{iTrial}.COP(iX,:);    % 1D CoP
            Fx = data_cell{iTrial}.FootForce(iX,:); % horizontal ground reaction force
            Fz = data_cell{iTrial}.FootForce(iZ,:); % vertical ground reaction force
            theta_F = -Fx./Fz;
        
            switch detrend_option
                case iRAW
                    y = [theta_F' COP_x']; 
                case iZEROMEAN
                    y = [detrend(theta_F,0)' detrend(COP_x,0)']; 
                case iDETREND
                    y = [detrend(theta_F,1)' detrend(COP_x,1)']; 
            end 
            
            [Gyy_temp, f_zIP] = ...
                cpsd_custom(y,y,windowtaper,noverlap,nfft,'mimo',Fs_Hz,...
                detrend_option);
    
            Gyy11(:,iTrial) = Gyy_temp(:,1,1);
            Gyy12(:,iTrial) = Gyy_temp(:,1,2);
            Gyy21(:,iTrial) = Gyy_temp(:,2,1);
            Gyy22(:,iTrial) = Gyy_temp(:,2,2);
        end
            
        zIP_ratio = zeros(window_size+1,1);        
        for i = 1:(window_size+1)
            Gyy(1,1) = mean(Gyy11(i,:),2);
            Gyy(1,2) = mean(Gyy12(i,:),2);
            zIP_ratio(i) = real(Gyy(1,2))/real(Gyy(1,1)) / mean(COM_z);
        end

    case 'bpf'

        rm_frac = 0.06;
        zIP_ratio = zeros(length(f_bpf),1);
        VAF = zeros(length(f_bpf),1);

        iTrial = 1;

        COM_z = data_cell{iTrial}.COM(iZ,:);
        COP_x = data_cell{iTrial}.COP(iX,:);
        Fx = detrend(data_cell{iTrial}.FootForce(iX,:),0);
        Fz = data_cell{iTrial}.FootForce(iZ,:);
        theta_F = -Fx./Fz;

        mean_zCOM = mean(COM_z);        

        switch detrend_option
            case iRAW                    
                cop_zm = COP_x'; 
                theta_zm = theta_F';
            case iZEROMEAN
                cop_zm = detrend(COP_x,0)'; 
                theta_zm = detrend(theta_F,0)'; 
            case iDETREND
                cop_zm = detrend(COP_x,1)'; 
                theta_zm = detrend(theta_F,1)'; 
        end 

        cop_zm = cop_zm.*windowtaper; 
        theta_zm = theta_zm.*windowtaper; 

        N = length(cop_zm);
        index_start = round(rm_frac*N);
        index_end = N - index_start;
        indices = index_start:index_end;

        COP_f = zeros(length(f_bpf),length(indices));
        theta_f = zeros(length(f_bpf),length(indices));

        for f = 1:length(f_bpf)
            [B,A] = butter(2,[f_bpf(f) f_bpf(f)+f_int]/(1/dt/2)); % BPF
            COP_f_temp = filtfilt(B,A,cop_zm);
            theta_f_temp = filtfilt(B,A,theta_zm);

            COP_f(f,:) = COP_f_temp(indices);
            theta_f(f,:) = theta_f_temp(indices);
        end %f

        for f = 1:length(f_bpf)
            COV_MAT = cov(theta_f(f,:), COP_f(f,:));
            zIP_ratio(f) = COV_MAT(1,2)/COV_MAT(1,1)/mean_zCOM;
        end % f

        f_zIP = f_bpf + f_int/2;

end % switch method

end
% Main script

clear; clc; close all;

run setup

%% Process force plate data to obtain intersection point height (zIP)

run process_human_data     % Process force plate data to obtain zIP for
                           % each trial of each subject

%% Run parameter search for best-fit models 
% May take over 30 min to run; you may wish to skip running this section, 
% and use the search results already available in the "bestfitparams" 
% folder

run search_params_bestfit  % Run global parameter search to find model 
                           % parameters that best fit human zIP

%% Generate figures from paper:

run plot_human_zIP         % Fig. 1 - zIP from human data


run plot_model_zIP         % Fig. 3 - zIP from best-fit model


run plot_stiffness_ellipse % Fig. 4 - ellipse-circle representation of 
                           %          apparent stiffness of best-fit models
                        
pause(1) %----- pause for 1 second to allow Fig. 4 to fully generate -----%

run plot_torque_dist       % Fig. 5 - distribution of commanded joint 
                           %          torques from simulations of best-fit 
                           %          models 
                           %          (simulations may take a few minutes
                           %          to run)
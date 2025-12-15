# Foot-ground force data

Contains force plate data from post-stroke patients, from experiments by
[Bartloff et al. (2024)](https://doi.org/10.1016/j.jbiomech.2024.111953),
and from unimpaired age-matched control subject data from experiments by 
[dos Santos et al. (2017)](https://doi.org/10.7717/peerj.3626).

## Data file content

Each post-stroke data file ('Stroke #.txt', where # = subject number) contains the following data:

    time (s)              - time stamp, in seconds

    paretic Fap (N)       - paretic-limb anterior-posterior shear force, in Newtons

    paretic Fvert (N)     - paretic-limb vertical force, in Newtons

    paretic CPap (m)      - paretic-limb anterior-posterior center-of-pressure position, in meters

    non-paretic Fap (N)   - non-paretic-limb anterior-posterior shear force, in Newtons

    non-paretic Fvert (N) - non-paretic-limb vertical force, in Newtons

    non-paretic CPap (m)  - non-paretic-limb anterior-posterior center-of-pressure position, in meters

Each unimpaired data file 'Control #s trial #t.txt', where #s = subject number, #t = trial number) contains the following data:

    time (s)               - time stamp, in seconds

    dominant Fap (N)       - dominant-limb anterior-posterior shear force, in Newtons

    dominant Fvert (N)     - dominant-limb vertical force, in Newtons

    dominant CPap (m)      - dominant-limb anterior-posterior center-of-pressure position, in meters

    non-dominant Fap (N)   - non-dominant-limb anterior-posterior shear force, in Newtons

    non-dominant Fvert (N) - non-dominant-limb vertical force, in Newtons

    non-dominant CPap (m)  - non-dominant-limb anterior-posterior center-of-pressure position, in meters

In addition to the force data, the folder contains data info files 
('Bartloff2024_paretic_data_info.mat','Bartloff2024_nonparetic_data_info.mat','dosSantos2017_old_data_info.mat')
containing the following information:

    DataInfo  - subject information

    MeanHeight_m  - average height of all subjects in data set, in meters

    MeanMass_kg   - average mass of all subjects in data set, in kilograms

    NumSubjects   - number of subjects in data set

    SubjectType       - details on data group

Finally, 'height.txt' contains the height, in meters, of all subjects.

## References:

Bartloff, J. N., Ochs, W. L., Nichols, K. M., & Gruben, K. G. (2024). Frequency-dependent behavior of paretic and non-paretic leg force during standing post stroke. Journal of Biomechanics, 164(January), 111953. https://doi.org/10.1016/j.jbiomech.2024.111953

dos Santos, D. A., Fukuchi, C. A., Fukuchi, R. K., & Duarte, M. (2017). A data set with kinematic and ground reaction forces of human balance. PeerJ, 2017(7), 1–17. https://doi.org/10.7717/peerj.3626
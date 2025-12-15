# Intersection-point-height (zIP) data

Contains results of intersection-point-height (zIP) computation for 
each trial of each subject, from process_human_data.m.

## Data file content

The data files contain the following information for each subject group:

    DataInfo  - subject information

    Frequency - frequency points at which IP was computed

    IP        - intersection-point height over frequency for subject

    IPDataAverage - average intersection-point height over frequency across all subjects

    MeanHeight_m  - average height of all subjects in data set, in meters

    MeanMass_kg   - average mass of all subjects in data set, in kilograms

    NumSubjects   - number of subjects in data set

    Plane      - plane of analysis ('sgt' for sagittal, 'frt' for frontal)

    Pose       - subjects' standing pose ('pose_I' when hands are by their side, 'pose_T' when arms are abducted)

    StandardDeviation - standard deviation of intersection-point height over frequency across all subjects

    SubjectType   - details on data group
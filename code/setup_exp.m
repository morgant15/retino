function exp = setup_exp(varargin)
%SETUP_EXP sets up default parameters for the experiment
if nargin == 0
    exp = struct();
end

% setup directories variables
myname = mfilename;
mydir = which(myname);
curdir = fileparts(mydir);
exp.dir.csv = fullfile(fileparts(curdir), 'csv');
exp.dir.stim = fullfile(fileparts(curdir), 'stim');
exp.dir.res = fullfile(fileparts(curdir), 'res');

% debug?
exp.cfg.debug = 0;

% setup experiment
% screen setup
if strcmp(computer, 'MACI64')
    exp.screen.resolution = [1024 768 0];
    exp.screen.actual_refresh = 60;
else
    exp.screen.resolution = [1024 768 60];
    exp.screen.actual_refresh = exp.screen.resolution(3);
end
exp.screen.dist_cm = 50;  % distance subject-screen
exp.screen.w_cm = 36.5;  % width of the screen in cm
exp.screen.bg_color = [128 128 128];
% convert visual angle -> pixel
exp.screen.deg2p = angle2pix(1, exp.screen.dist_cm, exp.screen.w_cm, ...
                             exp.screen.resolution(1));
% stimuli position
exp.stim.size_deg = [3 3];
exp.stim.pos_deg = [2 4 7];
exp.stim.fixcross_size_deg = [1.5 1.5];
exp.stim.pos_rot = pi/3;  % position of the stimuli in radians
% convert sizes in pixels
exp.stim.size_pix = round(exp.screen.deg2p * ...
                          exp.stim.size_deg);
exp.stim.pos_pix = round(exp.screen.deg2p * ...
                         exp.stim.pos_deg);
exp.stim.fixcross_size_pix = round(exp.screen.deg2p * ...
                                   exp.stim.fixcross_size_deg);


% time variables: _s in seconds, _f in flips
exp.time.fix_s = 0.5;
exp.time.min_jitter_s = 0;
exp.time.max_jitter_s = 0;
exp.time.stim_duration_s = 0.05;
exp.time.delay_question_s = 0.25;  % question delay

% convert time in flips
exp.time.fix_f = round(exp.time.fix_s * exp.screen.actual_refresh);
exp.time.min_jitter_f = round(exp.time.min_jitter_s * ...
                              exp.screen.actual_refresh);
exp.time.max_jitter_f = round(exp.time.max_jitter_s * ...
                              exp.screen.actual_refresh);
exp.time.stim_duration_f = round(exp.time.stim_duration_s * ...
                                 exp.screen.actual_refresh);
exp.time.delay_question_f = round(exp.time.delay_question_s * ...
                                  exp.screen.actual_refresh);


end


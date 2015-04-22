function exp = setup_exp(varargin)
%SETUP_EXP sets up default parameters for the experiment
if nargin == 0
    exp = struct();
else
    exp = varargin{1};
end

% setup directories variables
myname = mfilename;
mydir = which(myname);
curdir = fileparts(mydir);
exp.dir.csv = fullfile(fileparts(curdir), 'csv');
exp.dir.stim = fullfile(fileparts(curdir), 'stim');
exp.dir.res = fullfile(fileparts(curdir), 'res');

% CFG
exp.cfg.debug = 0;
exp.cfg.key_yes = KbName('LeftArrow');
exp.cfg.key_no = KbName('RightArrow');
exp.cfg.button_ids = [exp.cfg.key_yes, exp.cfg.key_no];
exp.cfg.msg_start = ['BLABLABLA MY MESSAGE TO YOU'];

% CSV storing trial info
exp.csv.struct = '%s%s%s%s%s%s%s%s';  %TODO: fix this accordingly
exp.csv.cue_col = 2;
exp.csv.target_col = 3;
exp.csv.pos_col = 4;
exp.csv.angle_col = 5;

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
exp.time.cue_s = 0.05;
exp.time.interval_s = 0.1;
exp.time.tar_s = 0.05;
exp.time.delay_question_s = 0.25;  % question delay

% convert time in flips
exp.time.fix_f = round(exp.time.fix_s * exp.screen.actual_refresh);
exp.time.min_jitter_f = round(exp.time.min_jitter_s * ...
                              exp.screen.actual_refresh);
exp.time.max_jitter_f = round(exp.time.max_jitter_s * ...
                              exp.screen.actual_refresh);
exp.time.cue_f = round(exp.time.cue_s * ...
                       exp.screen.actual_refresh);   
exp.time.interval_f = round(exp.time.interval_s * ...
                            exp.screen.actual_refresh);  
exp.time.tar_f = round(exp.time.tar_s * ...
                       exp.screen.actual_refresh);
exp.time.delay_question_f = round(exp.time.delay_question_s * ...
                                  exp.screen.actual_refresh);


end


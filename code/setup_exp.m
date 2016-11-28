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
%exp.dir.csv = fullfile(fileparts(curdir), 'csv');
exp.dir.stim = fullfile(fileparts(curdir), 'stim');
exp.dir.res = fullfile(fileparts(curdir), 'res');

% CFG
exp.cfg.debug = 0;
exp.cfg.key_yes = KbName('LeftArrow');
exp.cfg.key_no = KbName('RightArrow');
exp.cfg.button_ids = [exp.cfg.key_yes, exp.cfg.key_no];
exp.cfg.msg_start = ['BLABLABLA MY MESSAGE TO YOU'];
exp.cfg.msg_response = ['Left: Identity A \t\t\t Right: Identity B'];

% setup for blocks
exp.cfg.angle_pos = 0:7;
exp.cfg.morphs = round(linspace(0, 100, 7));
exp.cfg.pos_deg = 0:7;  % in radians, pi/4
exp.cfg.ecc_deg = [7];
exp.cfg.nrep_in_block = 2;
% Then, add stimulus name
exp.cfg.fn = '%03d.png';  % e.g., 000.png, 050.png, 100.png morphs

% block order is made on the fly
% CSV storing trial info
% exp.csv.struct = '%s%s%s%s%s%s%s%s';  %TODO: fix this accordingly
% exp.csv.cue_col = 2;
% exp.csv.target_col = 3;
% exp.csv.pos_col = 4;
% exp.csv.angle_col = 5;

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
exp.stim.ecc_deg = exp.cfg.ecc_deg;
exp.stim.fixcross_size_deg = [1.5 1.5];
exp.stim.pos_rot = pi/4;  % position of the stimuli in radians
% convert sizes in pixels
exp.stim.size_pix = round(exp.screen.deg2p * ...
                          exp.stim.size_deg);
exp.stim.ecc_pix = round(exp.screen.deg2p * ...
                         exp.stim.ecc_deg);
exp.stim.fixcross_size_pix = round(exp.screen.deg2p * ...
                                   exp.stim.fixcross_size_deg);


% time variables: _s in seconds, _f in flips
exp.time.fix_s = 0.5;
exp.time.min_jitter_s = 0;
exp.time.max_jitter_s = 0;
exp.time.stim_s = 0.05;

% convert time in flips
exp.time.fix_f = round(exp.time.fix_s * exp.screen.actual_refresh);
exp.time.min_jitter_f = round(exp.time.min_jitter_s * ...
                              exp.screen.actual_refresh);
exp.time.max_jitter_f = round(exp.time.max_jitter_s * ...
                              exp.screen.actual_refresh);
exp.time.stim_f = round(exp.time.stim_s * ...
                        exp.screen.actual_refresh);
end

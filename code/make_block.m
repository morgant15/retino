function block = make_block(cfg)
%
% cfg.angle_pos = 0:7;
% cfg.morphs = round(linspace(0, 100, 7));
% cfg.pos_deg = 0:45:359;
% cfg.ecc_deg = [7];
% cfg.nrep_in_block = 2;
%
% this will generate 8 blocks with 112 trials each
% 8 positions * 7 morphs * nrep_in_block

% save some types
header = {'ntrl', 'morph', 'pos', 'ecc'};
block = cartprod(cfg.morphs, cfg.pos_deg);
block = repmat(block, [cfg.nrep_in_block, 1]);
ntrls_block = length(block);

block = [num2cell(block), repmat(num2cell(cfg.ecc_deg), [ntrls_block, 1])];
block = block(randperm(ntrls_block), :);
block = [num2cell(1:ntrls_block)', block];

block = [header; block];
    
function [] = batch_abdomen_tip(root, vidvar, npts, mask_mode, loop_mask, playback)
%% batch_abdomen_tip: runs abdomen tracker for user selected video files
%
%   INPUT:
%       root        :   root directory
%       vidvar      :   video variable name
%       npts        :   # of points for tip tracker
%       mask_mode 	:   [x y]. x is a boolean that sets whether initial mask position is 
%                       automatically computed (true) or not (false). y is a boolean that sets 
%                       whether initial mask position is editable by user after being set by 
%                       x (true) or left using the initial position (false). 
%                       Ex: [1 1] (set automatically & and let user edit after)
%                       Can also specifiy a mask structure saved from previous tracker.
%       loop_mask   :   if true, then only set mask for 1st file
%       playback    :   playback rate (show a frame in increments of "playback")
%                       If false, then don't show anything (default = 1)
%
%   OUTPUT:
%       -
%

% root = 'E:\EXPERIMENTS\MAGNO\Experiment_SS_vel_250_body_fixed';
% vidvar = 'vidData';
% npts = 150;
% mask_mode = [1 1];
% loop_mask = true;
% playback = 20;

[FILES, PATH] = uigetfile({'*.mat', 'MAT-files'},'Select videos', root, 'MultiSelect','on');
FILES = string(FILES);
nfile = length(FILES);

abdomen_dir = fullfile(PATH,'tracked_abdomen_tip');
mkdir(abdomen_dir)
abdomen_mask = mask_mode;
for file = 1:nfile
    disp(FILES(file))
    disp('---------------------------------------')
    
    % Load data
    Data = load(fullfile(PATH,FILES(file)));
    t_v = Data.t_v;
    vid = Data.(vidvar);

    % Run tracker
    [abdomen_data, abdomen_mask] = track_abdomen(vid, abdomen_mask, npts, playback);
    
 	save(fullfile(abdomen_dir,FILES{file}),'-v7.3','abdomen_data', 'abdomen_mask', 't_v')
    
    if loop_mask
        % use last mask for next file
    else
        abdomen_mask = mask_mode; % make new mask for netx file
    end
                                                                       
end
disp('ALL DONE')
end
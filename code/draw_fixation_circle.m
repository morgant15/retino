function draw_fixation_circle(expWin, fixRect_small)
% Screen('FillOval', expWin, [0 0 0], fixRect);
% Screen('DrawLine', expWin, [255 255 255], fixRect(1), my, fixRect(3), my, 4);
% Screen('DrawLine', expWin, [255 255 255], mx, fixRect(2), mx, fixRect(4), 4);
Screen('FillOval', expWin, [255 0 0], fixRect_small);
end
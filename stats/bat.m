clear;

% define some colors
white = [255 255 255];
black = [0 0 0];
red = [255 0 0];
green = [0 255 0];
blue = [0 0 255];
orange = [255 165 0];
purple = [160 32 240];
gold = [255 223 0];

try
% open a window
scrNum = max(Screen('Screens'));
[win, scrRect] = Screen('OpenWindow',scrNum,black);  
[cx, cy] = RectCenter(scrRect);
[width, height] = RectSize(scrRect);
HideCursor; % hide the mouse
% change the text size
Screen('TextSize', win, 36);



picture = double(imread('bat.jpg'));
bats = Screen('MakeTexture',win,picture); %displaying each face for 1 second
angle=45;
bat_pos = [cx-400 height-200 cx+200 height-150];
for x=1:36
    angle=angle-5;
    Screen('DrawTexture',win,bats,[],bat_pos,angle);
    
    Screen('Flip',win);
    
end
sca;

catch
    sca;
end 
%Hit(.23), Walk(.01), Out(.75)
%Single(.664), Double(.196), Triple(.02), HR(.12)
clear; close all;
AssertOpenGL;
KbName('UnifyKeyNames');
rng('shuffle');
 
% define some colors
white = [255 255 255];
black = [0 0 0];
red = [255 0 0];
green = [0 255 0];
blue = [0 0 255];
orange = [255 165 0];
purple = [160 32 240];
gold = [255 223 0];

%load teams
contents = dir('*.mat');
mlb = {contents.name};

try
% open a window
scrNum = max(Screen('Screens'));
[win, scrRect] = Screen('OpenWindow',scrNum,black);  
[cx, cy] = RectCenter(scrRect);
[width, height] = RectSize(scrRect);
HideCursor; % hide the mouse
% change the text size
Screen('TextSize', win, 36);

%loading statistics

%setting up game
inning = [1;1];
awayHits = 0;
homeHits = 0;
awayHitter = 0;
homeHitter = 0;
walks = 0;
homeScore = 0;
awayScore = 0;
keepGoing = true;
noEscape = true;
DrawFormattedText(win,'Press any key to play ball','center',cy-300,white,24);
DrawFormattedText(win,'When you want to take an at bat, press any key','center','center',white,24);

%setting up bat image
picture = double(imread('bat.jpg'));
bats = Screen('MakeTexture',win,picture); %create bat

Screen('Flip',win);

[secs, keyCode, deltaSecs] = KbWait;
KbReleaseWait; 

%choosing away team
DrawFormattedText(win,'Select your desired away team by pressing the corresponding number(s)',...
    'center',cy-500,white,24);
DrawFormattedText(win,'1. Cubs',cx-cx,cy-300,white,24);
DrawFormattedText(win,'2. Nationals',cx-cx,cy-250,white,24);
DrawFormattedText(win,'3. Giants',cx-cx,cy-200,white,24);

number = GetEchoNumber(win, 'Away team is: ',cx,cy+200,white);
away = load(mlb{number});
fn = fieldnames(away);
away = away.(fn{1})
Screen('Flip',win);

%choosing home team
DrawFormattedText(win,'Select your desired home team by pressing the corresponding number(s)',...
    'center',cy-500,white,24);
DrawFormattedText(win,'1. Cubs',cx-cx,cy-300,white,24);
DrawFormattedText(win,'2. Nationals',cx-cx,cy-250,white,24);
DrawFormattedText(win,'3. Giants',cx-cx,cy-200,white,24);

number = GetEchoNumber(win, 'Home team is: ',cx,cy+200,white);
home = load(mlb{number});
fn = fieldnames(home);
home = home.(fn{1})
Screen('Flip',win);


while keepGoing && noEscape 
    %declaring variables
    outs = 0;
    firstBase=0;
    secondBase=0;
    thirdBase=0;
    
    if inning(2) == 1
        team = away;
    else
        team = home;
    end
    
    while outs < 3
        
        if inning(2) == 1
            awayHitter = awayHitter + 1;
            hitter = awayHitter;
        elseif inning(2) == 2
            homeHitter = homeHitter + 1;
            hitter = homeHitter;
        end
        
        
%/////////////////////////////////////////////////////////////////////////
        %drawouts 
        textOuts = num2str(outs);
        stringOuts = strcat('Outs:  ', textOuts);
        DrawFormattedText(win,stringOuts,cx+450,cy-320,white,24);
          
        %drawinnings
        textInnings = num2str(inning(1));
        if inning(2) == 1
            stringInnings = strcat('Top  ', textInnings);
        else
            stringInnings = strcat('Bot  ', textInnings);
        end                              
        DrawFormattedText(win,stringInnings,cx+320,cy-320,white,24);      
        %drawscore
        textAwayScore = num2str(awayScore);
        textHomeScore = num2str(homeScore);
        stringAwayScore = strcat('Away: ', textAwayScore);
        stringHomeScore = strcat('Home: ', textHomeScore);
        DrawFormattedText(win,stringAwayScore,cx+330,cy-200,white,24);
        DrawFormattedText(win,stringHomeScore,cx+330,cy-150,white,24);
        
        name = team(hitter).name{1};
        DrawFormattedText(win,'Now Batting:',cx-cx+20,cy+cy-100,white,24);
        DrawFormattedText(win,name,cx-cx+20,cy+cy-50,white,24);
        
        Screen('FillPoly',win,white,[cx-308 cy-209;cx-358 cy-159;cx-308 cy-109;cx-258 cy-159]); 
        Screen('FillPoly',win,white,[cx-383 cy-284;cx-433 cy-234;cx-383 cy-184;cx-333 cy-234]);
        Screen('FillPoly',win,white,[cx-458 cy-209;cx-508 cy-159;cx-458 cy-109;cx-408 cy-159]);
        if firstBase ~= 0
            Screen('FillPoly',win,gold,[cx-308 cy-209;cx-358 cy-159;cx-308 cy-109;cx-258 cy-159]);
        end
        if secondBase ~= 0
            Screen('FillPoly',win,gold,[cx-383 cy-284;cx-433 cy-234;cx-383 cy-184;cx-333 cy-234]);
        end
        if thirdBase ~= 0
            Screen('FillPoly',win,gold,[cx-458 cy-209;cx-508 cy-159;cx-458 cy-109;cx-408 cy-159]);
        end
        Screen('FillPoly',win,white,[cx-383 cy-134;cx-433 cy-84;cx-383 cy-34;cx-333 cy-84]);           
        Screen('Flip',win);     
        
        
%/////////////////////////////////////////////////////////////////////////        
        %initializing angle of bat
        angle=90;
        %waiting for keypress to initiate at bat
        [secs, keyCode, deltaSecs] = KbWait;
        KbReleaseWait;    
        
        % check key that was pressed with KbWait
        % if key was ESCAPE, then set keepGoing to false and exit out of
        % the current while loop (outs)
        if strcmpi(KbName(keyCode),'Escape')
            noEscape = false;
            break;
        end

        %generating random number to decide outcome of at bat
        abChance=rand(1);
        

%/////////////////////////////////////////////////////////////////////////
        if abChance < team(hitter).hits
            %generating random number to decided outcome of hit
            hitChance=rand(1);
            
            %set ball and bat position relative to center of screen
            ball_pos = [cx+100 cy-525 cx+200 cy-425];
            ballMoving = true;
            ball_speed = 16;
            angle_speed = 2;
            bat_pos = [cx-400 cy+300 cx+200 cy+340];
            
            
%/////////////////////////////////////////////////////////////////////////            
            while ballMoving
                Screen('FillOval',win,white,ball_pos);
                ball_pos([2,4]) = ball_pos([2,4]) + ball_speed;
                if ball_pos(4) < 0
                    ballMoving = false;
                end
                angle=angle-angle_speed;
                Screen('DrawTexture',win,bats,[],bat_pos,angle);

                if angle == 0
                    ball_speed = -16;
                    angle_speed = 0;
                end
                Screen('Flip',win);                
            end 
            
            
%/////////////////////////////////////////////////////////////////////////            
            %single
            if hitChance < team(hitter).singles
                %moving runners and updating score accordingly
                if thirdBase ~= 0 && inning(2) == 1
                    awayScore = awayScore + 1;
                elseif thirdBase ~= 0 && inning(2) ==2
                    homeScore = homeScore + 1;
                end
                thirdBase = secondBase;
                secondBase = firstBase;
                firstBase = 1;
                DrawFormattedText(win,'Single!','center','center',white,24);
                
            %double    
            elseif hitChance >= team(hitter).singles && hitChance < team(hitter).doubles
                %moving runners and updating score accordingly
                if thirdBase ~= 0 && inning(2) == 1
                    awayScore = awayScore + 1;
                elseif thirdBase ~= 0 && inning(2) ==2
                    homeScore = homeScore + 1;
                end
                if secondBase ~= 0 && inning(2) == 1
                    awayScore = awayScore + 1;
                elseif secondBase ~= 0 && inning(2) ==2
                    homeScore = homeScore + 1;
                end   
                thirdBase = firstBase;
                secondBase = 1;
                firstBase = 0;
                DrawFormattedText(win,'Double!','center','center',white,24);

            %triple
            elseif hitChance >= team(hitter).doubles && hitChance < team(hitter).triples
                %moving runners and updating score accordingly
                if thirdBase ~= 0 && inning(2) == 1
                    awayScore = awayScore + 1;
                elseif thirdBase ~= 0 && inning(2) ==2
                    homeScore = homeScore + 1;
                end
                if secondBase ~= 0 && inning(2) == 1
                    awayScore = awayScore + 1;
                elseif secondBase ~= 0 && inning(2) ==2
                    homeScore = homeScore + 1; 
                end
                if firstBase ~= 0 && inning(2) == 1
                    awayScore = awayScore + 1;
                elseif firstBase ~= 0 && inning(2) ==2
                    homeScore = homeScore + 1;  
                end
                thirdBase = 1;
                secondBase = 0;
                firstBase = 0;
                DrawFormattedText(win,'Triple!','center','center',white,24);
                
            %homer    
            else
                %moving runners and updating score accordingly
                if thirdBase ~= 0 && inning(2) == 1
                    awayScore = awayScore + 1;
                elseif thirdBase ~= 0 && inning(2) ==2
                    homeScore = homeScore + 1;
                end
                if secondBase ~= 0 && inning(2) == 1
                    awayScore = awayScore + 1;
                elseif secondBase ~= 0 && inning(2) ==2
                    homeScore = homeScore + 1; 
                end
                if firstBase ~= 0 && inning(2) == 1
                    awayScore = awayScore + 1;
                elseif firstBase ~= 0 && inning(2) == 2
                    homeScore = homeScore + 1; 
                end
                if inning(2) == 1
                    awayScore = awayScore + 1;
                elseif inning(2) == 2
                    homeScore = homeScore + 1;
                end               
                thirdBase = 0;
                secondBase = 0;
                firstBase = 0;
                DrawFormattedText(win,'Home Run!','center','center',white,24);
            end
            if inning(2) == 1 
                awayHits = awayHits + 1;
            else
                homeHits = homeHits + 1;
            end

            
%/////////////////////////////////////////////////////////////////////////
        %walk    
        elseif abChance >= team(hitter).hits && abChance < team(hitter).walks
            %moving runners and updating score accordingly
            if thirdBase ~= 0 && inning(2) == 1
                awayScore = awayScore + 1;
            elseif thirdBase ~= 0 && inning(2) == 2
                homeScore = homeScore + 1;
            end
            ball_pos = [cx+150 cy-525 cx+250 cy-425];
            ball_speed = 16;
            ballMoving = true;
            while ballMoving
                Screen('FillOval',win,white,ball_pos);
                ball_pos([2,4]) = ball_pos([2,4]) + ball_speed;
                if ball_pos(2) > height
                    ballMoving = false;
                end
                Screen('Flip',win);                
            end
            thirdBase = secondBase;
            secondBase = firstBase;
            firstBase = 1;         
            DrawFormattedText(win,'Walk.','center','center',white,24);
         
            
%/////////////////////////////////////////////////////////////////////////            
        %out    
        else
            %update number of outs
            outs=outs+1;
            ball_speed = 16;
            ballMoving = true;
            bat_pos = [cx-400 cy+300 cx+200 cy+340];
            ball_pos = [cx+300 cy-525 cx+400 cy-425];
            ballMoving = true;
            while ballMoving
                Screen('FillOval',win,white,ball_pos);
                ball_pos([2,4]) = ball_pos([2,4]) + ball_speed;
                if ball_pos(2) > height
                    ballMoving = false;
                end
                angle=angle-2;
                Screen('DrawTexture',win,bats,[],bat_pos,angle);
                Screen('Flip',win);
            end
            DrawFormattedText(win,'Out!','center','center',white,24);            
        end
    end

    
%/////////////////////////////////////////////////////////////////////////    
    %end game if home team is winning after top 9
	if inning(1) == 9 && inning(2) == 1 && homeScore > awayScore
        keepGoing = false;
        DrawFormattedText(win,'Home Team Wins!','center','center',white,24);
        Screen('Flip',win);
        WaitSecs(1);        
    
    %end game if not tied after 9    
    elseif inning(1) == 9 && inning(2) == 2 && homeScore ~= awayScore
        keepGoing = false;
        if homeScore > awayScore
            DrawFormattedText(win,'Home Team Wins!','center','center',white,24);
            Screen('Flip',win);
            WaitSecs(1);            
        else
            DrawFormattedText(win,'Away Team Wins!','center','center',white,24);
            Screen('Flip',win);
            WaitSecs(1);            
        end
        
    %end game if not tied after 10+    
    elseif inning(1) > 9 && inning(2) == 2 && homeScore ~= awayScore
        keepGoing = false;
        if homeScore > awayScore
            DrawFormattedText(win,'Home Team Wins!','center','center',white,24);
            Screen('Flip',win);
            WaitSecs(1);
        else
            DrawFormattedText(win,'Away Team Wins!','center','center',white,24);
            Screen('Flip',win);
            WaitSecs(1);            
        end
    
    %if game is tied or before top 9, keep going    
    else
        if inning(2) == 1
            inning(2) = 2;
        elseif inning(2) == 2
            inning(1) = inning(1) + 1;
            inning(2) = 1;
        end
        keepGoing = true;
    end
end	
     
sca;

catch
    sca;
end 
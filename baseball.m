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

%loading all team faces and statistics from mat files
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

%setting up game, initializing variables
inning = [1;1];
awayHits = 0;
homeHits = 0;
awayHitter = 0;
homeHitter = 0;
homeScore = 0;
awayScore = 0;
keepGoing = true;
noEscape = true;

%beginning instructions
DrawFormattedText(win,'Press any key to play ball','center',cy-300,white,24);
DrawFormattedText(win,'When you want to take an at bat, press any key','center','center',white,24);

%setting up bat image
picture = double(imread('bat.png'));
bats = Screen('MakeTexture',win,picture); %displaying each face for 1 second

Screen('Flip',win);

[secs, keyCode, deltaSecs] = KbWait;
KbReleaseWait; 

%choosing away team
DrawFormattedText(win,'Select your desired away team by pressing the corresponding number(s)',...
    'center',cy-cy,white,24);
DrawFormattedText(win,'1. Braves',cx-cx,cy-cy+250,white,24);
DrawFormattedText(win,'2. Brewers',cx-cx,cy-cy+300,white,24);
DrawFormattedText(win,'3. Cardinals',cx-cx,cy-cy+350,white,24);
DrawFormattedText(win,'4. Cubs',cx-cx,cy-cy+400,white,24);
DrawFormattedText(win,'5. Dodgers',cx-cx,cy-cy+450,white,24);
DrawFormattedText(win,'6. Giants',cx-cx,cy-cy+500,white,24);
DrawFormattedText(win,'7. Legends',cx-cx,cy-cy+550,white,24);
DrawFormattedText(win,'8. Mets',cx-cx,cy-cy+600,white,24);
DrawFormattedText(win,'9. Nationals',cx-cx,cy-cy+650,white,24);
DrawFormattedText(win,'10. Pirates',cx-cx,cy-cy+700,white,24);
DrawFormattedText(win,'11. Reds',cx-cx,cy-cy+750,white,24);


number = GetEchoNumber(win, 'Away team is: ',cx,cy+200,white);
away = load(mlb{number});
fn = fieldnames(away);
away = away.(fn{1});
awayName = upper(fn{1});
Screen('Flip',win);

%choosing home team
DrawFormattedText(win,'Select your desired home team by pressing the corresponding number(s)',...
    'center',cy-cy,white,24);
DrawFormattedText(win,'1. Braves',cx-cx,cy-cy+250,white,24);
DrawFormattedText(win,'2. Brewers',cx-cx,cy-cy+300,white,24);
DrawFormattedText(win,'3. Cardinals',cx-cx,cy-cy+350,white,24);
DrawFormattedText(win,'4. Cubs',cx-cx,cy-cy+400,white,24);
DrawFormattedText(win,'5. Dodgers',cx-cx,cy-cy+450,white,24);
DrawFormattedText(win,'6. Giants',cx-cx,cy-cy+500,white,24);
DrawFormattedText(win,'7. Legends',cx-cx,cy-cy+550,white,24);
DrawFormattedText(win,'8. Mets',cx-cx,cy-cy+600,white,24);
DrawFormattedText(win,'9. Nationals',cx-cx,cy-cy+650,white,24);
DrawFormattedText(win,'10. Pirates',cx-cx,cy-cy+700,white,24);
DrawFormattedText(win,'11. Reds',cx-cx,cy-cy+750,white,24);

number = GetEchoNumber(win, 'Home team is: ',cx,cy+200,white);
home = load(mlb{number});
fn = fieldnames(home);
home = home.(fn{1});
homeName = upper(fn{1});
Screen('Flip',win);

%initialing in game statistics
atBats = zeros(2,9);
hits = zeros(2,9);

%initializing face positions
pitcher_face_pos = [cx-cx cy-cy cx-cx+175 cy-cy+127];
batter_face_pos = [cx-cx cy+cy-127 cx-cx+175 cy+cy];


while keepGoing && noEscape 
    %declaring variables
    outs = 0;
    firstBase=0;
    secondBase=0;
    thirdBase=0;
    
    %specifying what team is pitching and batting based on inning
    if inning(2) == 1
        team = away;
        pitcher = home;
    else
        team = home;
        pitcher = away;
    end
    
    while outs < 3
        
        %specifying which batter is hitting based on inning
        if inning(2) == 1
            awayHitter = awayHitter + 1;
            if awayHitter == 10
                awayHitter = 1;
            end
            hitter = awayHitter;
        elseif inning(2) == 2
            homeHitter = homeHitter + 1;
            if homeHitter == 10
                homeHitter = 1;
            end            
            hitter = homeHitter;
        end        
        
        
%/////////////////////////////////////////////////////////////////////////
        %draw outs 
        textOuts = num2str(outs);
        stringOuts = strcat('Outs:  ', textOuts);
        DrawFormattedText(win,stringOuts,cx+430,cy-320,white,24);
          
        %draw innings
        textInnings = num2str(inning(1));
        if inning(2) == 1
            stringInnings = strcat('Top  ', textInnings);
        else
            stringInnings = strcat('Bot  ', textInnings);
        end                              
        DrawFormattedText(win,stringInnings,cx+300,cy-320,white,24); 
        
        %draws core
        textAwayScore = num2str(awayScore);
        textHomeScore = num2str(homeScore);
        stringAwayScore = strcat(awayName,':', textAwayScore);
        stringHomeScore = strcat(homeName,':', textHomeScore);
        DrawFormattedText(win,stringAwayScore,cx+300,cy-200,white,24);
        DrawFormattedText(win,stringHomeScore,cx+300,cy-150,white,24);
        
        %drawing hitter and pitcher info
        name = team(hitter).name{1};
        
        pitcherName = pitcher(9).name{1};
        DrawFormattedText(win,'Pitching:',cx-cx+200,cy-cy,white,24);
        DrawFormattedText(win,pitcherName,cx-cx+200,cy-cy+50,white,24);
        face = Screen('MakeTexture',win,pitcher(9).faces{1});
        
        %changing dimensions of player pictures if 'Legends' team
        if strcmpi('Walter Johnson',pitcherName)
            pitcher_face_pos = [cx-cx cy-cy cx-cx+106 cy-cy+160];
        else
            pitcher_face_pos = [cx-cx cy-cy cx-cx+175 cy-cy+127];          
        end
        if strcmpi('Jackie Robinson',team(1).name{1})
            batter_face_pos = [cx-cx cy+cy-160 cx-cx+106 cy+cy];
        else
            batter_face_pos = [cx-cx cy+cy-127 cx-cx+175 cy+cy];  
        end     
        Screen('DrawTexture',win,face,[],pitcher_face_pos);
        
        DrawFormattedText(win,'Now Batting:',cx-cx+200,cy+cy-150,white,24);
        DrawFormattedText(win,name,cx-cx+200,cy+cy-100,white,24);
        face = Screen('MakeTexture',win,team(hitter).faces{1});
        Screen('DrawTexture',win,face,[],batter_face_pos);
        
        if inning(2) == 1
            currAB = num2str(atBats(1,hitter));
            currHits = num2str(hits(1,hitter));
        else
            currAB = num2str(atBats(2,hitter));
            currHits = num2str(hits(2,hitter));
        end
        
        hitterInfo = strcat(currHits,'-',currAB);
        DrawFormattedText(win,hitterInfo,cx-cx+200,cy+cy-50,white,24);
        
        %drawing base graphics
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
            
            if inning(2) == 1
                hits(1,hitter) = hits(1,hitter) + 1;
                atBats(1,hitter) = atBats(1,hitter) + 1;
            else
                hits(2,hitter) = hits(2,hitter) + 1;
                atBats(2,hitter) = atBats(2,hitter) + 1;
            end
            
            %set ball and bat position relative to center of screen
            ball_pos = [cx+100 cy-cy cx+200 cy-cy+100];
            ballMoving = true;
            ball_speed = 11;
            angle_speed = 2;
            curve_speed = -16;
            curve_variable = .75;
            pitchType = rand(1);            
            bat_pos = [cx-400 cy-cy+584 cx+200 cy-cy+624];            
            
%/////////////////////////////////////////////////////////////////////////            
            while ballMoving
                %drawing pitch and bat movement
                Screen('FillOval',win,white,ball_pos);
                
                %randomly selecting type of pitch (curveball, fastball)
                if pitchType < .75                
                    ball_pos([2,4]) = ball_pos([2,4]) + ball_speed;
                    if ball_pos(4) < 0
                        ballMoving = false;
                    end
                else
                    ball_pos([2,4]) = ball_pos([2,4]) + ball_speed;
                    ball_pos([1,3]) = ball_pos([1,3]) + curve_speed;
                    curve_speed = curve_speed + curve_variable;
                    if ball_pos(4) < 0
                        ballMoving = false;
                    end
                end
                angle=angle-angle_speed;
                Screen('DrawTexture',win,bats,[],bat_pos,angle);

                if angle == 0
                    ball_speed = -16;
                    curve_speed = 0;
                    curve_variable = 0;
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
                if firstBase ~= 0 && secondBase ~= 0 && thirdBase ~= 0
                    DrawFormattedText(win,'Grand Slam!','center','center',white,24);
                else
                    DrawFormattedText(win,'Home Run!','center','center',white,24);
                end
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
            if thirdBase ~= 0 && secondBase ~= 0 && firstBase ~= 0 && inning(2) == 1
                awayScore = awayScore + 1;
            elseif thirdBase ~= 0 && secondBase ~= 0 && firstBase ~= 0 && inning(2) == 2
                homeScore = homeScore + 1;
            end
            
            %set ball and bat position relative to center of screen
            ball_pos = [cx+150 cy-cy cx+250 cy-cy+100];
            ball_speed = 16;
            curve_speed = -16;
            curve_variable = .75;
            pitchType = rand(1);           
            ballMoving = true;
            while ballMoving
                %drawing pitch and bat movement
                Screen('FillOval',win,white,ball_pos);
                
                %randomly selecting type of pitch (curveball, fastball)
                if pitchType < .50
                    ball_pos([2,4]) = ball_pos([2,4]) + ball_speed;
                    if ball_pos(2) > height
                        ballMoving = false;
                    end
                else
                    ball_pos([2,4]) = ball_pos([2,4]) + ball_speed;
                    ball_pos([1,3]) = ball_pos([1,3]) + curve_speed;
                    curve_speed = curve_speed + curve_variable;                    
                    if ball_pos(2) > height
                        ballMoving = false;
                    end
                end  
                Screen('Flip',win);                
            end
            
            if firstBase ~= 0 && secondBase ~= 0 
                thirdBase = secondBase;
                secondBase = firstBase;
                firstBase = 1;
            elseif firstBase ~= 0
                secondBase = firstBase;
                firstBase = 1;
            else
                firstBase = 1;
            end      
            
            DrawFormattedText(win,'Walk.','center','center',white,24);
         
            
%/////////////////////////////////////////////////////////////////////////            
        %out    
        else
            %update number of outs
            outs=outs+1;
            
            if inning(2) == 1
                atBats(1,hitter) = atBats(1,hitter) + 1;
            else
                atBats(2,hitter) = atBats(2,hitter) + 1;
            end  
            
            %set ball and bat position relative to center of screen
            ball_speed = 16;
            curve_speed = -16;
            curve_variable = .75;
            pitchType = rand(1);            
            ballMoving = true;
            bat_pos = [cx-400 cy-cy+584 cx+200 cy-cy+624];
            ball_pos = [cx+400 cy-cy cx+500 cy-cy+100];
            while ballMoving
                %drawing pitch and bat movement
                Screen('FillOval',win,white,ball_pos);
                
                %randomly selecting type of pitch (curveball, fastball, knuckleball)
                if pitchType < .25
                    ball_pos([2,4]) = ball_pos([2,4]) + ball_speed;
                    if ball_pos(2) > height
                        ballMoving = false;
                    end
                elseif pitchType <= .75 && pitchType > .25
                    ball_pos([2,4]) = ball_pos([2,4]) + ball_speed;
                    ball_pos([1,3]) = ball_pos([1,3]) + curve_speed;
                    curve_speed = curve_speed + curve_variable;                    
                    if ball_pos(2) > height
                        ballMoving = false;
                    end                    
                else
                    curve_speed = randi([-10 10]);
                    ball_pos([2,4]) = ball_pos([2,4]) + ball_speed;
                    ball_pos([1,3]) = ball_pos([1,3]) + curve_speed;
                    %curve_speed = curve_speed + curve_variable;                    
                    if ball_pos(2) > height
                        ballMoving = false;
                    end
                end
                angle=angle-2;
                Screen('DrawTexture',win,bats,[],bat_pos,angle);
                Screen('Flip',win);
            end
            
            DrawFormattedText(win,'Out.','center','center',white,24);
        end
    end

    
%/////////////////////////////////////////////////////////////////////////    
    %end game if home team is winning after top 9
    
    %game end message
    homeWin = strcat(homeName,' WIN!');
    awayWin = strcat(awayName,' WIN!');
    
	if inning(1) == 9 && inning(2) == 1 && homeScore > awayScore
        keepGoing = false;
        Screen('Flip',win);
        DrawFormattedText(win,homeWin,'center','center',white,24);
        Screen('Flip',win);
        WaitSecs(1);        
    
    %end game if not tied after 9 innings   
    elseif inning(1) == 9 && inning(2) == 2 && homeScore ~= awayScore
        keepGoing = false;
        if homeScore > awayScore
            Screen('Flip',win);
            DrawFormattedText(win,homeWin,'center','center',white,24);
            Screen('Flip',win);
            WaitSecs(1);            
        else
            Screen('Flip',win);
            DrawFormattedText(win,awayWin,'center','center',white,24);
            Screen('Flip',win);
            WaitSecs(1);            
        end
        
    %end game if not tied after 10+ innings    
    elseif inning(1) > 9 && inning(2) == 2 && homeScore ~= awayScore
        keepGoing = false;
        if homeScore > awayScore
            Screen('Flip',win);
            DrawFormattedText(win,homeWin,'center','center',white,24);
            Screen('Flip',win);
            WaitSecs(1);
        else
            Screen('Flip',win);
            DrawFormattedText(win,awayWin,'center','center',white,24);
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
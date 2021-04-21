% File:             DL_N400_Exp2_V1_Triggado_EEG1.m
% File type:        function
% Created on:       May 20, 2017
% Created by:       Carlos F. Ramos
% Last revised on:  May 20, 2017
% Last revised by:  Carlos
%
% Purpose:          Lexical Decision Task. Manipulation: relatedness of
%                   prime and target verbs
%                   
%
% Input:            Via prompt (participant #, session #, Threshold value
%                   and # of trials)
%
% Output:           A file with time-event codes
%
% Coments:          
%                   Matriz de dados - estimulos;
%                     1 - # estímulo
%                     2 - Palavra - Prime
%                     3 - Palavra - Alvo
%                     4 - Resposta correta Linux (19 = tecla 9; 11 = tecla 1)
%                     5 - Trigger (11=sinï¿½nimos; 12=n-sinï¿½nimos; 13=pseudopalavra)
%                     X 6 - Trigger_time (21=sinï¿½nimos; 22=n-sinï¿½nimos; 23=pseudopalavra)
%                     

% Trigger code
% 12 = (200,0,0) - Sinonimo
% 14 = (232,0,0) - Nao Sinonimo
% 16 = (0,24,0) - Pseudopalavra
% 22 = (104,24,0) - Sinonimo (Tempo)
% 24 = (136,24,0) - Nao Sinonimo (Tempo)
% 26 = (168,24,0) - Pseudopalavra (Tempo)
% 
%  
%
% Format:           N/A
% Example:          N/A

function DL_N400_Exp2_V2_Triggado_EEG1

% Create global variables for function-function to have access and modify
global FID w Session_start_time  
% cd 'H:\MATLAB_task\Triggado' %Alterar para computador
cd '/home/psicofisica-2/Documentos/Carlos'

% addpath C:\toolbox

% Set the randomization state to a random number
rand('state', sum(100*clock));
Screen('Preference', 'SkipSyncTests', 1);
    
Experiment = 'DL2'; 
SubId = input('Subject Id (ex.: 01,02 ...)\n','s');
Session = input('Participant Name \n','s');
Coef_Threshold = input(['Threshold Coeficient \n'...
    '(1=8.3, 2=16.7, 3=25.0, 4=33.3, 5=41.7, 6=49.9, 7=58,4) \n']);
nTrials = input('How many trials? \n','s');

Ntrials = str2double(nTrials); % convert string to number for subsequent reference

KbName('UnifyKeyNames');
Key1=KbName('1!'); Key2=KbName('9(');
spaceKey = KbName('space'); escKey = KbName('ESCAPE');

CorrKey = [11, 19]; %For Linux - keys 1! and 9( [11, 19]
% CorrKey = [49, 57]; % For Windows - keys 1! and 9(  

% Trigger code
% [200 0 0];% 12 - Congruente
% [232 0 0];% 14- Incongruente
% [0 24 0];% 16- Pseudopalavra
% [104 24 0];% 22 - Congruente (Tempo)
% [136 24 0];% 24 - Incongruente(Tempo)
% [168 24 0];% 26 - Pseudopalavra (Tempo)

% load('H:\MATLAB_task\Triggado\Verbos_final.mat');
load('/home/psicofisica-2/Documentos/Carlos/Verbos_final.mat');
    
CorrKeyList = cell2mat(Verbos_final(:,4)); %#ok<*NODEF>
Trigger = cell2mat(Verbos_final(:,5));
Trigger_thresh2 = cell2mat(Verbos_final(:,6));


% If enter was hit, then run the experiment, if not, cancel
if ~isempty(SubId)
    % try the code, and stop and close screen if there are errors
    try
        % Unify key names for windows to recognize
        KbName('UnifyKeyNames');
        
        % Open the experimental screen      
        [w,rect]=Screen('OpenWindow',0);

        % Consultar a duracao do frame da tela (Inter-Flip Interval)
        Ifi = Screen('GetFlipInterval', w);

        % Hide the mouse
        HideCursor;
        
        % ---------------------------------------------------------------------
        % Create the a structure that contains information about the experiment we will run
        % ---------------------------------------------------------------------
        % 1.) The fields below provide information about the sessions to be run
        Procedure.name = char(Experiment);
        Procedure.participant.id = char(SubId);
        Procedure.session = char(Session);
        Procedure.filename = [Procedure(1).name '_' Procedure(1).participant.id '_' Procedure(1).session];
        Procedure.trials = Ntrials;
        
        % Defines all 3 colors. 
        Gray = [127 127 127 ];
        White = [204 204 204]; %light gray
%         White = [255 255 255]; 
        Black = [0 0 0]; 
        
        Procedure.screen = get(0,'screensize');
        center_x = Procedure.screen(3)/2;
        center_y = Procedure.screen(4)/2;
            
                         
        % Open the file to record the data
        FID = fopen(Procedure.filename, 'a');
                                                
        Session_start_time = GetSecs;
        fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 700]);
        
  %%     
        %%% INTRODUCE INSTRUCTIONS:
        
        % After instruction a keyboard press will start the for loop
        
        % Create the instructions screens
       
    %Instructions part 2
        % Draw the lines on the screen     
            Screen('TextSize', w, 24);
            Screen('TextFont', w, 'Arial');
            Instructions1 = ['Esse e um experimento de Decisao Lexical \n'...
                        '\n'...
                        'Durante o experimento, voce vera \n'...
                        '\n'...
                        'uma cruz, seguida de uma linha de \n'...
                        '\n'...
                        'caracteres (XXXXXX) e, por fim, uma \n'...
                        '\n'...
                        'palavra aparecera rapidamente na tela. \n'...
                        '\n'...
                        '\n'...
                        'Voce deve decidir se a palavra apresentada \n'...
                        '\n'...
                        'no fim  realmente existe (ex.: COMPRAR) ou se \n'...
                        '\n'...
                        'e uma pseudopalavra, nao existente na \n'...
                        '\n'...
                        'lingua Portuguesa, como por exemplo "BEVIPAR". \n'...
                        '\n'...
                        '\n'...
                        '\n'...
                        'Pressione a tecla DIREITA para continuar. \n'...
                        '\n'];
            Screen('FillRect', w, [0, 0, 0]);
            [~, ~, bbox] = DrawFormattedText(w, Instructions1, center_x,center_y, Gray);
            Screen('FrameRect', w, 0, bbox);
            Screen('Flip', w);
            
            Stimulus_start = GetSecs-Session_start_time;
            fprintf(FID, '%12.4f\t %3.0f\n',[Stimulus_start 731]);


        % ---------- Wait for a specific key press to continue ----------------
    
        % Wait for no keys pressed, then
        Rkey = Key2;
        keyisdown = 1;
        while(keyisdown)
            [keyisdown,t,keycode] = KbCheck;
            WaitSecs(0.0001);
        end
        
              
        while(~keycode(Key2))
            [keyisdown,t,keycode] = KbCheck;
            WaitSecs(0.0001);
        end
        Screen('Flip',w);      
       
    %Instructions part 2 
            Screen('TextSize', w, 24);
            Screen('TextFont', w, 'Arial');
            Instructions2 = ['Para responder, utilize as duas \n'...
                        '\n'...
                        'teclas das extremidades, sendo: \n'...
                        '\n'...
                        '\n'...
                        'ESQUERDA = Nao e uma palavra \n'...
                        '\n'...
                        'DIREITA = Sim, e uma palavra \n'...
                        '\n'...
                        '\n'...
                        'Tente responder O MAIS RAPIDO QUE CONSEGUIR, \n'...
                        '\n'...
                        'logo que a palavra aparecer. \n'...
                        '\n'...
                        '\n'...
                        '\n'...
                        'Antes, faremos uma pequena sessao de teste.\n'...
                        '\n'...
                        '\n'...
                        'Pressione a tecla DIREITA para continuar. \n'...
                        '\n'];
            Screen('FillRect', w, [0, 0, 0]);
            [~, ~, bbox] = DrawFormattedText(w, Instructions2, center_x,center_y, Gray);
            Screen('FrameRect', w, 0, bbox);
            Screen('Flip', w);
            
            Stimulus_start = GetSecs-Session_start_time;
            fprintf(FID, '%12.4f\t %3.0f\n',[Stimulus_start 732]);

        % ---------- Wait for a specific key press to continue ----------------
    
        % Wait for no keys pressed, then
%         rkey = KbName('return');
        keyisdown = 1;
        while(keyisdown)
            [keyisdown,t,keycode] = KbCheck;
            WaitSecs(0.0001);
        end
        
         while(~keycode(Key2))
            [keyisdown,t,keycode] = KbCheck;
            WaitSecs(0.0001);
         end
        
       Screen('Flip',w);
   
       
       Practice_Trials
       
       
    %Instructions part 3
        % Draw the lines on the screen     
            Screen('TextSize', w, 24);
            Screen('TextFont', w, 'Arial');
            Instructions3 = ['Durante o experimento, havera intervalos, para \n'...
                        '\n'...
                        'que voce possa descansar. Nesses intervalos, voce \n'...
                        '\n'...
                        'pode ficar o tempo que achar necessario antes de \n'...
                        '\n'...
                        'continuar com o experimento. \n'...
                        '\n'...
                        '\n'...
                        '\n'...
                        '\n'...
                        'Alguma duvida?\n'...
                        '\n'...
                        '\n'...
                        '\n'...
                        'Quando estiver pronto, \n'...
                        '\n'...
                        'Pressione a tecla DIREITA para iniciar. \n'...
                        '\n'];
            Screen('FillRect', w, [0, 0, 0]);
            [~, ~, bbox] = DrawFormattedText(w, Instructions3, center_x,center_y, Gray);
            Screen('FrameRect', w, 0, bbox);
            Screen('Flip', w);
            
            Stimulus_start = GetSecs-Session_start_time;
            fprintf(FID, '%12.4f\t %3.0f\n',[Stimulus_start 733]);

        % ---------- Wait for a specific key press to continue ----------------
    
        % Wait for no keys pressed, then
%         rkey = KbName('return');
        keyisdown = 1;
        while(keyisdown)
            [keyisdown,t,keycode] = KbCheck;
            WaitSecs(0.0001);
        end
        
        
        while(~keycode(Key2))
            [keyisdown,t,keycode] = KbCheck;
            WaitSecs(0.0001);
        end
        Screen('Flip',w);
        % ---------------------------------------------------------------------
        %%
        %%%%%% CREATE LOOP FOR PROCEDURE %%%%%%%%%%%%%%%%%%%%%%%
        Procedure.screen = get(0,'screensize');
        center_x = Procedure.screen(3)/2;
        center_y = Procedure.screen(4)/2;
        
        Actual_threshold = Ifi*Coef_Threshold; %* 0.75 % 75% of Measured Threshold 
            
            WaitSecs(1);

        % Wait for no keys pressed to start measuring responses
            keyisdown = 1;
            while(keyisdown)
                [keyisdown,t,keycode] = KbCheck;
                WaitSecs(0.0001);
            end
            
            Stimulus_start = GetSecs-Session_start_time;
            fprintf(FID, '%12.4f\t %3.0f\n',[Stimulus_start 710]); %block start
            fprintf(FID, '%12.4f\t %3.0f\n',[Stimulus_start 741]); %block  #1
            

            %%%% Define verbs list
            Ix = sort(randperm (600)); % Generate list of verbs (all)
%          
            Verbs_normal = Shuffle(Ix)'; %transpose and shuffle verbs indexes
%             

            Block = 1;

            for iii = 001:Procedure.trials %Loop apresentacao das palavras
                  
                Est = Screen('Flip', w);
                
               % Get time for trial start and trial number
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 711]); %start trial
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time iii+800]); %get trial number
                    
               
                %Get word/nonword-pair used
%                     Counter_verb_normal = Counter_verb_normal + 1; 
                    Verb = Verbos_final(Verbs_normal(iii),2:3);
%                     Time_brake = false; 
                    Verb_index = cell2mat(Verbos_final(Verbs_normal(iii),1));
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 722]); %SOA is long
%                 end
                    
                
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time Verb_index+100]);
        
                %Fixation Point
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text = '+';
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
                    Size=Screen('TextSize',w, 30);
                    % Get the width of the text
                    width = RectWidth(Screen('TextBounds', w, text));
                    % Draw the text on the background screen
                    Screen('Drawtext',w,text,center_x-width/2,center_y, Gray, Size);
                    % Show the screen
                    Est1 = Screen('Flip',w);
                    % Get time for fixation appearance
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 701]);
                    
                    

                %apresentacao do PRIME por (limiar) segundos 
                    Verb_column = 1; %Column for Prime Verb
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text = char(Verb(Verb_column));
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
%                     Size=Screen('TextSize',w, 24);
                    % Get the width of the text
                    width = RectWidth(Screen('TextBounds', w, text));                 
                    % Draw the text on the background screen
                    Screen('Drawtext',w,text,center_x-width/2,center_y, Gray, Size);
                    % Show the screen
                    Est2 = Screen('Flip',w, Est1 + 2.5 - Ifi); %Define time of fixation point until Prime is shown (2.5s).
                    % Get time for prime appearance
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 702]);
%                    
                      

                    %texto ï¿½ a mascara
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text = 'XXXXXXXX';
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
%                     Size=Screen('TextSize',w, 24);
                    % Get the width of the text
                    width = RectWidth(Screen('TextBounds', w, text));
                    % Draw the text on the background screen
                    Screen('Drawtext',w,text,center_x-width/2,center_y, Gray, Size); 
                    % Show the screen
                    
                    if Block == 1 || Block == 3 || Block == 5 %threshold will be the measured value
                        
                        Est3 = Screen('Flip',w, Est2 + Actual_threshold - Ifi); %Define time of Prime until Mask is shown (Threshold).
                        % Get time for mask appearance
                        fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 703]);
                        fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 723]);
                        Thresh_change = false;
                        
                    else %%threshold will be higher than the measured value
                        Est3 = Screen('Flip',w, Est2 + (Actual_threshold+2*Ifi) - Ifi); %Define time of Prime until Mask is shown (Threshold).
                        % Get time for mask appearance
                        fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 703]);
                        fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 724]);
                        Thresh_change = true; 
                    
                    end

                % palavra ALVO
                    Verb_column = 2; %Column for Target Verb
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text =  char(Verb(Verb_column));
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
%                     Size=Screen('TextSize',w, 25);
                    % Get the width of the text
                    width = RectWidth(Screen('TextBounds', w, text));
                   % Draw the text on the background screen
                    Screen('Drawtext',w,text,center_x-width/2,center_y, Gray, Size);
                    
                    %Prepare Trigger to be sent when Screen Flip.
                    %
                    if Thresh_change
                        Trigger_code = Trigger_thresh2(Verb_index,:);
                    else
                        Trigger_code = Trigger(Verb_index,:);
                    end                    %                     end
                    Screen('FillRect',w , [Trigger_code] ,[0 0 1 1]); %#ok<NBRAK>
%                   Screen('FillRect',windowPtr [,color] [,rect] )

                    % Show the screen
                        Est4 = Screen('Flip',w, Est3 + (0.150-Actual_threshold) - Ifi);%600 ms
                        % Get time for target appearance
                        fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 704]);
%                     
                                    
                % Dot screen at trial end (for response)
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text = '.';
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
%                     Size=Screen('TextSize',w, 25);
                    % Get the width of the text
                    width = RectWidth(Screen('TextBounds', w, text));
                    % Draw the text on the background screen
                    Screen('Drawtext',w,text,center_x-width/2,center_y, Gray, Size);
                    % Show the screen
                    Est5 = Screen('Flip',w, Est4 + 0.25 - Ifi); %Define time of fixation point until Dot is shown (200ms).
                    % Get time for dot appearance
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 705]);
                    pause (.1);
            
                    
                % Get key press and accuracy
                    keyIsDown=0; ACC=0; RT=0; 
                    while 1
                            [keyIsDown, secs, keyCode] = KbCheck;
                            FlushEvents('keyDown');
                            if keyIsDown
                                nKeys = sum(keyCode);
                                if nKeys==1
                                    if keyCode(Key1)||keyCode(Key2)
                                        %Record the push of the button 
                                        fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 709]); %709 = response button pressed
%                                       RT = 1000.*(GetSecs-timeStart);
                                        keypressed=find(keyCode);
                                        Screen('Flip', w);
                                        break;
                                    elseif keyCode(escKey)
                                        ShowCursor; fclose('all');  Screen('CloseAll'); return
                                    end
                                    keyIsDown=0; keyCode=0;
                                end
                            end
                     end
                     if (keypressed==CorrKeyList(Verb_index))
                            ACC=911; %correto
                        else
                            ACC=910; %incorreto
                     end

                    
            %Record accuracy
            fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time ACC]);  %910/911
            %Record the end of trial 
            fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 719]); 
            


            %%
            %%%Loops for blocks
            % Check to continue or terminate the experiment
            if iii <= Procedure.trials
            
                %##########################################################
                 
                 
            % Insert pause #1 in trial 20
                if iii == 1*Procedure.trials/6
                    
                    %Record the rest brake
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 791]);
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text = 'Intervalo 1. Pressione a tecla DIREITA para continuar.';
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
%                     Size=Screen('TextSize',w, 25);
                    % Get the width of the text
                    width = RectWidth(Screen('TextBounds', w, text));
                    % Draw the text on the background screen
                    Screen('Drawtext',w,text,center_x-width/2,center_y, Gray, Size);
                    % Show the screen
                    Screen('Flip',w);
                    % -------------------------------------------------------------
                    % Wait for the user input to exit the screen
                    % Define which keys to terminate and which
                    tkey = KbName('return');
                    % Wait for no keys pressed to start measuring responses
                    keyisdown = 1;
                    while(keyisdown)
                        [keyisdown,t,keycode] = KbCheck;
                        WaitSecs(0.0001);
                    end
                    % Wait for a enter press to continue
                    while(~keycode(Rkey))
                        [keyisdown,t,keycode] = KbCheck; %#ok<*ASGLU>
                        WaitSecs(0.0001);
                    end
                    
                    %Record block number
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 742]); %start block #2
                    Screen('Flip',w);
                    
                    Block = 2;
                 

            %Pause #2
                elseif iii == 2*Procedure.trials/6
                    %Record the rest brake
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 791]);
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text = 'Intervalo 2. Pressione a tecla DIREITA para continuar.';
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
%                     Size=Screen('TextSize',w, 25);
                    % Get the width of the text
                    width = RectWidth(Screen('TextBounds', w, text));
                    % Draw the text on the background screen
                    Screen('Drawtext',w,text,center_x-width/2,center_y, Gray, Size);
                    % Show the screen
                    Screen('Flip',w);
                    % -------------------------------------------------------------
                    % Wait for the user input to exit the screen
                    % Define which keys to terminate and which
                    tkey = KbName('return'); %#ok<*NASGU>
                    % Wait for no keys pressed to start measuring responses
                    keyisdown = 1;
                    while(keyisdown)
                        [keyisdown,t,keycode] = KbCheck;
                        WaitSecs(0.0001);
                    end
                    % Wait for a enter press to continue
                    while(~keycode(Rkey))
                        [keyisdown,t,keycode] = KbCheck;
                        WaitSecs(0.0001);
                    end
                    %Record block number
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 743]); %start block #3
                    
                    Screen('Flip',w);
                    Block = 3;

                    
            %Pause #3
                elseif iii == 3*Procedure.trials/6
                    %Record the rest brake
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 791]);
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text = 'Intervalo 3. Pressione a tecla DIREITA para continuar.';
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
%                     Size=Screen('TextSize',w, 25);
                    % Get the width of the text
                    width = RectWidth(Screen('TextBounds', w, text));
                    % Draw the text on the background screen
                    Screen('Drawtext',w,text,center_x-width/2,center_y, Gray, Size);
                    % Show the screen
                    Screen('Flip',w);
                    % -------------------------------------------------------------
                    % Wait for the user input to exit the screen
                    % Define which keys to terminate and which
                    tkey = KbName('return');
                    % Wait for no keys pressed to start measuring responses
                    keyisdown = 1;
                    while(keyisdown)
                        [keyisdown,t,keycode] = KbCheck;
                        WaitSecs(0.0001);
                    end
                    % Wait for a enter press to continue
                    while(~keycode(Rkey))
                        [keyisdown,t,keycode] = KbCheck;
                        WaitSecs(0.0001);
                    end
                    %Record block number
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 744]); %start block #4
                                      
                    Screen('Flip',w);
                    Block = 4;

                    
            %Pause #4                    
                elseif iii == 4*Procedure.trials/6
                    %Record the rest brake
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 791]);
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text = 'Intervalo 4. Pressione a tecla DIREITA para continuar.';
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
%                     Size=Screen('TextSize',w, 25);
                    % Get the width of the text
                    width = RectWidth(Screen('TextBounds', w, text));
                    % Draw the text on the background screen
                    Screen('Drawtext',w,text,center_x-width/2,center_y, Gray, Size);
                    % Show the screen
                    Screen('Flip',w);
                    % -------------------------------------------------------------
                    % Wait for the user input to exit the screen
                    % Define which keys to terminate and which
                    tkey = KbName('return');
                    % Wait for no keys pressed to start measuring responses
                    keyisdown = 1;
                    while(keyisdown)
                        [keyisdown,t,keycode] = KbCheck;
                        WaitSecs(0.0001);
                    end
                    % Wait for a enter press to continue
                    while(~keycode(Rkey))
                        [keyisdown,t,keycode] = KbCheck;
                        WaitSecs(0.0001);
                    end
                    
                    %Record block number
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 745]); %start block #5
                  
                    Screen('Flip',w);
                    Block = 5;
                    
            %Pause #5
                elseif iii == 5*Procedure.trials/6
                    %Record the rest brake
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 791]);
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text = 'Intervalo 5. Pressione a tecla DIREITA para continuar.';
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
%                     Size=Screen('TextSize',w, 25);
                    % Get the width of the text
                    width = RectWidth(Screen('TextBounds', w, text));
                    % Draw the text on the background screen
                    Screen('Drawtext',w,text,center_x-width/2,center_y, Gray, Size);
                    % Show the screen
                    Screen('Flip',w);
                    % -------------------------------------------------------------
                    % Wait for the user input to exit the screen
                    % Define which keys to terminate and which
                    tkey = KbName('return');
                    % Wait for no keys pressed to start measuring responses
                    keyisdown = 1;
                    while(keyisdown)
                        [keyisdown,t,keycode] = KbCheck;
                        WaitSecs(0.0001);
                    end
                    % Wait for a enter press to continue
                    while(~keycode(Rkey))
                        [keyisdown,t,keycode] = KbCheck;
                        WaitSecs(0.0001);
                    end
                    
                    %Record block number
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 746]); %start block #6
                   
                    Screen('Flip',w);
                    Block = 6;

                    
                end
                %##########################################################
%             end
                % End of the experiment
                if iii == Procedure.trials
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text = 'Fim do Experimento. Obrigado por Participar!';
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
%                     Size=Screen('TextSize',w, 25);
                    % Get the width of the text
                    width = RectWidth(Screen('TextBounds', w, text));
                    % Draw the text on the background screen
                    Screen('Drawtext',w,text,center_x-width/2,center_y, Gray, Size);
                    % Show the screen
                    Screen('Flip',w);
                    % -------------------------------------------------------------
                    % Wait for the user input to exit the screen
                    % Wait for no keys pressed to start measuring responses
                    keyisdown = 1;
                    while(keyisdown)
                        [keyisdown,t,keycode] = KbCheck;
                        WaitSecs(0.0001);
                    end
                    % Check for a escape response to exit
                    while ~keycode(escKey)
                        [keyisdown,t,keycode] = KbCheck;
                        WaitSecs(0.0001);
                    end
                end              
            end
         
            end
         
    WaitSecs(1);
        % Record the end of the experiment
        fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 799]);
        % In case there is an error, terminate the program
    catch
        % Close all windows
        Screen('CloseAll');
        % Display and save the error in the screen
        rethrow(lasterror); %#ok<LERR>
    end
    % Close all windows
    Screen('Close',w);
    % Close all data files
    fclose('all');
    % Bring back the cursor
    ShowCursor;

end


function Practice_Trials
global FID w Session_start_time

Practice_word_list = {
    'ANSIOSO'	'CAPERTO'
    'CELULAR'	'BATERIA'
    'CADERNO'	'FAGUPE'
    'BISCOITO'	'AGENDA'
    'MOCHILA'	'CADEIRA'
    'MARISCO'	'BILORTE'
    };

fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 1711]); %start practice

% Defines all 3 colors. 
Gray = [127 127 127]; %light gray
White = [204 204 204];
Black = [0 0 0];

Ifi = Screen('GetFlipInterval', w);

Procedure.screen = get(0,'screensize');
center_x = Procedure.screen(3)/2;
center_y = Procedure.screen(4)/2;

KbName('UnifyKeyNames');
Key1=KbName('1!'); Key2=KbName('9(');
escKey = KbName('ESCAPE');

 

for Pwl = 1:6 %Loop apresentaï¿½ï¿½o das palavras
                  
                Est = Screen('Flip', w);
                
                %Fixation Point
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text = '+';
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
                    Size=Screen('TextSize',w, 30);
                    % Get the width of the text
                    width = RectWidth(Screen('TextBounds', w, text));
                    % Draw the text on the background screen
                    Screen('Drawtext',w,text,center_x-width/2,center_y, Gray, Size);
                    % Show the screen
                    Est1 = Screen('Flip',w);

                %apresentaï¿½ï¿½o do PRIME por (limiar) segundos 
                    Verb_column = 1; %Column for Prime Verb
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text = char(Practice_word_list(Pwl,Verb_column));
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
%                     Size=Screen('TextSize',w, 24);
                    % Get the width of the text
                    width = RectWidth(Screen('TextBounds', w, text));                 
                    % Draw the text on the background screen
                    Screen('Drawtext',w,text,center_x-width/2,center_y, Gray, Size);
                    % Show the screen
                    Est2 = Screen('Flip',w, Est1 + 2 - Ifi); %Define time of fixation point until Prime is shown (2s).

                    %texto ï¿½ a mascara
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text = 'XXXXXXXX';
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
%                     Size=Screen('TextSize',w, 24);
                    % Get the width of the text
                    width = RectWidth(Screen('TextBounds', w, text));
                    % Draw the text on the background screen
                    Screen('Drawtext',w,text,center_x-width/2,center_y, Gray, Size); 
                    % Show the screen
                    Est3 = Screen('Flip',w, Est2 + 0.025 - Ifi); %Define time of Prime until Mask is shown (Threshold).

                % palavra ALVO
                    Verb_column = 2; %Column for Target Verb
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text =  char(Practice_word_list(Pwl,Verb_column));
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
                    % Size=Screen('TextSize',w, 25);
                    % Get the width of the text
                    width = RectWidth(Screen('TextBounds', w, text));
                    % Draw the text on the background screen
                    Screen('Drawtext',w,text,center_x-width/2,center_y, Gray, Size);
                    % Show the screen
                    Est4 = Screen('Flip',w, Est3 + 0.125 - Ifi);%1200 ms
                          
                % Dot screen at trial end (for response)
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text = '.';
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
%                     Size=Screen('TextSize',w, 25);
                    % Get the width of the text
                    width = RectWidth(Screen('TextBounds', w, text));
                    % Draw the text on the background screen
                    Screen('Drawtext',w,text,center_x-width/2,center_y, Gray, Size);
                    % Show the screen
                    Est5 = Screen('Flip',w, Est4 + 0.25 - Ifi); %Define time of fixation point until Dot is shown (200ms).
                    % Get time for dot appearance
%                     fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 705]);
                    pause (.1);
            
                    
                % Get key press and accuracy
                    keyIsDown=0; % Correct=0; RT=0; 
                    while 1
                            [keyIsDown, secs, keyCode] = KbCheck;
                            FlushEvents('keyDown');
                            if keyIsDown
                                nKeys = sum(keyCode);
                                if nKeys==1
                                    if keyCode(Key1)||keyCode(Key2)
                                        %Record the push of the button 
%                                         fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 709]); %709 = response button pressed
%                                       RT = 1000.*(GetSecs-timeStart);
                                        keypressed=find(keyCode);
                                        Screen('Flip', w);
                                        break;
                                    elseif keyCode(escKey)
                                        ShowCursor; fclose(outfile);  Screen('CloseAll'); return
                                    end
                                    keyIsDown=0; keyCode=0;
                                end
                            end
                     end
                    
end

fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 1719]); %End of practice

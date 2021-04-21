% File:             Pilot_DL_Timing_N400.m
% File type:        function
% Created on:       Jul 02, 2016
% Created by:       Carlos F. Ramos
% Last revised on:  Jun 09, 2016
% Last revised by:  Carlos
%
% Purpose:          Lexical Decision Task. Manipulation: relatedness of
%                   prime and target verbs
%                   
%
% Input:            Via prompt (experiment, condition, participant, and
%                   session number)
%e
% Output:           A text file with time-event codes
%
% Coments:          Adaptation of 'Memorization_relearning_brightness.m',
%                   which was used in Guilhardi et al., 2010.
%
% Format:           N/A
% Example:          N/A



function DL_N400_Timing_Pilot_V1

%%%-----Trigger From Vanessas'----
Istrigger=true;%false; %colocar true quando EEG estiver conectado

if Istrigger
ParportTTL('Open', 'localhost');
tRoundTrip = ParportTTL('Set', 100);
WaitSecs(0.020)
tRoundTrip = ParportTTL('Set', 0);
end
%%%-------------------------------

% Create global variables for function-function to have access and modify
global FID w Session_start_time Total 
cd '/home/atlantica/Carlos/' %Alterar para computador
% addpath C:\toolbox

% Set the randomization state to a random number
rand('state', sum(100*clock));
% Screen('Preference', 'SkipSyncTests', 1);
    
% Screen('Resolution', 0, 1366, 768, 60)

% Prompt for experiment information
prompt = {'Outputfile',...
    'Experimento (e.g., DL1s)',... %   'Condicao (e.g., 1)',...
    'Participante Numero (e.g., 01)',...
    'Limiar',...
    'Sessao (e.g., 01)',...
    'Num of Trials'};
% Set the default values the prompt
def = {'PilotoV1','DL','00','','01','600'};
% Get the answers
Answer = inputdlg (prompt, 'Experiment Information' ,1, def, 'on');

% all input variables are strings
[Output, Experiment, SubId, Threshold, Session, nTrials] = deal(Answer{:});  %sub=subject
% Outputname = [Output Experiment Gender SubId '.xls'];
Ntrials = str2double(nTrials); % convert string to number for subsequent reference
Personal_Threshold = str2double(Threshold);

KbName('UnifyKeyNames');
Key1=KbName('1!'); Key2=KbName('9(');
spaceKey = KbName('space'); escKey = KbName('ESCAPE');
% CorrKey = [0, 1];
CorrKey = [49, 57]; % keys 1! and 9( 


load('/home/atlantica/Carlos/Verbos_final.mat');
    % Matriz de dados - est�mulos;
    % 1 - # est�mulo
    % 2 - Palavra - Prime
    % 3 - Palavra - alvo
    % 4 - Resposta correta (57 = tecla 9; 49 = tecla 1)
    % 5 - Trigger (11=sin�nimos; 12=n-sin�nimos; 13=pseudopalavra)
    % 6 - Trigger_time (21=sin�nimos; 22=n-sin�nimos; 23=pseudopalavra)
CorrKeyList = cell2mat(Verbos_final(:,4));
Trigger = cell2mat(Verbos_final(:,5));
Trigger_time = cell2mat(Verbos_final(:,6));


% If enter was hit, then run the experiment, if not, cancel
if ~isempty(Answer)
    % try the code, and stop and close screen if there are errors
    try
        % Unify key names for windows to recognize
        KbName('UnifyKeyNames');
        
        % Open the experimental screen      
        [w,rect]=Screen('OpenWindow',0);
        % Hide the mouse
        HideCursor;
        
        % ---------------------------------------------------------------------
        % Create the a structure that contains information about the experiment we will run
        % ---------------------------------------------------------------------
        % 1.) The fields below provide information about the sessions to be run
        Procedure.name = char(Answer(2));
        Procedure.participant.id = char(Answer(3));
%         Procedure.participant.age = char(Answer(4));
%         Procedure.participant.gender = char(Answer(5));
        Procedure.session = char(Answer(5));
        Procedure.filename = [Procedure(1).name '_' Procedure(1).participant.id '_' Procedure(1).session];
        Procedure.trials = Ntrials;
        
        % Defines all 3 colors. 
        Gray = [127 127 127 ]; 
        White = [255 255 255]; 
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
            Instructions1 = ['Esse é um experimento de Decisão Lexical \n'...
                        '\n'...
                        'Durante o experimento, você verá \n'...
                        '\n'...
                        'uma cruz, seguida de uma linha de \n'...
                        '\n'...
                        'caracteres (XXXXX) e, por fim, uma \n'...
                        '\n'...
                        'palavra aparecerá rapidamente na tela. \n'...
                        '\n'...
                        '\n'...
                        'Você deve decidir se a palavra apresentada \n'...
                        '\n'...
                        'no fim  realmente existe (ex.: COMPRAR) ou se \n'...
                        '\n'...
                        'é uma pseudopalavra, não existente na \n'...
                        '\n'...
                        'língua Portuguesa, como por exemplo "COMPRER". \n'...
                        '\n'...
                        '\n'...
                        '\n'...
                        'Pressione a tecla DIREITA para continuar. \n'...
                        '\n'];
            Screen('FillRect', w, [0, 0, 0]);
            [~, ~, bbox] = DrawFormattedText(w, Instructions1, 'center', 'center', [255,255,255]);
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
                        'ESQUERDA = Não é uma palavra \n'...
                        '\n'...
                        'DIREITA = Sim, é uma palavra \n'...
                        '\n'...
                        '\n'...
                        'Tente responder o mais rápido que puder, \n'...
                        '\n'...
                        'logo que a palavra aparecer. \n'...
                        '\n'...
                        '\n'...
                        '\n'...
                        '\n'...
                        'Pressione a tecla DIREITA para continuar. \n'...
                        '\n'];
            Screen('FillRect', w, [0, 0, 0]);
            [~, ~, bbox] = DrawFormattedText(w, Instructions2, 'center', 'center', [255,255,255]);
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
   
    %Instructions part 3
        % Draw the lines on the screen     
            Screen('TextSize', w, 24);
            Screen('TextFont', w, 'Arial');
            Instructions3 = ['Durante o experimento, haverá intervalos, para \n'...
                        '\n'...
                        'que você possa descansar. Nesses intervalos, você \n'...
                        '\n'...
                        'pode ficar o tempo que achar necessário antes de \n'...
                        '\n'...
                        'continuar com o experimento. \n'...
                        '\n'...
                        '\n'...
                        '\n'...
                        '\n'...
                        '\n'...
                        '\n'...
                        'Quando estiver pronto, \n'...
                        '\n'...
                        'Pressione a tecla DIREITA para iniciar. \n'...
                        '\n'];
            Screen('FillRect', w, [0, 0, 0]);
            [~, ~, bbox] = DrawFormattedText(w, Instructions3, 'center', 'center', [255,255,255]);
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
        
%          while(~keycode(Key1))
%             [keyisdown,t,keycode] = KbCheck;
%             WaitSecs(0.0001);
%          end
        
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
        
        Actual_threshold = Personal_Threshold * 0.75; % 80% of Measured Threshold 
        
%         for c = 1:Procedure.trials
            
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
            ix = randperm(600); %gerar ordem aleat�ria para apresenta��o dos est�mulos

           
            
        % Define which trials will have unexpected SOA 
                        
            for x = 1:100;
                
                
                Test_trials(1:2,1:6,1:6) = nan; %trials # with SOA change
                for i=1:6 %6 blocks of 100 trials
                    if i==1
                        Trials_block = 11:100; %trials in firts block, excluding the first 10
                    else
                        Trials_block = Trials_block+100; %trials in 5 other blocks, excluding first 10
                    end
                    for j = 1:6
                        if j==1 
                            A = 1:15; %sub-block size
                            T_b = Trials_block(A); %trials 11-25 in a block
                            R = randperm(15); %randomize trials in sub-block
                            R = R([1 2]); %take 2 trials in the sub-block
                            Test_trials(1:2,j,i) = T_b(R); %assing trials R in a matrix
                        else    %repeat assingment for all blocks
                            A = A+15;
                            T_b = Trials_block(A);
                            R = randperm(15);
                            R = R([1 2]);
                            Test_trials(1:2,j,i) = T_b(R);
                        end
                    end
                end
                
                
                N_successive(x) = sum(sum(abs(diff(Test_trials))==1));
            end
            
            
            for iii = 001:Procedure.trials %Loop apresenta��o das palavras
                    
                    % Get time for trial start and trial number
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 711]); %start trial
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time iii+800]); %get trial number
                    % Get word/nonword-pair used
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time ix(iii)+100]);
%                   
        
                %Fixation Point
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text = '+';
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
                    Size=Screen('TextSize',w, 24);
                    % Get the width of the text
                    width = RectWidth(Screen('TextBounds', w, text));
                    % Get time for fixation appearance
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 701]);
                    % Draw the text on the background screen
                    Screen('Drawtext',w,text,center_x-width/2,center_y, White, Size);
                    % Show the screen
                    Screen('Flip',w);
                    pause(2) %2000 ms
                    

                %apresenta��o do PRIME por (limiar) segundos 
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text = char(Verbos_final(ix(iii),2));
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
                    Size=Screen('TextSize',w, 24);
                    % Get the width of the text
                    width = RectWidth(Screen('TextBounds', w, text));
                    % Get time for prime appearance
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 702]);
                    % Draw the text on the background screen
                    Screen('Drawtext',w,text,center_x-width/2,center_y, White, Size);
                    % Show the screen
                    Screen('Flip',w);
                    pause(Actual_threshold) % 80% of Personal Threshold 
                      

                %texto � a mascara
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text = 'XXXXXXX';
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
                    Size=Screen('TextSize',w, 24);
                    % Get the width of the text
                    width = RectWidth(Screen('TextBounds', w, text));
                    % Get time for mask appearance
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 703]);
                    % Draw the text on the background screen
                    Screen('Drawtext',w,text,center_x-width/2,center_y, White, Size);
                    % Show the screen
                    Screen('Flip',w);
                    %pause da m�scara
                    if sum(sum(any(iii==Test_trials)))==1 %time expectancy brake
                        pause(0.6) %600 ms 
                        Time_brake = true;
                        fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 721]); %SOA is short
                    else
                        pause(1.2) %1200 ms
                        Time_brake = false;
                        fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 722]); %SOA is long
                    end

                % palavra ALVO
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text = char(Verbos_final(ix(iii),3));
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
                    Size=Screen('TextSize',w, 25);
                    % Get the width of the text
                    width = RectWidth(Screen('TextBounds', w, text));
                    % Get time for target appearance
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 704]);
                    timeStart = GetSecs;
                    % Draw the text on the background screen
                    Screen('Drawtext',w,text,center_x-width/2,center_y, White, Size);
                    % Show the screen
                    Screen('Flip',w);
                    if Istrigger
                        if Time_brake
                            Trigger_code = Trigger_time(ix(iii));
                        else
                            Trigger_code = Trigger(ix(iii));
                        end
                        tRoundTrip = ParportTTL('Set', Trigger_code); %mandar o trigger
                        WaitSecs(0.01)
                        tRoundTrip = ParportTTL('Set', 0); %fecha a janela                        
                    end     
                    %pause da segunda palavra
                    WaitSecs(0.2); %200 ms
                    
                    
                % Dot screen at trial end (for response)
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text = '.';
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
                    Size=Screen('TextSize',w, 25);
                    % Get the width of the text
                    width = RectWidth(Screen('TextBounds', w, text));
                    % Get time for dot appearance
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 705]);
                    % Draw the text on the background screen
                    Screen('Drawtext',w,text,center_x-width/2,center_y, White, Size);
                    % Show the screen
                    Screen('Flip',w);
                    %pause da segunda palavra
                    pause(0.0001) 
        
                    
                % Get key press and accuracy
                    keyIsDown=0; Correct=0; RT=0;
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
                                        ShowCursor; fclose(outfile);  Screen('CloseAll'); return
                                    end
                                    keyIsDown=0; keyCode=0;
                                end
                            end
                     end
                     if (keypressed==CorrKeyList(ix(iii)))
                            Correct=911;
                        else
                            Correct=910;
                     end

                    
            %Record the end of trial 
            fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 719]); 
            %Record accuracy
            fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time Correct]);  %720/721


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
                    text = 'Faça uma pausa. Pressione a tecla DIREITA para continuar.';
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
                    Size=Screen('TextSize',w, 25);
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
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 742]); %start block #2
                    Screen('Flip',w);
                    
                    
            %Pause #2
                elseif iii == 2*Procedure.trials/6
                    %Record the rest brake
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 791]);
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text = 'Faça uma pausa. Pressione a tecla DIREITA para continuar.';
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
                    Size=Screen('TextSize',w, 25);
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
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 743]); %start block #3
                    
                    Screen('Flip',w);
            %Pause #3
                elseif iii == 3*Procedure.trials/6
                    %Record the rest brake
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 791]);
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text = 'Faça uma pausa. Pressione a tecla DIREITA para continuar.';
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
                    Size=Screen('TextSize',w, 25);
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
            %Pause #4                    
                elseif iii == 4*Procedure.trials/6
                    %Record the rest brake
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 791]);
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text = 'Faça uma pausa. Pressione a tecla DIREITA para continuar.';
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
                    Size=Screen('TextSize',w, 25);
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
            %Pause #5
                elseif iii == 5*Procedure.trials/6
                    %Record the rest brake
                    fprintf(FID, '%12.4f\t %3.0f\n',[GetSecs-Session_start_time 791]);
                    % Fill the background with black
                    Screen('FillRect',w,Black);
                    % Define the text of the end screen
                    text = 'Faça uma pausa. Pressione a tecla DIREITA para continuar.';
                    % Set the text to bold
                    Screen('TextStyle',w, 1);
                    % Get the size of the text screen
                    Size=Screen('TextSize',w, 25);
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
                    Size=Screen('TextSize',w, 25);
                    % Get the width of the text
                    width = RectWidth(Screen('TextBounds', w, text));
                    % Draw the text on the background screen
                    Screen('Drawtext',w,text,center_x-width/2,center_y, White, Size);
                    % Show the screen
                    Screen('Flip',w);
                    % -------------------------------------------------------------
                    % Wait for the user input to exit the screen
                    % Define which keys to terminate and which
%                     escKey = ESCAPE
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
        rethrow(lasterror);
    end
    % Close all windows
    Screen('Close',w);
    % Close all data files
    fclose('all');
    % Bring back the cursor
    ShowCursor;
    % Display on the command window the total points
%     fprintf(['\n\nTotal score = ' num2str(Total) '\n\n']);
end


%%% Function that controls the ITI period
%
function ITI(Shot_times, Edges)
global FID w Session_start_time Total


% -------------------------------------------------------------------------
% This section controls for user input on keyboard
% -------------------------------------------------------------------------
% Define which keys to wait for: space to continue
rkey = KbName('space');
% Define which keys to wait for: escape to terminate
tkey = KbName('escape');
% Wait for no keys pressed, then
keyisdown = 1;
while(keyisdown)
    [keyisdown,t,keycode] = KbCheck;
    WaitSecs(0.0001);
end
% Wait for a space bar press to continue or escape to exit
while ~xor(keycode(rkey),keycode(tkey))
    [keyisdown,t,keycode] = KbCheck;
    WaitSecs(0.0001);
end
% Check if keypress was to terminate experiment, if not, continue
if keycode(tkey)
    % Get the size of the text
    Size=Screen('TextSize',w, 22);
    % Set the text to bold
    Screen('TextStyle',w, 1);
    % Prompt to check to exit the experiment
    text = 'Tem certeza que deseja sair? Pressione "s" para sim e "n" para n�o';
    % Get the text position on screen
    width = RectWidth(Screen('TextBounds', w, text));
    % Write on the background screen
    Screen('Drawtext',w,text,center_x-width/2,center_y, [255 255 255], Size);
    % Define options of response to the prompt: y for yes, n for no
    tkey = KbName('s');
    ckey = KbName('n');
    % Show prompt on the screen
    Screen('Flip',w);
    % Wait for no responses before recording y or n
    keyisdown = 1;
    while(keyisdown)
        [keyisdown,t,keycode] = KbCheck;
        WaitSecs(0.0001);
    end
    
    % Check if response was to terminate or continue the experiment
    while ~xor(keycode(tkey),keycode(ckey))
        [keyisdown,t,keycode] = KbCheck;
        WaitSecs(0.0001);
    end
    % If it is to terminate, close screen, save the data, show the cursor,
    % and terminate the experiment with an error.
    if keycode(tkey)
        fprintf(FID, '%12.4f\t %2.0f\n',[t-Session_start_time 62]);
        Screen('Close',w);
        fclose('all');
        ShowCursor;
        error('Experimento encerrado pelo usu�rio');
    end
end % if not is empty dialog box
t = Screen('Flip',w);
ParportTTL('Close');
fprintf(FID, '%12.4f\t %2.0f\n',[t-Session_start_time 50]);


%%

% tRoundTrip = ParportTTL('Set', 21)
% WARNING: Empty receive from parallelPortServer - Timed out?!?
% WARNING: Unable to get acknowledge for command within timeout interval! (count = 0)
% 
% tRoundTrip =
% 
%     0.0044
%// File:             Carlos_DataAnalysis_comportamental.m
%// File type:        function
%// Created on:       March 02, 2017
%// Created by:       Marcelo S. Caetano and Carlos Ramos
%// Last revised on:  28-jun-17
%// Last revised by:  Carlos
%
%// Purpose:          Analysis of N400 experiment (Carlos' Master's project)
%//                   >> Behavioral task
%// Input:            N/A
%
%// Output:           N/A
%
%// Coments:
%
%// Format:           N/A
%// Example:          N/A

%%// Basic variables
clear all
format short g

%%%// Go to the folder with the data
cd 'E:\EEG_data\dados_carlos\Mestrado\Comportamental\Exp1_Time' %Alterar para computador

%%%// Define subjects
Subjects = [1 2 3 4 5 6]; 

%%// Perform basic calculations
    %// Counter for types of trials
    
    Acc_NW = zeros (1,length(Subjects)) ; Acc_NWt = zeros (1,length(Subjects)); Acc_CW = zeros (1,length(Subjects));
    Acc_CWt = zeros (1,length(Subjects)); Acc_IW = zeros (1,length(Subjects)); Acc_IWt = zeros (1,length(Subjects));

%// Loop for participants
for i = 1:length(Subjects)
    
    %// Load data
    if i<10
        File_name = ['DL_' '0' num2str(Subjects(i))];
    else
        File_name = ['DL_' num2str(Subjects(i))];
    end
    Data = load(File_name);
    
    %// Count trials
    Trials = sum(Data(:,2)==711);
    
    %// Index for trial start and end
    Index_TrialStart = find(Data(:,2)==711);
    Index_TrialEnd = find((Data(:,2)==719));
    
    NW = 0; NWt = 0; CW = 0; CWt = 0; IW = 0; IWt = 0;
    %// Loop for trials
    for j = 1:Trials
        %// Select trial data
        if  strcmp(File_name,'DL_03'); %corre��o para voluntario 3
            Data_trial = Data(Index_TrialStart(j):Index_TrialEnd(j)+1,:);
        else
            Data_trial = Data(Index_TrialStart(j):Index_TrialEnd(j),:);
        end
        
        %// Identify type of trial
        if sum(ismember(401:700,Data_trial)) %// Non-word pair
            
            if ismember(722,Data_trial) %// SOA 1200ms
                NW = NW+1;
                if ismember(911,Data_trial) %// ACC p/ SOA 1200ms
                    Acc_NW(1,i) = Acc_NW(1,i)+1;
                    Resp = Data_trial(Data_trial(:,2)==709,1);
                    Stim = Data_trial(Data_trial(:,2)==704,1);
                    RT_NW(NW,i) = Resp-Stim; %#ok<*SAGROW>
                    
                end
            elseif ismember(721,Data_trial) %// SOA 600ms
                NWt = NWt+1;
                if ismember(911,Data_trial) %ACC p/ SOA 600ms
                    Acc_NWt(1,i) = Acc_NWt(1,i)+1;
                    Resp = Data_trial(Data_trial(:,2)==709,1);
                    Stim = Data_trial(Data_trial(:,2)==704,1);
                    RT_NWt(NWt,i) = Resp-Stim;
                    
                end
            end
            
        elseif sum(ismember(101:250,Data_trial)) %// Congruent pair
            if ismember(722,Data_trial) %// SOA 1200ms
                CW = CW+1;
                if ismember(911,Data_trial) %%ACC p/ SOA 1200ms
                    Acc_CW(1,i) = Acc_CW(1,i)+1;
                    Resp = Data_trial(Data_trial(:,2)==709,1);
                    Stim = Data_trial(Data_trial(:,2)==704,1);
                    RT_CW(CW,i) = Resp-Stim;
                    
                end
            elseif ismember(721,Data_trial) %// SOA 600ms
                CWt = CWt+1;
                if ismember(911,Data_trial) %// %ACC p/ SOA 600ms
                    Acc_CWt(1,i) = Acc_CWt(1,i)+1;                 
                    Resp = Data_trial(Data_trial(:,2)==709,1);
                    Stim = Data_trial(Data_trial(:,2)==704,1);
                    RT_CWt(CWt,i) = Resp-Stim;
                    
                end
            end
            
        elseif sum(ismember(251:400,Data_trial)) %// Incongruent pair
            if ismember(722,Data_trial) %// SOA 1200ms
                IW = IW+1;
                if ismember(911,Data_trial) %// %ACC p/ SOA 1200ms
                    Acc_IW(1,i) = Acc_IW(1,i)+1;                   
                    Resp = Data_trial(Data_trial(:,2)==709,1);
                    Stim = Data_trial(Data_trial(:,2)==704,1);
                    RT_IW(IW,i) = Resp-Stim;
                    
                end
            elseif ismember(721,Data_trial) %// SOA 600ms
                IWt = IWt+1;
                if ismember(911,Data_trial) %// %ACC p/ SOA 600ms
                    Acc_IWt(1,i) = Acc_IWt(1,i)+1;
                    Resp = Data_trial(Data_trial(:,2)==709,1);
                    Stim = Data_trial(Data_trial(:,2)==704,1);
                    RT_IWt(IWt,i) = Resp-Stim;
                    
                end
            end
        end
        
    end
    

end

%// Acc_NW2 = (Acc_NW')/NW; Acc_NWt2 = (Acc_NWt')/NWt; Acc_CW2 = (Acc_CW')/CW;
%// Acc_CWt2 = (Acc_CWt')/CWt; Acc_IW2 = (Acc_IW')/IW; Acc_IWt2 = (Acc_IWt')/IWt;

Acc_NW = mean(Acc_NW)/NW; Acc_NWt = mean(Acc_NWt)/NWt; Acc_CW = mean(Acc_CW)/CW;
Acc_CWt = mean(Acc_CWt)/CWt; Acc_IW = mean(Acc_IW)/IW; Acc_IWt = mean(Acc_IWt)/IWt;



 %Tira outliers
RT_CW2 = RT_CW ;RT_CW2 (RT_CW2==0)= nan;
RT_IW2 = RT_IW ;RT_IW2 (RT_IW2==0)= nan;
RT_NW2 = RT_NW ;RT_NW2 (RT_NW2==0)= nan;
RT_CWt2 = RT_CWt ;RT_CWt2 (RT_CWt2==0)= nan;
RT_IWt2 = RT_IWt ;RT_IWt2 (RT_IWt2==0)= nan;
RT_NWt2 = RT_NWt ;RT_NWt2 (RT_NWt2==0)= nan;



StndDevCW = nanmean(RT_CW2,1)+(4*nanstd(RT_CW2));
StndDevIW = nanmean(RT_IW2,1)+(4*nanstd(RT_IW2));
StndDevNW = nanmean(RT_NW2,1)+(4*nanstd(RT_NW2));
StndDevCWt = nanmean(RT_CWt2,1)+(4*nanstd(RT_CWt2));
StndDevIWt = nanmean(RT_IWt2,1)+(4*nanstd(RT_IWt2));
StndDevNWt = nanmean(RT_NWt2,1)+(4*nanstd(RT_NWt2));


%// StndDevCW = mean(RT_CW2)+4*std(RT_CW2);
%// StndDevIW = mean(RT_IW2)+4*std(RT_IW2);
%// StndDevNW = mean(RT_NW2)+4*std(RT_NW2);
%// 

for ii = 1:length(Subjects)
    A = find(RT_CW2(:,ii) > StndDevCW(ii)); RT_CW2(A,ii) = nan;
    B = find(RT_IW2(:,ii) > StndDevIW(ii)); RT_IW2(B,ii) = nan;
    C = find(RT_NW2(:,ii) > StndDevNW(ii)); RT_NW2(C,ii) = nan;
    At = find(RT_CWt2(:,ii) > StndDevCWt(ii)); RT_CWt2(At,ii) = nan;
    Bt = find(RT_IWt2(:,ii) > StndDevIWt(ii)); RT_IWt2(Bt,ii) = nan;
    Ct = find(RT_NWt2(:,ii) > StndDevNWt(ii)); RT_NWt2(Ct,ii) = nan;
end

max (RT_CW2)
max (RT_IW2)
max (RT_NW2)
max (RT_CWt2)
max (RT_IWt2)
max (RT_NWt2)

 

%%// Figures

%%%// Figure on RT
X = [1 2 4 5 7 8];
Y = [mean(nanmean(RT_NW2,1)) mean(nanmean(RT_NWt2,1)) mean(nanmean(RT_IW2,1)) mean(nanmean(RT_IWt2,1)) mean(nanmean(RT_CW2,1)) mean(nanmean(RT_CWt2,1))];
%// SEM = [std(RT_NW)  std(RT_IW) std(RT_CW) std(RT_NWt) std(RT_IWt)  std(RT_CWt)];
SEM = [std(nanmean(RT_NW2,1)) std(nanmean(RT_NWt2,1)) std(nanmean(RT_IW2,1)) std(nanmean(RT_IWt2,1)) std(nanmean(RT_CW2,1)) std(nanmean(RT_CWt2,1))];

figure
bar(X,Y); hold on
errorbar(X,Y,SEM,'+')
set(gca,'xticklabel',{'NW' 'NWt' 'IW' 'IWt' 'CW' 'CWt'})
ylabel('RT (s)')
ylim([0.3 1]);
title ('RT Time/Conditions');


%%%// Figure on RT 2
X = [1 2 3 5 6 7];
Y = [mean(nanmean(RT_NW2,1)) mean(nanmean(RT_NWt2,1)) mean(nanmean(RT_IW2,1)) mean(nanmean(RT_IWt2,1)) mean(nanmean(RT_CW2,1)) mean(nanmean(RT_CWt2,1))];
%// SEM = [std(RT_NW)  std(RT_IW) std(RT_CW) std(RT_NWt) std(RT_IWt)  std(RT_CWt)];
SEM = [std(nanmean(RT_NW2,1)) std(nanmean(RT_NWt2,1)) std(nanmean(RT_IW2,1)) std(nanmean(RT_IWt2,1)) std(nanmean(RT_CW2,1)) std(nanmean(RT_CWt2,1))];

figure
bar(X,Y); hold on
errorbar(X,Y,SEM,'+')
set(gca,'xticklabel',{'NW' 'IW' 'CW' 'NWt' 'IWt' 'CWt'})
ylabel('RT (s)')
ylim([0.3 1]);
title ('RT Conditions (Regular/Time)');




%%%// Figure on ACC
X = [1 2 4 5 7 8];
Y = [Acc_NW Acc_NWt Acc_CW Acc_CWt Acc_IW Acc_IWt];
%// SEM = [std(RT_NW) std(RT_NWt) std(RT_IW) std(RT_IWt) std(RT_CW) std(RT_CWt)];

figure
bar(X,Y); hold on
%// errorbar(X,Y,SEM,'+')
set(gca,'xticklabel',{'NW' 'NWt' 'IW' 'IWt' 'CW' 'CWt'})
ylabel('ACC (%)')
ylim([0.7 1]);
title ('ACC Time/Conditions');


%%%// Figure on ACC 2
X = [1 2 3 5 6 7];
Y = [Acc_NW Acc_IW Acc_CW Acc_NWt Acc_IWt Acc_CWt];
%// SEM = [std(RT_NW) std(RT_NWt) std(RT_IW) std(RT_IWt) std(RT_CW) std(RT_CWt)];

figure
bar(X,Y); hold on
%// errorbar(X,Y,SEM,'+')
set(gca,'xticklabel',{'NW'  'IW' 'CW' 'NWt' 'IWt' 'CWt'})
ylabel('ACC (%)')
ylim([0.7 1]);
title ('ACC Conditions (Regular/Time)');



Rt_anova = [(nanmean(RT_NW2))'  (nanmean(RT_IW2))' (nanmean(RT_CW2))' (nanmean(RT_NWt2))' (nanmean(RT_IWt2))' (nanmean(RT_CWt2))'];
%// Acc_anova = [Acc_NW2 Acc_IW2 Acc_CW2 Acc_NWt2 Acc_IWt2 Acc_CWt2];



repanova(Rt_anova,[2 3],{'tempo','condicao'})
%// ttest(Acc_anova,[2 3],{'tempo','condicao'})


%%// Compara��es
close all

for ii = 1:length(Subjects)
    mean_subjects.r(ii,1) = nanmean(RT_NW2(:,ii),1); %regular - pseud
    mean_subjects.r(ii,2) = nanmean(RT_IW2(:,ii),1); %regular - incong
    mean_subjects.r(ii,3) = nanmean(RT_CW2(:,ii),1); %regular - cong
    mean_subjects.t(ii,1) = nanmean(RT_NWt2(:,ii),1); %time - pseud
    mean_subjects.t(ii,2) = nanmean(RT_IWt2(:,ii),1); %time - incong
    mean_subjects.t(ii,3) = nanmean(RT_CWt2(:,ii),1); %time - cong
end


%// mean_all = zeros(3,2);
%// for ii = 1:length(mean_all)
%//     mean_all(ii,2) = mean(mean_subjectst(:,ii));
%//     mean_all(ii,1) = mean(mean_subjects(:,ii));
%// end
%anova2 (mean_all)


P_cond_reg = friedman(mean_subjects.r,1) %entre condi��es, trials regulares
pause
P_cond_time = friedman(mean_subjects.t,1)%entre condi��es, trials com tempo
pause

%%%// Compara��o entre regular/tempo, para cada condi��o
Mean_all.cong(:,1) =  mean_subjects.r(:,3);
Mean_all.cong(:,2) =  mean_subjects.t(:,3);
Mean_all.incong(:,1) =  mean_subjects.r(:,2);
Mean_all.incong(:,2) =  mean_subjects.t(:,2);
Mean_all.pseud(:,1) =  mean_subjects.r(:,1);
Mean_all.pseud(:,2) =  mean_subjects.t(:,1);


%// P_cong = friedman(Mean_all.cong,1)
%// pause
%// P_incong = friedman(Mean_all.incong,1)
%// pause
%// P_pseud = friedman(Mean_all.pseud,1)
%// pause
%// close all

%%%// Compara��o entre regular/tempo, independente da condi��o
Mean_all.SOA(:,1) =  mean_subjects.r(:);
Mean_all.SOA(:,2) =  mean_subjects.t(:);

P_SOA = friedman(Mean_all.SOA,6)


%%%Figure on RT (regular/time only)
X = [1 2];
Y = [mean(Mean_all.SOA)];
SEM = [std(Mean_all.SOA)];
    
figure
bar(X,Y); hold on
errorbar(X,Y,SEM,'+')
set(gca,'xticklabel',{'Regular' 'Time'})
ylabel('RT (s)')
ylim([0.3 1]);
title ('RT (SOA only)')

pause


%%%// Compara��o entre condi��es, independente do SOA
Mean_all.Cond(:,1) =  Mean_all.cong(:);
Mean_all.Cond(:,2) =  Mean_all.incong(:);
Mean_all.Cond(:,3) =  Mean_all.pseud(:);

P_Cond = friedman(Mean_all.Cond,6)



%%%Figure on RT (conditions only)
X = [1 2 3];
Y = [mean(Mean_all.Cond)];
SEM = [std(Mean_all.Cond)];
    
figure
bar(X,Y); hold on
errorbar(X,Y,SEM,'+')
set(gca,'xticklabel',{'Cong' 'Incong' 'Pseud'})
ylabel('RT (s)')
ylim([0.3 1]);
title ('RT (conditions only)')

%%

%// Acc_NW Acc_IW Acc_CW Acc_NWt Acc_IWt Acc_CWt

Acc_regular = [Acc_NW Acc_IW Acc_CW]
Acc_time = [Acc_NWt Acc_IWt Acc_CWt]

Acc_all = [Acc_regular' Acc_time']

[P_Acc,tbl,S] = anova2(Acc_all)





Rt_anova = [(nanmean(RT_NW2 ))'  (nanmean(RT_IW2))' (nanmean(RT_CW2))' (nanmean(RT_NWt2))' (nanmean(RT_IWt2))' (nanmean(RT_CWt2))'];
%// Acc_anova = [Acc_NW2 Acc_IW2 Acc_CW2 Acc_NWt2 Acc_IWt2 Acc_CWt2];



repanova(Rt_anova,[2 3],{'tempo','condicao'})
%// ttest(Acc_anova,[2 3],{'tempo','condicao'})













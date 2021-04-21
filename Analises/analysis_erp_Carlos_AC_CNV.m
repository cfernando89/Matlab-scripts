%// File:             analysis_erp_carlos.m
%// File type:        function
%// Created on:       March 02, 2017
%// Created by:       Carlos Ramos
%// Last revised on:  30-jun-17
%// Last revised by:  Carlos
%
%// Purpose:          Analysis of N400 experiment (Carlos' Master's project)
%//                   >> ERP 
%// Input:            N/A
%
%// Output:           N/A
%
%// Coments:
%
%// Format:           N/A
%// Example:          N/A

%%// Variables

%// Data location
cd('E:\EEG_data\dados_carlos\Mestrado\Raw_Exp1_time\export_v2\spm_data')

%// Data Conversion SPM to FT
clear
D=spm_eeg_load('grande_media')
ft_cong=nspm2ftrip_erp_condition(D,'Congr')
ft_incong=nspm2ftrip_erp_condition(D,'Incongr')
ft_pseud=nspm2ftrip_erp_condition(D,'Pseud')

ft_cong_time=nspm2ftrip_erp_condition(D,'Congr_time')
ft_incong_time=nspm2ftrip_erp_condition(D,'Incongr_time')
ft_pseud_time=nspm2ftrip_erp_condition(D,'Pseud_time')

%// ft_cong.avg = ft_cong.avg*-1
%// ft_incong.avg = ft_incong.avg*-1
%// ft_pseud.avg = ft_pseud.avg*-1
%// 
ft_cong_time
ft_incong_time
ft_pseud_time


ft_incong_cong = ft_cong;
ft_incong_cong.avg = ((ft_incong_time.avg+ft_incong_time.avg)/2)-((ft_cong_time.avg+ft_cong_time.avg)/2);

ft_diferenca=ft_cong;
ft_diferenca.avg=ft_incong.avg-ft_cong.avg;

ft_diferenca2=ft_cong;
ft_diferenca2.avg=ft_pseud.avg-ft_cong.avg;

ft_diferenca_t=ft_cong_time;
ft_diferenca_t.avg=ft_incong_time.avg-ft_cong_time.avg;

ft_diferenca2_t=ft_cong_time;
ft_diferenca2_t.avg=-(ft_pseud_time.avg-ft_cong_time.avg);

ft_diferenca3_t=ft_cong_time;
ft_diferenca3_t.avg=ft_pseud_time.avg-ft_incong_time.avg;


ft_diferenca_t2=ft_cong_time;
ft_diferenca_t2.avg= (ft_cong.avg+ft_incong.avg+ft_pseud.avg) - (ft_cong_time.avg+ft_incong_time.avg+ft_pseud_time.avg);


Mean_time = ft_cong_time;
Mean_time.avg = (ft_incong_time.avg+ft_cong_time.avg+ft_pseud_time.avg)/3;
Mean_regular = ft_cong_time;
Mean_regular.avg = (ft_incong.avg+ft_cong.avg+ft_pseud.avg)/3;

Mean_time_palavras = ft_cong_time;
Mean_time_palavras.avg = (ft_incong_time.avg+ft_cong_time.avg)/2;
Mean_regular_palavras = ft_cong_time;
Mean_regular_palavras.avg = (ft_incong.avg+ft_cong.avg)/2;


%// Mean_time = ft_cong_time;
%// Mean_time.avg = -1*(ft_incong_time.avg+ft_cong_time.avg+ft_pseud_time.avg)/3;
%// Mean_regular = ft_cong_time;
%// Mean_regular.avg = -1*(ft_incong.avg+ft_cong.avg+ft_pseud.avg)/3;

Mean_cong = ft_cong_time;
Mean_cong.avg = (ft_cong_time.avg+ft_cong.avg)/2;
Mean_incong = ft_cong_time;
Mean_incong.avg = (ft_incong.avg+ft_incong_time.avg)/2;

Mean_pseud = ft_cong_time;
Mean_pseud.avg = (ft_pseud_time.avg+ft_pseud.avg)/2;

Mean_condicoes = ft_cong_time;
Mean_condicoes.avg = (Mean_incong.avg+Mean_cong.avg)/2;


ft_diferenca_all = ft_cong_time;
ft_diferenca_all.avg = Mean_regular.avg-Mean_time.avg;

ft_all=ft_cong_time
ft_all.avg=(ft_incong.avg+ft_incong_time.avg+ft_cong.avg+ft_cong_time.avg+ft_pseud_time.avg+ft_pseud.avg)./6



%%// Multiplot

cfg=[]
cfg.ylim = 'maxabs'
cfg.zlim = 'maxabs'
%// cfg.xlim = [-.200 1.2]
 cfg.hlim = [-.2 1.2]
cfg.interactive='yes'
%// cfg.layout='EEG1010.lay';
cfg.layout='easycapM11.mat'

%// %// cfg.baseline = [.5 .6]
%// cfg.showlabels    = 'yes'
%// cfg.linestyle = {'-'}
%// %// cfg.graphcolor = a
%// cfg.graphcolor = ['b' 'k' 'r' 'b' 'k' 'r']
%// cfg.linewidth = 2

%%
%Regular task
figure
ft_multiplotER(cfg,ft_cong,ft_incong,ft_pseud);
%// ft_multiplotER(cfg,ft_all);

%Time task
figure
ft_multiplotER(cfg,ft_cong_time,ft_incong_time,ft_pseud_time);

%All task
cfg.linestyle = {'-','-','-','--','--','--'}
figure
ft_multiplotER(cfg,ft_cong,ft_incong,ft_pseud, ft_cong_time,ft_incong_time,ft_pseud_time);

legend('Cong','Incong','Pseud','Cong-T','Incong-T','Pseud-T')

 


%// %Incong - Cong (Regular/Time)
%// figure
%// ft_multiplotER(cfg,ft_diferenca,ft_diferenca_t);
%// 
%// %Pseud - Cong (Regular/Time)
%// figure
%// ft_multiplotER(cfg,ft_diferenca2,ft_diferenca2_t);
%// 
%// %Incong/Pseud - Cong (Regular)
%// figure
%// ft_multiplotER(cfg,ft_cong,ft_diferenca,ft_diferenca2);
%// 
%// %Incong/Pseud - Cong (Time)
%// figure
%// ft_multiplotER(cfg,ft_diferenca_t,ft_diferenca2_t);


%Pseud-Time/Pseud-Regular
figure
ft_multiplotER(cfg,ft_pseud_time,ft_pseud);

%Incong-Time/Incong-Regular
figure
ft_multiplotER(cfg,ft_incong_time,ft_incong);

%Cong-Time/Cong-Regular
figure
ft_multiplotER(cfg,ft_cong_time,ft_cong);

%
figure
ft_multiplotER(cfg,ft_cong_time,ft_cong,ft_incong_time,ft_incong);

%Mean-time/Mean-regular
figure
ft_multiplotER(cfg,Mean_time,Mean_regular);

%Mean cong/Mean incong 
figure
ft_multiplotER(cfg,Mean_cong,Mean_incong);%,Mean_pseud);

%// Mean_time_palavras 
figure
ft_multiplotER(cfg,Mean_time_palavras,Mean_regular_palavras);%,Mean_pseud);

%soma de todos
figure
ft_multiplotER(cfg,ft_all);

%Psudopalavras-palavras
figure
ft_multiplotER(cfg,Mean_pseud_palavra);

%Incong-Cong
figure
ft_multiplotER(cfg,ft_incong_cong);

%
figure
ft_multiplotER(cfg,ft_diferenca_all);





ylabel('Amplitude (uV)')
xlabel('Tempo (s)')

title ('Congruente/Irregular')
title ('Incongruente/Irregular')
title ('Pseudopalavra/Irregular')

title ('Irregular')
title ('Regular')

%%// Topoplot

cfg=[]
cfg.ylim = 'maxabs'
cfg.zlim = 'maxabs'
cfg.interactive='yes'
%// cfg.layout='EEG1010.lay';
cfg.layout='easycapM11.mat'
%// cfg.xlim=[.07 .132] %Time
%// cfg.ylim='maxabs'
%// cfg.baseline=[-.15 .500]
cfg.channel = {'PO8', 'PO7', 'O1', 'O2','P7', 'P8'}

%ft_incong.avg-ft_cong.avg;
figure
ft_topoplotER(cfg,ft_diferenca);

%ft_pseud.avg-ft_cong.avg;
figure
ft_topoplotER(cfg,ft_diferenca2);

%ft_incong_time.avg-ft_cong_time.avg;
figure
ft_topoplotER(cfg,ft_diferenca_t);

%ft_pseud_time.avg-ft_cong_time.avg;
figure
ft_topoplotER(cfg,ft_diferenca2_t);


%ft_pseud_time.avg-ft_inccong_time.avg;
figure
ft_topoplotER(cfg,ft_diferenca3_t);

figure
ft_topoplotER(cfg,ft_diferenca_t2);


%time-semantic
figure
ft_topoplotER(cfg,ft_diferenca_all);

figure
ft_topoplotER(cfg,Mean_time);


title('Diferen�a - Pseudopalavra/Incongruente')
title('Diferen�a - Regular/Irregular')

%%// Error Bar + statistical test

nome_arquivos={
    'PpA_DL_01'
    'PpA_DL_02'
    'PpA_DL_03'
    'PpA_DL_04'
    'PpA_DL_05'
    'PpA_DL_06'
    'PpA_DL_07'
    'PpA_DL_08'
    'PpA_DL_09'
    'PpA_DL_10'
    'PpA_DL_11'
         }

nSujeitos=size(nome_arquivos,1)

%CNV
ROI={'C1', 'Cz', 'C2', 'CP2', 'CPz', 'CP1', 'P1', 'Pz', 'P2'}
TOI= [-0.130 0.140]


%// %N400
ROI={'C1', 'Cz', 'C2', 'CP2', 'CPz', 'CP1', 'P1', 'Pz', 'P2'}
TOI=[0.253065 0.426935]
%// TOI= [0.300452 0.440125]
%// 
%// %P3a
%// ROI={'AF7', 'AF3', 'AFz', 'AF4', 'F3', 'F1', 'Fz', 'F2', 'F4'}
%// TOI= [0.389166 0.497228]
%// 
%// %P3b
%// ROI={'C1', 'Cz', 'C2', 'CP2', 'CPz', 'CP1', 'P1', 'Pz', 'P2'}
%// TOI= [0.505076 0.673039]
%// 
%// 
%// %P1
%// ROI={'PO8', 'PO7', 'O1', 'O2','P7', 'P8'}
%// TOI= [0.070350 0.132562]
%// 
%// %N1
%// ROI={'PO8', 'PO7', 'O1', 'O2'}
%// TOI= [0.153300 0.215512]

%%
%%%Trials Semantic
for iSujeito=1:nSujeitos
D=spm_eeg_load(strcat('maespm8_',nome_arquivos{iSujeito}))
 
%// par�metros de interesse
indice_eletrodos=D.indchannel(ROI) 
indice_tempo_comeco=D.indsample(TOI(1))
indice_tempo_fim=D.indsample(TOI(2))

dados_CongIncongPseud(iSujeito,1)=mean(mean(D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,D.indtrial('Congr')))) %#ok<*SAGROW>
dados_CongIncongPseud(iSujeito,2)=mean(mean(D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,D.indtrial('Incongr'))))
dados_CongIncongPseud(iSujeito,3)=mean(mean(D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,D.indtrial('Pseud'))))

end

figure
errorbar(1:3,mean(dados_CongIncongPseud),std(dados_CongIncongPseud)./sqrt(nSujeitos),'bo')
set(gca,'XTick',1:3,'XTickLabel',{'Cong','Incong','Pseud'})
title ('Semantic')
ylabel('Amplitude (uV)')
xlabel('Condition')

repanova(dados_CongIncongPseud,3)

[t_congr_incongr, p_congr_incongr] = qttest(dados_CongIncongPseud(:,1), dados_CongIncongPseud(:,2),1);
[t_congr_pseudo, p_congr_pseudo] = qttest(dados_CongIncongPseud(:,1), dados_CongIncongPseud(:,3),1);
[t_incongr_pseudo, p_incongr_pseudo] = qttest(dados_CongIncongPseud(:,2), dados_CongIncongPseud(:,3),1);

p_congr_incongr
p_congr_pseudo
p_incongr_pseudo

p_congr_incongr.*3
p_congr_pseudo.*3
p_incongr_pseudo.*3

%%
%%%Semantic_Time
%// ROI= {'C1', 'Cz', 'C2', 'CP2', 'CPz', 'CP1', 'P3', 'P1', 'Pz', 'P2'} %N400
%// TOI=[0.402687 0.496437] %N400
%// ROI=  {'CP2', 'CPz', 'CP1', 'P3', 'P1', 'Pz', 'P2', 'P4'} %P300
%// TOI=[0.496618 0.655604] %P300

%%%Trials Semantic_Time
for iSujeito=1:nSujeitos
D=spm_eeg_load(strcat('maespm8_',nome_arquivos{iSujeito}))
 
%// par�metros de interesse
indice_eletrodos=D.indchannel(ROI) 
indice_tempo_comeco=D.indsample(TOI(1))
indice_tempo_fim=D.indsample(TOI(2))

dados_Time_CongIncongPseud(iSujeito,1)=mean(mean(D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,D.indtrial('Congr_time')))) %#ok<*SAGROW>
dados_Time_CongIncongPseud(iSujeito,2)=mean(mean(D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,D.indtrial('Incongr_time'))))
dados_Time_CongIncongPseud(iSujeito,3)=mean(mean(D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,D.indtrial('Pseud_time'))))

end

errorbar(1:3,mean(dados_Time_CongIncongPseud),std(dados_Time_CongIncongPseud)./sqrt(nSujeitos),'bo')
set(gca,'XTick',1:3,'XTickLabel',{'Congr_time','Incongr_time','Pseud_time'})
title ('Semantic Time')
ylabel('Amplitude (uV)')
xlabel('Condition')

repanova(dados_Time_CongIncongPseud,3)

[t_congr_incongr, p_congr_incongr] = qttest(dados_Time_CongIncongPseud(:,1), dados_Time_CongIncongPseud(:,2),1);
[t_congr_pseudo, p_congr_pseudo] = qttest(dados_Time_CongIncongPseud(:,1), dados_Time_CongIncongPseud(:,3),1);
[t_incongr_pseudo, p_incongr_pseudo] = qttest(dados_Time_CongIncongPseud(:,2), dados_Time_CongIncongPseud(:,3),1);



p_congr_incongr.*3
p_congr_pseudo.*3
p_incongr_pseudo.*3

%%
%%%Time
%// ROI=  {'Cz', 'C2', 'C4', 'CP4', 'CP2', 'CPz', 'Pz', 'P2', 'P4'} %N400
%// TOI=[0.316894 0.413668] %N400
%// ROI= {'C1', 'Cz', 'C2', 'CP2', 'CPz', 'CP1', 'P1', 'Pz', 'P2'} %P300
%// TOI=[[0.572654 0.662516] %P300


%%%Trials Time Only
for iSujeito=1:nSujeitos
D=spm_eeg_load(strcat('maespm8_',nome_arquivos{iSujeito}))
 
%// par�metros de interesse
indice_eletrodos=D.indchannel(ROI) 
indice_tempo_comeco=D.indsample(TOI(1))
indice_tempo_fim=D.indsample(TOI(2))

dados_TimeSemantic(iSujeito,1)=mean(mean(D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,D.indtrial('Congr')))) %#ok<*SAGROW>
dados_TimeSemantic(iSujeito,2)=mean(mean(D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,D.indtrial('Incongr'))))
dados_TimeSemantic(iSujeito,3)=mean(mean(D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,D.indtrial('Pseud')))) %#ok<*SAGROW>
dados_TimeSemantic(iSujeito,4)=mean(mean(D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,D.indtrial('Congr_time'))))
dados_TimeSemantic(iSujeito,5)=mean(mean(D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,D.indtrial('Incongr_time'))))
dados_TimeSemantic(iSujeito,6)=mean(mean(D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,D.indtrial('Pseud_time'))))

end

dados_Time_RegularIrregular = zeros(3*nSujeitos,2);
dados_Time_RegularIrregular(:,1) = [dados_TimeSemantic(:,1);dados_TimeSemantic(:,2);dados_TimeSemantic(:,3)];
dados_Time_RegularIrregular(:,2) = [dados_TimeSemantic(:,4);dados_TimeSemantic(:,5);dados_TimeSemantic(:,6)];

figure
errorbar(1:2,mean(dados_Time_RegularIrregular),std(dados_Time_RegularIrregular)./sqrt(nSujeitos),'bo')
set(gca,'XTick',1:2,'XTickLabel',{'Regular','Irregular'})
title ('Time Manipulation')
ylabel('Amplitude (uV)')
xlabel('Condition')


repanova(dados_Time_RegularIrregular,2)

[t_regular_irregular, p_regular_irregular] = qttest(dados_Time_RegularIrregular(:,1), dados_Time_RegularIrregular(:,2),1);

p_regular_irregular.*3

%%
%%%P300 - deferen�a entre cong/incong normal e time
%// ROI={'C1', 'Cz', 'C2', 'CP2', 'CPz', 'CP1', 'P1', 'Pz', 'P2'}
TOI= [0.503530 0.617908]

%%%
for iSujeito=1:nSujeitos
D=spm_eeg_load(strcat('maespm8_',nome_arquivos{iSujeito}))
 
%// par�metros de interesse
indice_eletrodos=D.indchannel(ROI) 
indice_tempo_comeco=D.indsample(TOI(1))
indice_tempo_fim=D.indsample(TOI(2))

dados_TimeSemantic(iSujeito,1)=mean(mean(D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,D.indtrial('Congr')))) %#ok<*SAGROW>
dados_TimeSemantic(iSujeito,2)=mean(mean(D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,D.indtrial('Incongr'))))
dados_TimeSemantic(iSujeito,3)=mean(mean(D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,D.indtrial('Pseud')))) %#ok<*SAGROW>
dados_TimeSemantic(iSujeito,4)=mean(mean(D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,D.indtrial('Congr_time'))))
dados_TimeSemantic(iSujeito,5)=mean(mean(D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,D.indtrial('Incongr_time'))))
dados_TimeSemantic(iSujeito,6)=mean(mean(D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,D.indtrial('Pseud_time'))))

end

dados_Diff_Incong_cong= zeros(6,2);
dados_Diff_Incong_cong(:,1) = [dados_TimeSemantic(:,2)-dados_TimeSemantic(:,1)];
dados_Diff_Incong_cong(:,2) = [dados_TimeSemantic(:,5)-dados_TimeSemantic(:,4)];

figure
errorbar(1:2,mean(dados_Diff_Incong_cong),std(dados_Diff_Incong_cong)./sqrt(nSujeitos),'bo')
set(gca,'XTick',1:2,'XTickLabel',{'Diff Regular','Diff Irregular'})
title ('Time Manipulation')
ylabel('Amplitude (uV)')
xlabel('Condition')


repanova(dados_Diff_Incong_cong,2)

[t_regular_irregular, p_regular_irregular] = qttest(dados_Diff_Incong_cong(:,1), dados_Diff_Incong_cong(:,2),1);

p_regular_irregular.*3

%%// Analise EEG + Comportamental

ROI={'C1', 'Cz', 'C2', 'CP2', 'CPz', 'CP1', 'P3', 'P1', 'Pz', 'P2'}
TOI=[.350 .450]

run('D:\EEG_data\dados_carlos\Versao_2\Aplica��es\dados_todos_2')

for iSujeito=1:nSujeitos
    D=spm_eeg_load(strcat('aespm8_',nome_arquivos{iSujeito}))
    
    %// par�metros de interesse
    indice_eletrodos=D.indchannel(ROI);
    indice_tempo_comeco=D.indsample(TOI(1))
    indice_tempo_fim=D.indsample(TOI(2))
    
    dados_selecionados=D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,:);
    dados_selecionados=squeeze(mean(mean(dados_selecionados)));
    
    %pega dados comportamentais
    linhas_sujeito=find(dados(:,1)==iSujeito);
    acc_temp=dados(linhas_sujeito,2)
    rt_temp=dados(linhas_sujeito,3)
    cond_temp=dados(linhas_sujeito,4)
    %trial_number=dados(linhas_sujeito,5)
    
    %// indice_trials=(cond_temp==12 & D.reject'==0) %condi��o: semi-correto, trials bons
    indice_trials=(cond_temp==12 & D.reject'==0 & acc_temp==1) %condi��o: semi-correto, trials bons e so trials onde a pessoa acertou
    
    scatter(zscore(dados_selecionados(indice_trials)),rt_temp(indice_trials)) %rela��o N400 x rt
    
    [betas(iSujeito,:), ~, stats]=glmfit(zscore(dados_selecionados(indice_trials)),rt_temp(indice_trials))
    [betas_acc(iSujeito,:), ~, stats_acc]=glmfit(zscore(dados_selecionados(indice_trials)),acc_temp(indice_trials),'binomial')
    
    t_rt(iSujeito)=stats.t(2)
    t_acc(iSujeito)=stats_acc.t(2)
    
    nBins=5;
    pBins=1./nBins;
    
    n400_data=zscore(dados_selecionados(indice_trials));
    rt_data=rt_temp(indice_trials);
    [Binis, centres(iSujeito,:)]=bini(n400_data,nBins,pBins);
    
    for iBin=1:nBins
        binned_RT(iSujeito,iBin)=mean(rt_data(Binis(:,iBin)));
    end

end
%%
[t, p]=qttest(betas(:,2),0,1) %#ok<*ASGLU>
[t, p]=qttest(betas_acc(:,2),0,1) %#ok<*NASGU>

[t, p]=qttest(t_rt',0,1)
[t, p]=qttest(t_acc',0,1)

errorbar(mean(centres),mean(binned_RT),std(binned_RT)./sqrt(nSujeitos),'bo')


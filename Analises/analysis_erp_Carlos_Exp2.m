%Data location
% cd('E:\EEG_data\dados_carlos\Mestrado\Raw_Exp2_regular\export\spm_data')
cd 'C:\Users\user\OneDrive\Documentos\EEG_DATA\Exp2\spm_data'
%%Data Conversion SPM to FT
clear
% D=spm_eeg_load('grand_mean_all') %Todos
D=spm_eeg_load('grand_mean_1') %sublimiar
% D=spm_eeg_load('grand_mean_2') %supralimiar
% D=spm_eeg_load('grand_mean_Exp2B')

ft_cong=nspm2ftrip_erp_condition(D,'Congr')
ft_incong=nspm2ftrip_erp_condition(D,'Incongr')
ft_pseud=nspm2ftrip_erp_condition(D,'Pseud')

ft_cong.time = ft_cong.time*1000
ft_incong.time = ft_incong.time*1000
ft_pseud.time = ft_pseud.time*1000

% ft_cong_time=nspm2ftrip_erp_condition(D,'Congr_time')
% ft_incong_time=nspm2ftrip_erp_condition(D,'Incongr_time')
% ft_pseud_time=nspm2ftrip_erp_condition(D,'Pseud_time')

ft_diferenca=ft_cong;
ft_diferenca.avg=ft_incong.avg-ft_cong.avg;

ft_diferenca2=ft_cong;
ft_diferenca2.avg=ft_pseud.avg-ft_cong.avg;

ft_diferenca3=ft_cong;
ft_diferenca3.avg=-(ft_pseud.avg-ft_incong.avg);


ft_diferenca4 = ft_cong;
ft_diferenca4.avg = -((ft_incong.avg+ft_cong.avg)/2 - ft_pseud.avg);
% Mean_incong = ft_cong_time;
% Mean_incong.avg = (ft_incong.avg+ft_incong_time.avg)/2;


% ft_diferenca_all = ft_cong_time;
% ft_diferenca_all.avg = Mean_regular.avg-Mean_time.avg;

ft_all=ft_cong
ft_all.avg=(ft_incong.avg+ft_cong.avg+ft_pseud.avg)./3



%% Multiplot

cfg=[]
cfg.ylim = 'maxabs'
cfg.zlim = 'maxabs'
cfg.interactive='yes'
% cfg.layout='EEG1010.lay';
cfg.layout='easycapM11.mat'
cfg.baseline = [-200 0]
%% 
%Subplot all channels individually
channels={'F3', 'F1', 'Fz', 'F2', 'F4', 'FC3', 'FC1','FC1','FC2', 'FC4',  'C3', 'C1', 'Cz', 'C2', 'C4', 'CP3', 'CP1', 'CPz','CP2', 'CP4', 'P3', 'P1', 'Pz', 'P2', 'P4'};
figure
for Ch = 1:length(channels)
cfg.channel=channels(Ch);


subplot (5,5,Ch);
ft_singleplotER(cfg,ft_cong,ft_incong,ft_pseud);

end

%Regular task
figure
ft_multiplotER(cfg,ft_cong,ft_incong,ft_pseud);

figure
ft_singleplotER(cfg,ft_cong,ft_incong,ft_pseud);

% %Incong - Cong 
figure
ft_multiplotER(cfg,ft_diferenca,ft_diferenca2);



%soma de todos
figure
ft_multiplotER(cfg,ft_all);



ylabel('Amplitude (uV)','fontsize',14)
xlabel('Time (ms)','fontsize',14)
set(gca,'fontsize',12)
title ('N400','fontsize',14)
ylim auto


title ('Congruente')
title ('Incongruente')
title ('Pseudopalavra')
title ('Diferença Pseudopalavra/Congruente')
title ('Diferença - Pseudopalavra/Incongruente')


title('Cong')
title('Incong')
title('Pseud')
%% Topoplot

cfg=[]
cfg.ylim = 'maxabs'
cfg.zlim = 'maxabs'
cfg.interactive='yes'
% cfg.layout='EEG1010.lay';
cfg.layout='easycapM11.mat'
% cfg.xlim=[0.358369 0.448230] %Time
cfg.ylim='maxabs'
cfg.baseline=[-.200 0]
% cfg.channel = {'F3', 'F1', 'Fz', 'F2', 'FC2', 'FC1', 'C1', 'Cz', 'C2'}


figure
ft_topoplotER(cfg,ft_diferenca);

figure
ft_topoplotER(cfg,ft_diferenca2);

figure
ft_topoplotER(cfg,ft_diferenca3);

figure
ft_topoplotER(cfg,ft_diferenca4);

title('Pseud-Cong')


%%

Black = [0 0 0];

%n400
% cfg.channel={'F3', 'F1', 'Fz', 'F2', 'FC2', 'FC1', 'C1', 'Cz', 'C2'}
cfg.channel={'CP2', 'CPz', 'CP1', 'P1', 'Pz', 'P2'}
TOI= [0.358369 0.448230];
% cfg.channel={'FC4', 'FC2', 'FCz', 'Cz', 'C2', 'C4', 'CP4', 'CP2', 'CPz', 'P1'}
% TOI=[422.884793 584.175115];

cfg.xlim = [-200 849]
cfg.baseline = [-200 340] 
TOI= [360 450]; 

% channels={'FXX', 'F1', 'Fz', 'F2', 'FXX', 'FC3', 'FC1','FXX','FC2', 'FC4',  'C3', 'C1', 'Cz', 'C2', 'C4', 'CP3', 'CP1', 'CPz','CP2', 'CP4', 'PXX', 'P1', 'Pz', 'P2', 'PXX'};
% channels={'F3', 'F1', 'Fz', 'F2',   'FXX', 'FC1', 'FCz', 'FC2',   'FXX', 'C1', 'Cz', 'C2'};
channels={'CP2', 'CPz', 'CP1', 'P1', 'Pz', 'P2'}
cfg.ylim = [-5 7];
cfg.linewidth = 1.5;
cfg.graphcolor = [ 'b' 'r' 'k'];

% ylim auto
for Ch = 1:length(channels)
    cfg.channel=channels(Ch);
    if  Ch~=5 && Ch~=7 && Ch~=9
        ROI = cfg.channel;
        indice_eletrodos=D.indchannel(ROI);
        figure(1)
        subplot (3,4,Ch);
        ft_singleplotER(cfg,ft_pseud,ft_incong,ft_cong);
        H1 = line(xlim,[0 0]);
        H2 = line([0 0], ylim);
        set(H1,'Color',Black,'LineWidth',.5)
        set(H2,'Color',Black,'LineWidth',.5)
        set(gca,'children',flipud(get(gca,'children')))
        title(char(channels(Ch)))
        axis off;
%         shadedErrorBar(ft_pseud.time,(ft_pseud.avg(indice_eletrodos,:)),std(ft_pseud.avg(indice_eletrodos,:))./sqrt(15),'b',.5)
%         shadedErrorBar(ft_cong.time,(ft_cong.avg(indice_eletrodos,:)),std(ft_cong.avg(indice_eletrodos,:))./sqrt(15),'k',.5)
%         shadedErrorBar(ft_incong.time,(ft_incong.avg(indice_eletrodos,:)),std(ft_incong.avg(indice_eletrodos,:))./sqrt(15),'r',.5)

    end
    if  Ch==7
        
        subplot (3,4,Ch);
        cfg.channel={'Fz', 'FC2', 'FC1', 'Cz'};
        ROI = cfg.channel;
        indice_eletrodos=D.indchannel(ROI);
        ft_singleplotER(cfg,ft_pseud,ft_incong,ft_cong);
        H1 = line(xlim,[0 0]);
        H2 = line([0 0], ylim);
        set(H1,'Color',Black,'LineWidth',.5)
        set(H2,'Color',Black,'LineWidth',.5)
        set(gca,'children',flipud(get(gca,'children')))
        title(char(channels(Ch)))
        axis off;
%         shadedErrorBar(ft_pseud.time,mean(ft_pseud.avg(indice_eletrodos,:)),std(ft_pseud.avg(indice_eletrodos,:))./sqrt(15),'b',.5)
%         shadedErrorBar(ft_cong.time,mean(ft_cong.avg(indice_eletrodos,:)),std(ft_cong.avg(indice_eletrodos,:))./sqrt(15),'k',.5)
%         shadedErrorBar(ft_incong.time,mean(ft_incong.avg(indice_eletrodos,:)),std(ft_incong.avg(indice_eletrodos,:))./sqrt(15),'r',.5)

    end
    if Ch==9
        subplot (3,4,Ch);
        cfg.channel={'F3', 'F1', 'Fz', 'F2', 'FC2', 'FC1', 'C1', 'Cz', 'C2'};
        ROI = cfg.channel;
        indice_eletrodos=D.indchannel(ROI);
        ft_singleplotER(cfg,ft_pseud, ft_incong,ft_cong);
        H1 = line(xlim,[0 0]);
        H2 = line([0 0], ylim);
        set(H1,'Color',Black,'LineWidth',.5)
        set(H2,'Color',Black,'LineWidth',.5)
        title('Mean All')
        axis on
%         shadedErrorBar(ft_pseud.time,mean(ft_pseud.avg(indice_eletrodos,:)),std(ft_pseud.avg(indice_eletrodos,:))./sqrt(15),'b',.5)
%         shadedErrorBar(ft_cong.time,mean(ft_cong.avg(indice_eletrodos,:)),std(ft_cong.avg(indice_eletrodos,:))./sqrt(15),'k',.5)
%         shadedErrorBar(ft_incong.time,mean(ft_incong.avg(indice_eletrodos,:)),std(ft_incong.avg(indice_eletrodos,:))./sqrt(15),'r',.5)

    end
    
end

title('N400')

orient landscape
print -dpdf -bestfit N400_Exp2-B.pdf

%% Error Bar + statistical test
nome_arquivos={
%     'PpA_DL2_01'
%     'PpA_DL2_02'
%     'PpA_DL2_03'
%     'PpA_DL2_04'
    'PpA_DL2_05'    %muita piscada
    'PpA_DL2_06'    %muita piscada
    'PpA_DL2_07'
%     'PpA_DL2_08' %eletrodos invertidos
    'PpA_DL2_09'
    'PpA_DL2_10' %refazer pre-processamento no analyzer (eletrodo com falha)
    'PpA_DL2_11'
    'PpA_DL2_12'
    'PpA_DL2_13'
    'PpA_DL2_14'
    'PpA_DL2_15'
    'PpA_DL2_16'
    'PpA_DL2_17'
    'PpA_DL2_18'
    'PpA_DL2_19'
    'PpA_DL2_20'
         }

nSujeitos=size(nome_arquivos,1)

ft_cong.time = ft_cong.time/1000
ft_incong.time = ft_incong.time/1000
ft_pseud.time = ft_pseud.time/1000

%N400
% ROI={'C1', 'Cz', 'C2', 'CP2', 'CPz', 'CP1', 'P1', 'Pz', 'P2'}
% ROI={'F3', 'F1', 'Fz', 'F2', 'FC2', 'FC1', 'C1', 'Cz', 'C2'}
ROI={'CP2', 'CPz', 'CP1', 'P1', 'Pz', 'P2'}
TOI= [360 450]/1000%[0.358369 0.448230]


%N400 Frontal
ROI={'F1', 'Fz', 'F2', 'F4', 'FC2', 'FC1', 'C1', 'Cz', 'C2'}
TOI= [0.303069 0.457447]


%P3a
ROI={'AF7', 'AF3', 'AFz', 'AF4', 'F3', 'F1', 'Fz', 'F2', 'F4'}
TOI= [0.389166 0.497228]

%P3b
ROI={ 'CP2', 'CPz', 'CP1', 'P1', 'Pz', 'P2', 'PO4', 'POz', 'PO3'}
TOI=  [0.505124 0.562381]


%P1
ROI={'PO8', 'PO7', 'O1', 'O2','P7', 'P8'}
TOI= [0.070350 0.132562]

%N310
ROI={'F3', 'F1', 'Fz', 'F2', 'FC2', 'FC1', 'FC3', 'C1', 'Cz', 'C2'}
TOI= [297.460916 352.716981]/1000

%%
for iSujeito=1:nSujeitos
D=spm_eeg_load(strcat('maespm8_',nome_arquivos{iSujeito}));

% parÂmetros de interesse
indice_eletrodos=D.indchannel(ROI);
indice_tempo_comeco=D.indsample(TOI(1));
indice_tempo_fim=D.indsample(TOI(2));

dados_CongIncongPseud(iSujeito,1)=mean(mean(D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,D.indtrial('Congr')))); %#ok<*SAGROW>
dados_CongIncongPseud(iSujeito,2)=mean(mean(D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,D.indtrial('Incongr'))));
dados_CongIncongPseud(iSujeito,3)=mean(mean(D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,D.indtrial('Pseud'))));

end

figure
errorbar(1:3,mean(dados_CongIncongPseud),std(dados_CongIncongPseud)./sqrt(nSujeitos),'bo')
set(gca,'XTick',1:3,'fontsize',12, 'XTickLabel',{'Cong','Incong','Pseud'})
ylabel('Amplitude (uV)','fontsize',14)
title ('Error bar','fontsize',14)


repanova(dados_CongIncongPseud,3)

[t_congr_incongr, p_congr_incongr] = qttest(dados_CongIncongPseud(:,1), dados_CongIncongPseud(:,2),1);
[t_congr_pseudo, p_congr_pseudo] = qttest(dados_CongIncongPseud(:,1), dados_CongIncongPseud(:,3),1);
[t_incongr_pseudo, p_incongr_pseudo] = qttest(dados_CongIncongPseud(:,2), dados_CongIncongPseud(:,3),1);

p_congr_incongrCorr =p_congr_incongr.*3
p_congr_pseudoCorr=p_congr_pseudo.*3
p_incongr_pseudoCorr=p_incongr_pseudo.*3

%% Analise EEG + Comportamental

ROI={'C1', 'Cz', 'C2', 'CP2', 'CPz', 'CP1', 'P3', 'P1', 'Pz', 'P2'}
TOI=[.350 .450]

run('D:\EEG_data\dados_carlos\Versao_2\Aplicações\dados_todos_2')

for iSujeito=1:nSujeitos
    D=spm_eeg_load(strcat('aespm8_',nome_arquivos{iSujeito}))
    
    % parÂmetros de interesse
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
    
    % indice_trials=(cond_temp==12 & D.reject'==0) %condição: semi-correto, trials bons
    indice_trials=(cond_temp==12 & D.reject'==0 & acc_temp==1) %condição: semi-correto, trials bons e so trials onde a pessoa acertou
    
    scatter(zscore(dados_selecionados(indice_trials)),rt_temp(indice_trials)) %relação N400 x rt
    
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


%% Figura igual Exp 1
Grey = [.9 .9 .9];
Black = [0 0 0];


%n400
cfg.channel={'CP2', 'CPz', 'CP1', 'P1', 'Pz', 'P2'}%{'F1', 'Fz', 'F2', 'FC2', 'FC1', 'C1', 'Cz', 'C2'}
% cfg.channel={'CP4', 'CP2', 'CPz', 'CP1', 'P1', 'Pz', 'P2', 'P4', 'PO4', 'POz'}
cfg.xlim = [-200 850]
cfg.baseline = [-200 0] 
TOI= [350 450]; 

channels={'FXX', 'CP2', 'CPz', 'CP1', 'FXX','P1', 'Pz', 'P2'};
% cfg.ylim = [-3 11];
cfg.linewidth = 1.5;
cfg.graphcolor = ['k' 'r' 'b' ];

ylim auto
% 
for Ch = 1:length(channels)
    cfg.channel=channels(Ch);
    
    if Ch~=1 && Ch~=5
        figure(1)
        subplot (2,4,Ch);
        cfg.graphcolor = ['b' 'r' 'k' ];
        ft_singleplotER(cfg,ft_pseud,ft_incong,ft_cong);
        H1 = line(xlim,[0 0]);
        H2 = line([0 0], ylim);
        set(H1,'Color',Black,'LineWidth',.5)
        set(H2,'Color',Black,'LineWidth',.5)
        set(gca,'children',flipud(get(gca,'children')))
        xlim ([-150 850]);
        title(char(channels(Ch)))
        axis off
                      

    end
    
    if Ch==5
        cfg.channel={'CP2', 'CPz', 'CP1', 'P1', 'Pz', 'P2'};
        ROI = cfg.channel;
        indice_eletrodos=D.indchannel(ROI);
        figure(1)
        subplot (2,4,Ch);
        ft_singleplotER(cfg,ft_pseud,ft_incong,ft_cong);
        H1 = line(xlim,[0 0]);
        H2 = line([0 0], ylim);
        set(H1,'Color',Black,'LineWidth',.5)
        set(H2,'Color',Black,'LineWidth',.5)
        xlim ([-150 850]);
        title('Mean All')
        axis on
        
        
    end 
end
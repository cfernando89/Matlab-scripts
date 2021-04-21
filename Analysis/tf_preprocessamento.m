
cd('D:\EEG_data\dados_carlos\Versao_2\Pre_processamento\spm_data')

nome_arquivos={
    'tf_LEX_G1_01' %//    24%// rejeitado
    'tf_LEX_G1_02'
    'tf_LEX_G1_03'
    'tf_LEX_G1_04' %//    50%// trials rejeitados->melhoramos para 21%//    
    'tf_LEX_G1_05'    
    'tf_LEX_G2_01'
%//     'pp_LEX_G2_02' %- dados exclu�dos
    'tf_LEX_G2_03' %//    27%// rejeitados
    'tf_LEX_G2_04'
    'tf_LEX_G2_05'
    'tf_LEX_G2_06'
    'tf_LEX_G3_01'
%//     'pp_LEX_G3_02' %- dados exclu�dos
    'tf_LEX_G3_03'
    'tf_LEX_G3_04'    
    'tf_LEX_G3_05'   
    'tf_LEX_G3_06' 
    
    }

nome_arquivos_limpo={
    'aespm8_pp_LEX_G1_01' %//    24%// rejeitado
    'aespm8_pp_LEX_G1_02'
    'aespm8_pp_LEX_G1_03'
    'aespm8_pp_LEX_G1_04' %//    50%// trials rejeitados->melhoramos para 21%//    
    'aespm8_pp_LEX_G1_05'    
    'aespm8_pp_LEX_G2_01'
%//     'pp_LEX_G2_02' %- dados exclu�dos
    'aespm8_pp_LEX_G2_03' %//    27%// rejeitados
    'aespm8_pp_LEX_G2_04'
    'aespm8_pp_LEX_G2_05'
    'aespm8_pp_LEX_G2_06'
    'aespm8_pp_LEX_G3_01'
%//     'pp_LEX_G3_02' %- dados exclu�dos
    'aespm8_pp_LEX_G3_03'
    'aespm8_pp_LEX_G3_04'    
    'aespm8_pp_LEX_G3_05'   
    'aespm8_pp_LEX_G3_06' 
    
    }

nSujeitos=size(nome_arquivos,1)
%%

diretorio_exportados='D:\EEG_data\dados_carlos\Versao_2\Pre_processamento\export'

for iSujeito=1:nSujeitos    
    S = [];
    S.dataset =strcat(diretorio_exportados,nome_arquivos{iSujeito},'.dat')
    S.outfile = strcat('spm8_',nome_arquivos{iSujeito})
    S.channels = 'all';
    S.timewindow = [0.004 140.224];;
    S.blocksize = 3276800;
    S.checkboundary = 1;
    S.usetrials = 1;
    S.datatype = 'float32-le';
    S.eventpadding = 0;
    S.saveorigheader = 0;
    S.conditionlabel = {'Undefined'};
    S.inputformat = [];
    S.continuous = true;
    D = spm_eeg_convert(S);    
end

%%
%//epoca os dados
for iSujeito=1:nSujeitos  

S = [];
S.D = strcat('spm8_',nome_arquivos{iSujeito})
S.fsample = 250;
S.timeonset = 0;
S.bc = 1;
S.inputformat = [];
S.pretrig = -240;
S.posttrig = 980;
S.trialdef(1).conditionlabel = 'cor';
S.trialdef(1).eventtype = 'Stimulus';
S.trialdef(1).eventvalue = {'S 11'};
S.trialdef(2).conditionlabel = 'incor';
S.trialdef(2).eventtype = 'Stimulus';
S.trialdef(2).eventvalue = {'S 13'};
S.trialdef(3).conditionlabel = 'semi';
S.trialdef(3).eventtype = 'Stimulus';
S.trialdef(3).eventvalue = {'S 12'};
S.trialdef(4).conditionlabel = 'filler';
S.trialdef(4).eventtype = 'Stimulus';
S.trialdef(4).eventvalue = {'S 10'};
S.reviewtrials = 0;
S.save = 0;
S.epochinfo.padding = 0;
D = spm_eeg_epochs(S);

end

%%

nome_final=char(nome_arquivos)
nome_final=nome_final(:,end-4:end)

for iSujeito=1:nSujeitos
D=spm_eeg_load(strcat('espm8_',nome_arquivos{iSujeito}));
ft_data=nspm2ftrip_erp_single_trials(D);

prepad=252/4
postpad=0

nTrials=(size(D,3))

data_temp=[]
for iTrial=1:nTrials
data_temp(iTrial,:,:)=ft_preproc_padding(squeeze(ft_data.trial(iTrial,:,:)), 'zero', prepad, postpad) ;   
end
    
ft_data.trial=data_temp;
ft_data.time=D.time(1)-.252:1/250:D.time(end);
    
cfg=[];
cfg.method='wavelet';
cfg.output='pow';
cfg.channel={'all', '-HEOG','-VEOG'};
cfg.keeptrials='yes';
cfg.toi=-.250:0.020:D.time(end);
cfg.foi=logspace(log10(2),log10(40),40)
cfg.width=linspace(1,10,40)

tic
data_TF = ft_freqanalysis(cfg, ft_data);
toc

data_TF.powspctrm=log10(data_TF.powspctrm);
save(strcat('freq_power_',nome_final(iSujeito,:),'.mat'),'data_TF')
    

end
%%

%//rejeitar trials

nome_final=char(nome_arquivos)
nome_final=nome_final(:,end-4:end)

for iSujeito=1:nSujeitos
load(strcat('freq_power_',nome_final(iSujeito,:)))

D=spm_eeg_load(nome_arquivos_limpo{iSujeito})


cfg=[]
cfg.baseline=[-.1 0]
data_TF = ft_freqbaseline(cfg, data_TF)

cfg=[]
cfg.trials=D.reject==0 & ismember(D.conditions,'cor')
ft_correto = ft_freqdescriptives(cfg, data_TF)
save(strcat('freq_cor_',nome_final(iSujeito,:)),'ft_correto')

cfg=[]
cfg.trials=D.reject==0 & ismember(D.conditions,'incor')
ft_incorreto = ft_freqdescriptives(cfg, data_TF)
save(strcat('freq_incor_',nome_final(iSujeito,:)),'ft_incorreto')

cfg=[]
cfg.trials=D.reject==0 & ismember(D.conditions,'semi')
ft_semi = ft_freqdescriptives(cfg, data_TF)
save(strcat('freq_semi_',nome_final(iSujeito,:)),'ft_semi')

end

%%
%//comecar aqui
cfg_Gavg = [];
cfg_Gavg.keepindividual='yes'
cfg_Gavg.inputfile = {
   'freq_cor_G1_01.mat'
    'freq_cor_G1_02.mat'
    'freq_cor_G1_03.mat'
    'freq_cor_G1_04.mat'
    'freq_cor_G1_05.mat'
    'freq_cor_G2_01.mat'
%//     'freq_cor_G2_02.mat'
    'freq_cor_G2_03.mat'
    'freq_cor_G2_04.mat'
    'freq_cor_G2_05.mat'
    'freq_cor_G2_06.mat'
    'freq_cor_G3_01.mat'
%//     'freq_cor_G3_02.mat'
    'freq_cor_G3_03.mat'
    'freq_cor_G3_04.mat'
    'freq_cor_G3_05.mat'
    'freq_cor_G3_06.mat'
    }
Gavg_Cor= ft_freqgrandaverage(cfg_Gavg)

cfg_Gavg = [];
cfg_Gavg.keepindividual='yes'
cfg_Gavg.inputfile = {
   'freq_incor_G1_01.mat'
    'freq_incor_G1_02.mat'
    'freq_incor_G1_03.mat'
    'freq_incor_G1_04.mat'
    'freq_incor_G1_05.mat'
    'freq_incor_G2_01.mat'
%//     'freq_incor_G2_02.mat'
    'freq_incor_G2_03.mat'
    'freq_incor_G2_04.mat'
    'freq_incor_G2_05.mat'
    'freq_incor_G2_06.mat'
    'freq_incor_G3_01.mat'
%//     'freq_incor_G3_02.mat'
    'freq_incor_G3_03.mat'
    'freq_incor_G3_04.mat'
    'freq_incor_G3_05.mat'
    'freq_incor_G3_06.mat'
    }
Gavg_Incor= ft_freqgrandaverage(cfg_Gavg)

cfg_Gavg = [];
cfg_Gavg.keepindividual='yes'
cfg_Gavg.inputfile = {
   'freq_semi_G1_01.mat'
    'freq_semi_G1_02.mat'
    'freq_semi_G1_03.mat'
    'freq_semi_G1_04.mat'
    'freq_semi_G1_05.mat'
    'freq_semi_G2_01.mat'
%//     'freq_semi_G2_02.mat'
    'freq_semi_G2_03.mat'
    'freq_semi_G2_04.mat'
    'freq_semi_G2_05.mat'
    'freq_semi_G2_06.mat'
    'freq_semi_G3_01.mat'
%//     'freq_semi_G3_02.mat'
    'freq_semi_G3_03.mat'
    'freq_semi_G3_04.mat'
    'freq_semi_G3_05.mat'
    'freq_semi_G3_06.mat'
    }
Gavg_Semi= ft_freqgrandaverage(cfg_Gavg)

%%
%// data=Gavg_Incor;
data=Gavg_Cor;
data.powspctrm=Gavg_Incor.powspctrm-Gavg_Cor.powspctrm;



cfg=[];
cfg.layout='easycapM11.mat'
%// cfg.highlightchannel={'PO8', 'PO4', 'POz', 'PO3', 'POe7'}
cfg.interactive = 'yes';
%// cfg.highlightsize=8
%// cfg.shading='interp'
%// cfg.highlight='on'
%// cfg.marker='labels'
%// cfg.xlim = [.180 .280]
%// cfg.xlim = [.450 .550]
%// cfg.shading='interp'
cfg.zlim = 'maxabs'
cfg.zlim = [-.15 .15]
%// cfg.baselinetype = 'absolute';
%// cfg.baseline = [-.250 0];
figure
ft_multiplotTFR(cfg,data);
%// ft_multiplotER(cfg,grandavg_left_1,grandavg_left_6);
%// ft_topoplotER(cfg,data)


%%
cfg=[]
cfg.ylim = 'maxabs'
cfg.zlim = 'maxabs'
cfg.interactive='yes'
%// cfg.layout='EEG1010.lay';
cfg.layout='easycapM11.mat'

figure
%// ft_multiplotER(cfg,ft_cor,ft_incor,ft_semi)
ft_multiplotER(cfg,ft_diferenca)

%%
cfg=[]
cfg.ylim = 'maxabs'
cfg.zlim = 'maxabs'
cfg.interactive='yes'
%// cfg.layout='EEG1010.lay';
cfg.layout='easycapM11.mat'
cfg.xlim=[.25 .35]
cfg.ylim='maxabs'
cfg.baseline=[.200 .250]

figure
ft_topoplotER(cfg,ft_diferenca)

%%
ROI={'Cz', 'C2', 'C4', 'CP4', 'CP2', 'CPz', 'Pz'}
TOI=[.350 .450]

for iSujeito=1:nSujeitos
D=spm_eeg_load(strcat('maespm8_',nome_arquivos{iSujeito}))

%// par�metros de interesse
indice_eletrodos=D.indchannel(ROI); 
indice_tempo_comeco=D.indsample(TOI(1))
indice_tempo_fim=D.indsample(TOI(2))

dados_CorSemiIncor(iSujeito,1)=mean(mean(D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,D.indtrial('cor'))))
dados_CorSemiIncor(iSujeito,2)=mean(mean(D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,D.indtrial('semi'))))
dados_CorSemiIncor(iSujeito,3)=mean(mean(D(indice_eletrodos,indice_tempo_comeco:indice_tempo_fim,D.indtrial('incor'))))

end

errorbar(1:3,mean(dados_CorSemiIncor),std(dados_CorSemiIncor)./sqrt(nSujeitos),'bo')
set(gca,'XTick',[1:3],'XTickLabel',{'Cor','Semi','Incor'})

repanova(dados_CorSemiIncor,3)

[t_correto_incorreto p_correto_incorreto]=qttest(dados_CorSemiIncor(:,1),dados_CorSemiIncor(:,3),1);
[t_correto_semicorreto p_correto_semicorreto]=qttest(dados_CorSemiIncor(:,1),dados_CorSemiIncor(:,2),1);
[t_incorreto_semicorreto p_incorreto_semicorreto]=qttest(dados_CorSemiIncor(:,3),dados_CorSemiIncor(:,2),1);

p_correto_incorreto.*3
p_correto_semicorreto.*3
p_incorreto_semicorreto.*3

%%
ROI={'F3', 'F1', 'Fz', 'F2', 'F4', 'FC2', 'FCz', 'FC1', 'FC3', 'C3', 'C1', 'Cz', 'C2'}
TOI=[.250 .350]

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

indice_trials=(cond_temp==12 & D.reject'==0) %condi��o: semi-correto, trials bons

scatter(zscore(dados_selecionados(indice_trials)),rt_temp(indice_trials)) %rela��o N400 x rt

[betas(iSujeito,:), ~, stats]=glmfit(zscore(dados_selecionados(indice_trials)),rt_temp(indice_trials))
[betas_acc(iSujeito,:), ~, stats_acc]=glmfit(zscore(dados_selecionados(indice_trials)),acc_temp(indice_trials),'binomial')

t_rt(iSujeito)=stats.t(2)
t_acc(iSujeito)=stats_acc.t(2)

end

[t p]=qttest(betas(:,2),0,1)
[t p]=qttest(betas_acc(:,2),0,1)

[t p]=qttest(t_rt',0,1)
[t p]=qttest(t_acc',0,1)





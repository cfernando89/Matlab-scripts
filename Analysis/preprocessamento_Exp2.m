
clear all

%// cd('E:\EEG_data\dados_carlos\Mestrado\Raw_Exp2_regular\export\spm_data')
cd('E:\EEG_DATA\Exp2\spm_data')

nome_arquivos={
%//     'PpA_DL2_01'
%//     'PpA_DL2_02'
%//     'PpA_DL2_03'
%//     'PpA_DL2_04'
%//     'PpA_DL2_05'    %muita piscada
%//     'PpA_DL2_06'    %muita piscada
%//     'PpA_DL2_07'
%//     'PpA_DL2_08' %eletrodos invertidos
%//     'PpA_DL2_09'
%// %//     'PpA_DL2_10' %refazer pre-processamento no analyzer (eletrodo com falha)
%//     'PpA_DL2_11'
%//     'PpA_DL2_12'
%//     'PpA_DL2_13'
%//     'PpA_DL2_14'
%//     'PpA_DL2_15'
%//     'PpA_DL2_16'
%//     'PpA_DL2_17'
    'PpA_DL2_18'
    'PpA_DL2_19'
    'PpA_DL2_20'
         }

nSujeitos=size(nome_arquivos,1)
%%// Data Conversion Analyser to SPM8

%// diretorio_exportados='E:\EEG_data\dados_carlos\Mestrado\Raw_Exp2_regular\export'
diretorio_exportados='E:\EEG_DATA\Exp2\spm_data';
for iSujeito=1:nSujeitos %// 06 tem que fazer manualmente
    iSujeito
    
    S = [];
    S.dataset = strcat(diretorio_exportados,nome_arquivos{iSujeito},'.dat');
    S.outfile = strcat('spm8_',nome_arquivos{iSujeito});
    S.channels = 'all';
    S.timewindow = [0.004 720];
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
'end'

%%// epoch data

for iSujeito=1:nSujeitos
    iSujeito
    
    S = [];
    S.D = strcat('spm8_',nome_arquivos{iSujeito})
    S.fsample = 250;
    S.timeonset = 0;
    S.bc = 1;
    S.inputformat = [];
    S.pretrig = -150;
    S.posttrig = 850;
    S.trialdef(1).conditionlabel = 'Congr';
    S.trialdef(1).eventtype = 'Stimulus';
    S.trialdef(1).eventvalue = {'S 12'};
    S.trialdef(2).conditionlabel = 'Incongr';
    S.trialdef(2).eventtype = 'Stimulus';
    S.trialdef(2).eventvalue = {'S 14'};
    S.trialdef(3).conditionlabel = 'Pseud';
    S.trialdef(3).eventtype = 'Stimulus';
    S.trialdef(3).eventvalue = {'S 16'};
    S.reviewtrials = 0;
    S.save = 0;
    S.epochinfo.padding = 0;
    D = spm_eeg_epochs(S);
    
end
'end'

%%// reject trials / Look for bad channel

for iSujeito=1:nSujeitos
    iSujeito
    
    S = [];
    S.D = strcat('espm8_',nome_arquivos{iSujeito});
    S.badchanthresh = 0.8;
    S.methods.channels = {'all'};
    S.methods.fun = 'threshchan';
    S.methods.settings.threshold = 100;
    
    D = spm_eeg_artefact(S);   
end

'end'

%%// media artefato

media_artefato = [];
for iSujeito=1:nSujeitos
    
    D = spm_eeg_load(strcat('aespm8_',nome_arquivos{iSujeito}));
    media_artefato(iSujeito) = mean(D.reject);
    
end
media_artefato %#ok<*NOPTS>

%%
for iSujeito=1:nSujeitos
    iSujeito
    
    S = [];
    S.D = strcat('aespm8_',nome_arquivos{iSujeito});
    S.robust = false;
    D = spm_eeg_average(S);
    
end

%// close all
'end'

%%// Grand Mean
S = [];
S.D = [
%//     'maespm8_PpA_DL2_01.mat'
%//     'maespm8_PpA_DL2_02.mat'  
%//     'maespm8_PpA_DL2_03.mat'
%//     'maespm8_PpA_DL2_04.mat'
    'maespm8_PpA_DL2_05.mat'  
    'maespm8_PpA_DL2_06.mat'
    'maespm8_PpA_DL2_07.mat'
%//     'maespm8_PpA_DL2_08.mat'
    'maespm8_PpA_DL2_09.mat'
    'maespm8_PpA_DL2_10.mat'
'maespm8_PpA_DL2_11.mat'
'maespm8_PpA_DL2_12.mat'
'maespm8_PpA_DL2_13.mat'
'maespm8_PpA_DL2_14.mat'
'maespm8_PpA_DL2_15.mat'
'maespm8_PpA_DL2_16.mat'
'maespm8_PpA_DL2_17.mat'
'maespm8_PpA_DL2_18.mat'
'maespm8_PpA_DL2_19.mat'
'maespm8_PpA_DL2_20.mat'


%//     'maespm8_PpA_DL_01.mat'
%//     'maespm8_PpA_DL_02.mat'  
%//     'maespm8_PpA_DL_03.mat'
%//     'maespm8_PpA_DL_04.mat'
%//     'maespm8_PpA_DL_05.mat'  
%//     'maespm8_PpA_DL_06.mat'

    ];

S.Dout = 'grand_mean_Exp2B.mat';
S.weighted = 0;
D = spm_eeg_grandmean(S);

close all
'Finished'


%Este é o Script o qual deve ser rodado para execução de testes com os
%algoritmos 1-NN, ICF, E-NN, DROP3, HMN-C, HMN-E, HMN-EI
% As bases a serem testadas estão divididas em grupos
% O grupo mais rápido para se rodar é o grupo 1, o grupo é definido pela
% variável 'grupo' logo abaixo.
% Ao fim do script será rodada a função compResults que executará as
% métricas de performance e avalição. A tabela semelhante a tabela com
% todas as bases que está no relatório é guardada no arquivo
% /am2/tabela.txt

n_runs = 10; %1~10
grupo = 1; %1~4

%UCI
ecoli = 0;
segmentation = 0;
breastc = 0;
irisd = 0;
wbreastc = 0;
bupad = 0;
diabete = 0;

%Raetsch
banana1 = 0;
breast_cancer1 = 0;
diabetis1 = 0;
heart1 = 0;
flare_solar1 = 0;%d
german1 = 0;
splice1 = 0;
im1 = 0; %image
ringnorm1 = 0;
twonorm1 = 0;
thyroid1 = 0;
titanic1 = 0;
waveform1 = 0;

%Chapelle 
coil20 = 0;
textdata = 0;
g50 = 0;
g10 = 0;
usps = 0;
tempohmn = 0;
temporesto = 0;

nomebase = '';

if(grupo == 1)
    disp('******** Base Ecoli **********');
    ecoli = 1;
    nomebase = 'ecoli';
    ExecutarTestes;
    ecoli = 0;
    disp('******** Base Breastc **********');
    breastc = 1;
    nomebase = 'breastc';
    ExecutarTestes;
    breastc = 0;
    disp('******** Base Iris **********');
    irisd = 1;
    nomebase = 'irisd';
    ExecutarTestes;
    irisd = 0;
    disp('******** Base Wbreast **********');
    wbreastc = 1;
    nomebase = 'wbreastc';
    ExecutarTestes;
    wbreastc = 0;
    disp('******** Base Bupa **********');
    bupad = 1;
    nomebase = 'bupad';
    ExecutarTestes;
    bupad = 0;
    disp('******** Base Pima/Diabete **********');
    diabete = 1;
    nomebase = 'diabete';
    ExecutarTestes;
    diabete = 0;
elseif(grupo == 2)
    disp('******** Base Segmentation **********');
    segmentation = 1;
    nomebase = 'segmentation';
    ExecutarTestes;
    segmentation = 0;
    disp('******** Base Banana **********');
    banana1 = 1;
    nomebase = 'banana1';
    ExecutarTestes;
    banana1 = 0;
    disp('******** Base Breast Cancer **********');
    breast_cancer1 = 1;
    nomebase = 'breast_cancer1';
    ExecutarTestes;
    breast_cancer1 = 0;
    disp('******** Base Diabetis **********');
    diabetis1 = 1;
    nomebase = 'diabetis1';
    ExecutarTestes;
    diabetis1 = 0;
    disp('******** Base Heart **********');
    heart1 = 1;
    nomebase = 'heart1';
    ExecutarTestes;
    heart1 = 0;
    disp('******** Base Flare Solar **********');
    flare_solar1 = 1;
    nomebase = 'flare_solar1';
    ExecutarTestes;
    flare_solar1 = 0;
    disp('******** Base German **********');
    german1 = 1;
    nomebase = 'german1';
    ExecutarTestes;
    german1 = 0;
    disp('******** Base Splice **********');
    splice1 = 1;
    nomebase = 'splice1';
    ExecutarTestes;
    splice1 = 0;
elseif(grupo == 3)
    disp('******** Base Image **********');
    im1 = 1;
    nomebase = 'im1';
    ExecutarTestes;
    im1 = 0;
    disp('******** Base Ringnorm **********');
    ringnorm1 = 1;
    nomebase = 'ringnorm1';
    ExecutarTestes;
    ringnorm1 = 0;
    disp('******** Base Twonorm **********');
    twonorm1 = 1;
    nomebase = 'twonorm1';
    ExecutarTestes;
    twonorm1 = 0;
    disp('******** Base Thyroid **********');
    thyroid1 = 1;
    nomebase = 'thyroid1';
    ExecutarTestes;
    thyroid1 = 0;
    disp('******** Base Titanic **********');
    titanic1 = 1;
    nomebase = 'titanic1';
    ExecutarTestes;
    titanic1 = 0;
    disp('******** Base Waveform **********');
    waveform1 = 1;
    nomebase = 'waveform1';
    ExecutarTestes;
    waveform1 = 0;
else
    disp('******** Base Coil20 **********');
    coil20 = 1;
    nomebase = 'coil20';
    ExecutarTestes;
    coil20 = 0;
    disp('******** Base Textdata **********');
    textdata = 1;
    nomebase = 'textdata';
    ExecutarTestes;
    textdata = 0;
    disp('******** Base G50 **********');
    g50 = 1;
    nomebase = 'g50';
    ExecutarTestes;
    g50 = 0;
    disp('******** Base G10 **********');
    g10 = 1;
    nomebase = 'g10';
    ExecutarTestes;
    g10 = 0;
    disp('******** Base USPS **********');
    usps = 1;
    nomebase = 'usps';
    ExecutarTestes;
    usps = 0;
end

a = {'banana', 'breast cancer', 'breastc', 'bupad', 'coil20', 'diabetis', 'ecoli', 'flare_solar', 'g10', 'g50', 'german', 'heart', 'image', 'irisd', 'pima', 'ringnorm', 'segmentation', 'splice', 'textdata', 'thyroid', 'titanic', 'twonorm', 'usps', 'waveform', 'wbreastc'};
cd am2
compResults(a);
cd ..
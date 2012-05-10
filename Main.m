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
if(grupo == 1)
    disp('******** Base Ecoli **********');
    ecoli = 1;
    Executar;
    ecoli = 0;
    disp('******** Base Breastc **********');
    breastc = 1;
    Executar;
    breastc = 0;
    disp('******** Base Iris **********');
    irisd = 1;
    Executar;
    irisd = 0;
    disp('******** Base Wbreast **********');
    wbreastc = 1;
    Executar;
    wbreastc = 0;
    disp('******** Base Bupa **********');
    bupad = 1;
    Executar;
    bupad = 0;
    disp('******** Base Pima/Diabete **********');
    diabete = 1;
    Executar;
    diabete = 0;
elseif(grupo == 2)
    disp('******** Base Segmentation **********');
    segmentation = 1;
    Executar;
    segmentation = 0;
    disp('******** Base Banana **********');
    banana1 = 1;
    Executar;
    banana1 = 0;
    disp('******** Base Breast Cancer **********');
    breast_cancer1 = 1;
    Executar;
    breast_cancer1 = 0;
    disp('******** Base Diabetis **********');
    diabetis1 = 1;
    Executar;
    diabetis1 = 0;
    disp('******** Base Heart **********');
    heart1 = 1;
    Executar;
    heart1 = 0;
    disp('******** Base Flare Solar **********');
    flare_solar1 = 1;
    Executar;
    flare_solar1 = 0;
    disp('******** Base German **********');
    german1 = 1;
    Executar;
    german1 = 0;
    disp('******** Base Splice **********');
    splice1 = 1;
    Executar;
    splice1 = 0;
elseif(grupo == 3)
    disp('******** Base Image **********');
    im1 = 1;
    Executar;
    im1 = 0;
    disp('******** Base Ringnorm **********');
    ringnorm1 = 1;
    Executar;
    ringnorm1 = 0;
    disp('******** Base Twonorm **********');
    twonorm1 = 1;
    Executar;
    twonorm1 = 0;
    disp('******** Base Thyroid **********');
    thyroid1 = 1;
    Executar;
    thyroid1 = 0;
    disp('******** Base Titanic **********');
    titanic1 = 1;
    Executar;
    titanic1 = 0;
    disp('******** Base Waveform **********');
    waveform1 = 1;
    Executar;
    waveform1 = 0;
else
    disp('******** Base Coil20 **********');
    coil20 = 1;
    Executar;
    coil20 = 0;
    disp('******** Base Textdata **********');
    textdata = 1;
    Executar;
    textdata = 0;
    disp('******** Base G50 **********');
    g50 = 1;
    Executar;
    g50 = 0;
    disp('******** Base G10 **********');
    g10 = 1;
    Executar;
    g10 = 0;
    disp('******** Base USPS **********');
    usps = 1;
    Executar;
    usps = 0;
end

%a = {'banana', 'breast cancer', 'breastc', 'bupad', 'coil20', 'diabetis', 'ecoli', 'flare_solar', 'g10', 'g50', 'german', 'heart', 'image', 'irisd', 'pima', 'ringnorm', 'segmentation', 'splice', 'textdata', 'thyroid', 'titanic', 'twonorm', 'usps', 'waveform', 'wbreastc'}
    
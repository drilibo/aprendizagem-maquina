more_runs = 1;%0~1
grupo = 4; %1~4

irisd = 0;
wbreastc = 0;
bupad = 0;
diabete = 0;

%%Datasets http://theoval.sys.uea.ac.uk/matlab/default.html#benchmarks
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

%%Datasets http://www.kyb.tuebingen.mpg.de/bs/people/chapelle/lds/
coil20 = 0;
textdata = 0;
g50 = 0;
g10 = 0;
usps = 0;

if(grupo == 1)
    disp('******** Base Iris **********');
    irisd = 1;
    HMN_CE_fast;
    irisd = 0;
    disp('******** Base Wbreast **********');
    wbreastc = 1;
    HMN_CE_fast;
    wbreastc = 0;
    disp('******** Base Bupa **********');
    bupad = 1;
    HMN_CE_fast;
    bupad = 0;
    disp('******** Base Pima/Diabete **********');
    diabete = 1;
    HMN_CE_fast;
    diabete = 0;
elseif(grupo == 2)
    disp('******** Base Banana **********');
    banana1 = 1;
    HMN_CE_fast;
    banana1 = 0;
    disp('******** Base Breast Cancer **********');
    breast_cancer1 = 1;
    HMN_CE_fast;
    breast_cancer1 = 0;
    disp('******** Base Diabetis **********');
    diabetis1 = 1;
    HMN_CE_fast;
    diabetis1 = 0;
    disp('******** Base Heart **********');
    heart1 = 1;
    HMN_CE_fast;
    heart1 = 0;
    disp('******** Base Flare Solar **********');
    flare_solar1 = 1;
    HMN_CE_fast;
    flare_solar1 = 0;
    disp('******** Base German **********');
    german1 = 1;
    HMN_CE_fast;
    german1 = 0;
    disp('******** Base Splice **********');
    splice1 = 1;
    HMN_CE_fast;
    splice1 = 0;
elseif(grupo == 3)
    disp('******** Base Image **********');
    im1 = 1;
    HMN_CE_fast;
    im1 = 0;
    disp('******** Base Ringnorm **********');
    ringnorm1 = 1;
    HMN_CE_fast;
    ringnorm1 = 0;
    disp('******** Base Twonorm **********');
    twonorm1 = 1;
    HMN_CE_fast;
    twonorm1 = 0;
    disp('******** Base Thyroid **********');
    thyroid1 = 1;
    HMN_CE_fast;
    thyroid1 = 0;
    disp('******** Base Titanic **********');
    titanic1 = 1;
    HMN_CE_fast;
    titanic1 = 0;
    disp('******** Base Waveform **********');
    waveform1 = 1;
    HMN_CE_fast;
    waveform1 = 0;
else
    disp('******** Base Coil20 **********');
    coil20 = 1;
    HMN_CE_fast;
    coil20 = 0;
    disp('******** Base Textdata **********');
    textdata = 1;
    HMN_CE_fast;
    textdata = 0;
    disp('******** Base G50 **********');
    g50 = 1;
    HMN_CE_fast;
    g50 = 0;
    disp('******** Base G10 **********');
    g10 = 1;
    HMN_CE_fast;
    g10 = 0;
    disp('******** Base USPS **********');
    usps = 1;
    HMN_CE_fast;
    usps = 0;
end
    
    
clear;
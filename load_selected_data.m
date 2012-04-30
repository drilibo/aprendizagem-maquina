cd DATA;

if artificial

load_artificial;
TRAIN_CL= TRAIN_CL';
end;


if artificial1

load_artificial1;
TRAIN_CL= TRAIN_CL';
end;

if banana1
load_banana;
end;


if breast_cancer1
load_breast_cancer;
end;

if diabetis1
load_diabetis;
end;


if heart1
load_heart;
end;

if flare_solar1
load_flare_solar;
end;

if german1
load_german;
end;

if splice1
load_splice;

end;

if im1
load_image;

end;

if ringnorm1
load_ring_norm
end;

if twonorm1
load_twonorm;
end;


if thyroid1
load_thyroid;
end;

if titanic1
load_titanic;
end;


if waveform1
load_waveform;
end;



if hedenfalk %sporadic-brca1-brca2
load_datasets_hedenfalk;
%permu = randperm(length(TRAIN_CL))
%   TRAIN_CL = TRAIN_CL(permu);
end;


if van_veer
van_veer_load_data;
TRAIN_CL = TRAIN_CL';
end;
 %Iizuka_datafiles
 if iizuka
     iizuka_load_datasets;
TRAIN_CL = TRAIN_CL';
 end;
%Nutt_datafiles
if nutt
    nutt_load_data;   
end;
%Singh_datafiles
if singh
    singh_load_datasets;
end;
if alon
load_alon;
end;
if leukemia
load_leukemia;
TRAIN_CL = TRAIN_CL';
end;
if   BRCA1_d
load_datasets_BRCA1;
end;
if BRCA2_d
load_datasets_BRCA2;
end;
if sporadic_d %sporadic
load_datasets_sporadic;
end;





if gen_easy
[ TRAIN,TRAIN_CL] = generate_easy(50,50);
% permu = randperm(length(TRAIN_CL));
  %   TRAIN_CL = TRAIN_CL(permu);
[ TEST,TEST_CL] = generate_easy(10,10);
end;



if gen_easy1
[ TRAIN,TRAIN_CL] = generate_easy1(2,10);
% permu = randperm(length(TRAIN_CL));
  %   TRAIN_CL = TRAIN_CL(permu);
[ TEST,TEST_CL] = generate_easy(10,1);
end;


if gen_ran
[ TRAIN,TRAIN_CL] = generate_xor(50,50);
% permu = randperm(length(TRAIN_CL));
  %   TRAIN_CL = TRAIN_CL(permu);
[ TEST,TEST_CL] = generate_xor(10,10);
end;


if no_cons
[ TRAIN,TRAIN_CL] = gen_no_cons(50,50);
% permu = randperm(length(TRAIN_CL))
 %    TRAIN_CL = TRAIN_CL(permu);
[ TEST,TEST_CL] = gen_no_cons(10,10);
end;

if irisd
load('iris.txt');
nr_e = size(iris,1);
permu = randperm(nr_e);
L = iris(:,5:7);
idx1 = find(L(:,1)==1);
CL(idx1) = 1;
idx2 = find(L(:,2)==1);
CL(idx2) = 2;
idx3 = find(L(:,3)==1);
CL(idx3) = 3;
TEST = iris(permu(1:30), 1:4)';
TEST_CL = CL(permu(1:30))';
TRAIN = iris(permu(31:150), 1:4)';
TRAIN_CL = CL(permu(31:150))';
end;

if bupad

 pippo = csvread('bupa.data');
L = pippo(:,7);
nr_e = size(pippo,1);
permu = randperm(nr_e);
TEST = pippo(permu(1:69), 1:6)';
TEST_CL = L(permu(1:69));
TRAIN = pippo(permu(70:nr_e), 1:6)';
TRAIN_CL = L(permu(70:nr_e));
end;

if wbreastc
 pippo = load('breast-cancer.data');
L = pippo(:,10);
nr_e = size(pippo,1);
permu = randperm(nr_e);
TEST = pippo(permu(1:137), 1:9)';
TEST_CL = L(permu(1:137));
TRAIN = pippo(permu(138:nr_e), 1:9)';
TRAIN_CL = L(permu(138:nr_e));

end;


if diabete

 load('diabetes.mat');
nr_e = length(C);
permu = randperm(nr_e);
TEST = X(permu(1:153), :)';
TEST_CL = C(permu(1:153));
TRAIN = X(permu(154:nr_e), :)';
TRAIN_CL = C(permu(154:nr_e));

end;

if coil20
%10 runs
  load  coil20.mat;
  Data = X';
s = permu(K);
  TRAIN = Data(:,idxUnls(s,:));
  TEST = Data(:,idxLabs(s,:));
  TRAIN_CL = y(idxUnls(s,:));
  TEST_CL = y(idxLabs(s,:));
  
end;

if textdata
   load text1.mat; 
   Data = X';
s = permu(K);
  TRAIN = Data(:,idxUnls(s,:));
  TEST = Data(:,idxLabs(s,:));
  TRAIN_CL = y(idxUnls(s,:));
  TEST_CL = y(idxLabs(s,:));
end;

if g50
    load g50c.mat;
    Data = X';
s = permu(K);
  TRAIN = Data(:,idxUnls(s,:));
  TEST = Data(:,idxLabs(s,:));
  TRAIN_CL = y(idxUnls(s,:));
  TEST_CL = y(idxLabs(s,:));
    
end;
if g10
    load g10n.mat;
    Data = X';
s = permu(K);
  TRAIN = Data(:,idxUnls(s,:));
  TEST = Data(:,idxLabs(s,:));
  TRAIN_CL = y(idxUnls(s,:));
  TEST_CL = y(idxLabs(s,:));
end;

if usps
   load uspst.mat;
   Data = X';
s = permu(K);
  TRAIN = Data(:,idxUnls(s,:));
  TEST = Data(:,idxLabs(s,:));
  TRAIN_CL = y(idxUnls(s,:));
  TEST_CL = y(idxLabs(s,:));
    
end;

cd ..

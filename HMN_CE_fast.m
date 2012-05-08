format short;
tic
alon = 0;
leukemia = 0;
BRCA1_d = 0;
BRCA2_d = 0;
sporadic_d = 0;
hedenfalk = 0;
iizuka = 0;
singh = 0;
nutt = 0;
van_veer = 0;
artificial = 0;
artificial1 = 0;
gen_ran = 0;
gen_easy = 0;
gen_easy1 = 0;
no_cons = 0;
tot_nndrop = [];
tot_hmn1 = [];
tot_rhmn1 = [];
tot_nn = [];
tot_nnicf = [];
tot_hmn = [];
tot_hmne1 = [];
tot_wil = [];
tot_rwil = [];
tot_rdrop = [];
tot_r1 = [];
tot_r = [];
tot_nne = [];
tot_hmne = [];
tot_hmnedit = [];
tot_re = [];
tot_red = [];
tot_ricf = [];
tot_icf_iter = [];

n_runs = min(max(1,n_runs), 10);
permu = randperm(10);
tot = zeros(3,1);
totr = zeros(3,1);

for K=1:n_runs
    
    novaBase = ecoli + segmentation + breastc;
    if(novaBase)
        cd am2
        [TRAIN,TEST] = carregarBase(ecoli, segmentation, permu(K));
        TRAIN_CL = TRAIN(:,end);
        TEST_CL = TEST(:,end);
        TRAIN = TRAIN(:,1:end-1)';
        TEST = TEST(:,1:end-1)';
        cd ..
    else
        load_selected_data;
    end
    
    [nf,nd ] = size(TRAIN);
    ntest = length(TEST_CL);
    DistM = [];
    
    for i=1:nd
        x = TRAIN(:,i);
        D = sum((repmat(x,1,nd)-TRAIN).^2,1);
        DistM = [DistM;  D];
    end;
    
    Enn = 1;
    if Enn
        S =  Repeated_ENN_fast(DistM, TRAIN_CL,1,0);
        Edwil = TRAIN(:,S);
        [neig, erp, ern, Misswil] = NN1cl(Edwil,TRAIN_CL(S),TEST,TEST_CL);
        tot_wil = [tot_wil (ntest - length(Misswil))/ntest];
        tot_rwil = [tot_rwil size(setdiff(1:length(TRAIN_CL),S)',1)/length(TRAIN_CL) ];
        T_enn = TRAIN(:,S);
        L_enn = TRAIN_CL(S);
        Rimossi_enn = TRAIN(:,setdiff(1:length(TRAIN_CL),S));
        Labels_rimossi_enn = TRAIN_CL(setdiff(1:length(TRAIN_CL),S));
    end;
    
    ICF_t = 1;
    if ICF_t
        S1 =  Repeated_ENN_fast(DistM, TRAIN_CL,1,1);
        [icf,LS,ILS,nr_iter_icf] = ICF_fast(DistM,TRAIN,TRAIN_CL,1,S1);
        tot_icf_iter = [ tot_icf_iter nr_iter_icf];
        Edicf = TRAIN(:,icf);
        EditicfL = TRAIN_CL(icf);
        resto = TRAIN(:,setdiff(1:length(TRAIN_CL),icf));
        restoL = TRAIN_CL(setdiff(1:length(TRAIN_CL),icf));
        [neig, erp, ern, Missicf] = NN1cl(Edicf,TRAIN_CL(icf),TEST,TEST_CL);
        tot_nnicf = [tot_nnicf (ntest - length(Missicf))/ntest];
        tot_ricf = [tot_ricf size(setdiff(1:length(TRAIN_CL),icf)',1)/length(TRAIN_CL) ];
        T_icf= Edicf;
        L_icf = EditicfL;
        Rimossi_icf = resto;
        Labels_rimossi_icf = restoL;
    end;
        
    drop3 = 1;
    if drop3
        [T1, L1, Nsel, Eddrop, Missdrop] = call_function_drop3(TRAIN, TEST, TRAIN_CL,TEST_CL, DistM);
        T_drop = TRAIN(:, Eddrop);
        L_drop = TRAIN_CL(Eddrop);
        Rimossi_drop = TRAIN(:,setdiff(1:length(TRAIN_CL),Eddrop));
        Labels_rimossi_drop = TRAIN_CL(setdiff(1:length(TRAIN_CL),Eddrop));
        ntest = length(TEST_CL);
        tot_nndrop = [tot_nndrop  (ntest - length(Missdrop))/ntest];
        tot_rdrop = [tot_rdrop (length(TRAIN_CL)- length(Eddrop))/length(TRAIN_CL) ];
    end;
    
    cd am2
    %HMN-C, HMN-E, HMN-EI, e 1-NN
    [tot, totr] = Rodar([TRAIN' TRAIN_CL], [TEST' TEST_CL], tot, totr);
    tot_nn = [tot_nn NN1([TRAIN' TRAIN_CL], [TEST' TEST_CL])];
    cd ..
    
end; %for K

disp(['HMN-C: ' num2str(tot(1)/K) ' acerto, ' num2str(totr(1)/K) ' reducao']);
disp(['HMN-E: ' num2str(tot(2)/K) ' acerto, ' num2str(totr(2)/K) ' reducao']);
disp(['HMN-EI: ' num2str(tot(3)/K) ' acerto, ' num2str(totr(3)/K) ' reducao']);

%esse eh pra colar mais facil na planilha
%disp(['HMN-C,E,EI: ' num2str(mean(tot_nn)) '	0	' num2str(tot(1)/K) '	' num2str(totr(1)/K) '	' num2str(tot(2)/K) '	' num2str(totr(2)/K) '	' num2str(tot(3)/K) '	' num2str(totr(3)/K) '	' num2str(mean(tot_nnicf)) '	' num2str(mean(tot_ricf)) '	' num2str(mean(tot_wil)) '	' num2str(mean(tot_rwil)) '	' num2str(mean(tot_nndrop)) '	' num2str(mean(tot_rdrop))]);

%%%%%%%%%%%%formatar isso melhor, taxa de acerto e remoção de cada um dos outros
    %disp('     1-NN     ICF       E-NN       DROP3');
    %[mean(tot_nn) mean(tot_nnicf) mean(tot_wil) mean(tot_nndrop)]%acerto
    %[0             mean(tot_ricf) mean(tot_rwil) mean(tot_rdrop)]%remocao


altri_metodi = 0;
if altri_metodi
    [mean(tot_nndrop)*100     mean(tot_rdrop)*100  mean(tot_hmn1)*100     mean(tot_rhmn1)*100  ]
    [ std(tot_nndrop)*100  std(tot_rdrop)*100   std(tot_hmn1)*100   std(tot_rhmn1)*100 ]

    tail = 'right';
    alpha = 0.05;
    x1 = tot_hmn1';
    x2 =  tot_nndrop';
    [ap,ah] =  signrank(x1,x2);
    [aht,apt] =  ttest(x1,x2,alpha, tail);
    
    x1 = tot_rhmn1';
    x2 =  tot_rdrop';
    [rp,rh] =  signrank(x1,x2);
    [rht,rpt] =  ttest(x1,x2,alpha, tail);
    
    [apt rpt aht rht]
    
    risultati = [
        mean(tot_nndrop)*100     mean(tot_rdrop)*100  mean(tot_hmn1)*100     mean(tot_rhmn1)*100
        std(tot_nndrop)*100  std(tot_rdrop)*100   std(tot_hmn1)*100   std(tot_rhmn1)*100
        apt rpt aht rht];
end;

compare_test = 0;
%tot_nn tot_hmnedit tot_hmn tot_nnicf tot_wil
% no     tot_red     tot_r  tot_ricf tot_rwil
if compare_test
    alpha = 0.05;
    tail = 'right';
    %tail = 'left';
    x1 = tot_hmnedit';
    ALL = [tot_nn' tot_hmn' tot_nnicf' tot_wil'];
    for i=1:4
        x2 = ALL(:,i);
        [h(i), p(i)] =  signrank(x1,x2);
        [ht(i),pt(i)] =  ttest(x1,x2,alpha, tail);
    end;
    x1 = tot_red';
    ALLR = [ tot_r' tot_ricf' tot_rwil'];
    for i=1:3
        x2 = ALLR(:,i);
        [rh(i),rp(i)] =  signrank(x1,x2);
        [rht(i),rpt(i)] =  ttest(x1,x2,alpha, tail);
    end;
end;

do_stats = 0;
if do_stats
    r_wilcoxon = [h' p']
    r_ttest = [ht' pt']
    
    r_wilcoxonR = [rh' rp']
    r_ttestR  = [rht' rpt']
    
    r_Te = [tot_hmnedit' ALL];
    r_TeR = [tot_red' ALLR];
    save _results r_*;
end;

if 0
    [mean(tot_nn)*100, std(tot_nn)*100  mean(tot_hmn)*100, std(tot_hmn)*100    mean(tot_r)*100, std(tot_r)*100]
    [mean(tot_nn)*100, std(tot_nn)*100  mean(tot_hmne)*100, std(tot_hmne)*100    mean(tot_re)*100, std(tot_re)*100]
    [mean(tot_nn)*100, std(tot_nn)*100  mean(tot_hmnedit)*100, std(tot_hmnedit)*100    mean(tot_red)*100, std(tot_red)*100  mean(tot_nnicf)*100 std(tot_nnicf)*100  mean(tot_ricf)*100 std(tot_ricf)*100]
end;

if 0
    if K > 1
        [mean(tot_nn)*100  std(tot_nn)*100    mean(tot_hmn)*100  std(tot_hmn)*100    mean(tot_r)*100, std(tot_r)*100  mean(tot_hmnedit)*100  std(tot_hmnedit)*100    mean(tot_red)*100 std(tot_red)*100 ]
        [mean(tot_nnicf)*100 std(tot_nnicf)*100  mean(tot_ricf)*100 std(tot_ricf)*100  mean(tot_wil)*100 std(tot_wil)*100 mean(tot_rwil)*100 std(tot_rwil)*100]
    else
        [mean(tot_nn)*100     mean(tot_hmn)*100     mean(tot_r)*100   mean(tot_hmnedit)*100    mean(tot_red)*100  tot_nnicf*100  (tot_ricf)*100 (tot_wil)*100 (tot_rwil)*100]
    end;
end;
toc

format short;
tic

%%%%READ DATA
%%%%%http://homes.esat.kuleuven.be/~npochet/Bioinformatics/
%Alon_datafiles
alon = 0;
%Golub_datafiles
leukemia = 0;
%Hedenfalk_datafiles
BRCA1_d = 0; %Hedenfalk
BRCA2_d = 0;
sporadic_d = 0;
hedenfalk = 0;
%Iizuk
iizuka = 0;
%%Singh
singh = 0;
%Nutt
nutt = 0;
%Van der Veer
van_veer = 0;

%%xor

artificial = 0;
artificial1 = 0;
gen_ran = 0;
gen_easy = 0;
gen_easy1 = 0;
no_cons = 0;








if more_runs
    n_runs = 10;
else
    n_runs = 1;
end;

if (im1 || splice1) && more_runs
    n_runs = 10;
end;

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





permu = randperm(10);

tot = zeros(3,1);
totr = zeros(3,1);
for K=1:n_runs
    
    K;
    
    %%%%%%%%%load dataset
    
    load_selected_data;
    
    %%%%%%%%%Data(features, examples)
    
    
    %%%%%%%%%%%%%%END READ DATA
    
    
    
    [nf,nd ] = size(TRAIN);
    ntest = length(TEST_CL);
    DistM = [];
    
    for i=1:nd
        
        
        x = TRAIN(:,i);
        D = sum((repmat(x,1,nd)-TRAIN).^2,1);
        DistM = [DistM;  D];
    end;
    
    
    Wil = 1;
    if Wil
        
        S =  Repeated_ENN_fast(DistM, TRAIN_CL,1,0);
        Edwil = TRAIN(:,S);
        [neig, erp, ern, Misswil] = NN1cl(Edwil,TRAIN_CL(S),TEST,TEST_CL);
        
        %[errwil, Misswil ] = KNN(Edwil,TRAIN_CL(S),TEST,TEST_CL,5);
        Misswil;
        
        
        tot_wil = [tot_wil (ntest - length(Misswil))/ntest];
        
        tot_rwil = [tot_rwil size(setdiff(1:length(TRAIN_CL),S)',1)/length(TRAIN_CL) ];
        
        
        
        T_enn = TRAIN(:,S);
        L_enn = TRAIN_CL(S);
        Rimossi_enn = TRAIN(:,setdiff(1:length(TRAIN_CL),S));
        Labels_rimossi_enn = TRAIN_CL(setdiff(1:length(TRAIN_CL),S));
        
    end;
    
    %%ICF
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
        %[erricf, Missicf ] = KNN(Edicf,TRAIN_CL(icf),TEST,TEST_CL,5);
        
        Missicf;
        
        tot_nnicf = [tot_nnicf (ntest - length(Missicf))/ntest];
        
        tot_ricf = [tot_ricf size(setdiff(1:length(TRAIN_CL),icf)',1)/length(TRAIN_CL) ];
        
        T_icf= Edicf;
        L_icf = EditicfL;
        Rimossi_icf = resto;
        Labels_rimossi_icf = restoL;
        
    end;
    
    
    prova = 0;
    if prova
        
        [S_h1, seledit1, Missedit1] = call_function_hmn1(TRAIN, TEST, TRAIN_CL,TEST_CL, DistM);
        
        %Missedit1;
        
        
        
        
        L1h = TRAIN_CL(S_h1(seledit1));
        T1h = TRAIN(:,S_h1(seledit1));
        
        %[err1, Missedit1] =  KNN(T1h, L1h,TEST, TEST_CL,5 );
        
        
        Rimossih = TRAIN(:,setdiff(1:length(TRAIN_CL),S_h1(seledit1)));
        Labels_rimossih = TRAIN_CL(setdiff(1:length(TRAIN_CL),S_h1(seledit1)));
        
        nd = length(TRAIN_CL);
        ntest = length(TEST_CL);
        tot_hmne1 = [tot_hmne1 (ntest - length(Missedit1))/ntest];
        tot_r1 = [tot_r1 size(setdiff(1:length(TRAIN_CL),seledit1)',1)/length(TRAIN_CL) ];
        
        [neig, erp, ern, Miss_tr] = NN1cl(T1h, L1h ,  TRAIN ,TRAIN_CL);
        freq_tolti = length(Miss_tr);
        
        sel_so_far = S_h1(seledit1);
        L2 = TRAIN_CL(sel_so_far );
        T2 = TRAIN(:, sel_so_far);
        Dist2 =DistM(sel_so_far,sel_so_far);
        
        progress = 1;
        prog = 1;
        
        Miss_hmn_iter = Missedit1;
        iter_hmn1 = [];
        
        while progress
            
            prog = prog+1;
            iter_hmn1 = [iter_hmn1 prog-1];
            
            freq_tolti1 = freq_tolti;
            [S_h1, seledit3, Missedit3] = call_function_hmn1(T2, TEST, L2,TEST_CL, Dist2);
            
            
            %tam = size(L2);
            %tam
            tmp_sel = sel_so_far(S_h1(seledit3));
            Ltmp = TRAIN_CL(tmp_sel);
            Ttmp = TRAIN(:, tmp_sel );
            
            %[err1, Missedit3] =  KNN(Ttmp, Ltmp,TEST, TEST_CL,5 );
            
            [neig, erp, ern, Miss_tr] = NN1cl(Ttmp, Ltmp , TRAIN,TRAIN_CL );
            
            %[err1, Miss_tr] =  KNN(Ttmp, Ltmp,TRAIN, TRAIN_CL,5 );
            
            
            freq_tolti = length(Miss_tr);
            %diminuicao = length(sel_so_far) - length(seledit3);
            %diminuicao
            progress = ((length(seledit3) < length(sel_so_far) && freq_tolti<= freq_tolti1 ) | prog ==2);
            
            if progress
                sel_so_far = tmp_sel;
                Miss_hmn_iter = Missedit3;
                T2 =  Ttmp ;
                L2 = Ltmp;
            end;
            
        end; %while progress
        %disp(['iteracoes hmn-ei dela: ' num2str(prog-1)]);
        tot_hmn1 = [tot_hmn1 (ntest - length(Miss_hmn_iter))/ntest];
        
        tot_rhmn1 = [tot_rhmn1 size(setdiff(1:length(TRAIN_CL),sel_so_far)',1)/length(TRAIN_CL)];
        
        
        T_hmnei = TRAIN(:,sel_so_far);
        L_hmnei = TRAIN_CL(sel_so_far);
        Rimossi_hmnei = TRAIN(:,setdiff(1:length(TRAIN_CL),sel_so_far));
        Labels_rimossi_hmnei = TRAIN_CL(setdiff(1:length(TRAIN_CL),sel_so_far));
        
    end;
    
    OTHER=0;
    [~, ~, ~, Miss1] = NN1cl(TRAIN,TRAIN_CL,TEST,TEST_CL);
     nd = length(TRAIN_CL);
        
        ntest = length(TEST_CL);
        
        tot_nn = [tot_nn  (ntest - length(Miss1))/ntest];
    if OTHER
        
        [SO,sel, seledit, Miss, Miss1, Missedit] =call_function_hmn_edit(TRAIN, TEST, TRAIN_CL,TEST_CL, DistM);
        
        
        %size(setdiff(1:nd,sel)',1)/nd;
        %[err, Miss ] = KNN(TRAIN, TRAIN_CL,TEST, TEST_CL,5 );
        
        %[err, Miss1 ] = KNN(TRAIN(:,sel), TRAIN_CL(sel),TEST, TEST_CL,5 );
        %[err, Missedit ] = KNN(TRAIN(:,seledit), TRAIN_CL(seledit),TEST, TEST_CL,5 );
        
        
       
        tot_hmn = [tot_hmn (ntest - length(Miss))/ntest];
        
        
        
        
        tot_hmnedit = [tot_hmnedit (ntest - length(Missedit))/ntest];
        tot_red = [tot_red size(setdiff(1:length(TRAIN_CL),seledit)',1)/length(TRAIN_CL) ];
        
        
        T_hmn = TRAIN(:,sel);
        L_hmn = TRAIN_CL(sel);
        Rimossi_hmn = TRAIN(:,setdiff(1:length(TRAIN_CL),sel));
        Labels_rimossi_hmn = TRAIN_CL(setdiff(1:length(TRAIN_CL),sel));
        
        T_hmne = TRAIN(:,seledit);
        L_hmne = TRAIN_CL(seledit);
        Rimossi_hmne = TRAIN(:,setdiff(1:length(TRAIN_CL),seledit));
        Labels_rimossi_hmne = TRAIN_CL(setdiff(1:length(TRAIN_CL),seledit));
        
    end; %if OTHER
    
    drop3 = 1;
    if drop3
        
        %%%%%%%%%DROP3 BEGIN
        [T1, L1, Nsel, Eddrop, Missdrop] = call_function_drop3(TRAIN, TEST, TRAIN_CL,TEST_CL, DistM);
        
        T_drop = TRAIN(:, Eddrop);
        L_drop = TRAIN_CL(Eddrop);
        
        %[err1, Missdrop] =  KNN(T_drop, L_drop,TEST, TEST_CL,5 );
        
        Rimossi_drop = TRAIN(:,setdiff(1:length(TRAIN_CL),Eddrop));
        Labels_rimossi_drop = TRAIN_CL(setdiff(1:length(TRAIN_CL),Eddrop));
        
        ntest = length(TEST_CL);
        
        tot_nndrop = [tot_nndrop  (ntest - length(Missdrop))/ntest];
        
        
        tot_rdrop = [tot_rdrop (length(TRAIN_CL)- length(Eddrop))/length(TRAIN_CL) ];
        
        
    end;
    %%%%%%%%%END DROP3
    
    cd am2
    [tot, totr] = Rodar([TRAIN' TRAIN_CL], [TEST' TEST_CL], tot, totr);
    cd ..
    
end; %for K
disp(['HMN-C: ' num2str(tot(1)/K) ' acerto, ' num2str(totr(1)/K) ' reducao']);
disp(['HMN-E: ' num2str(tot(2)/K) ' acerto, ' num2str(totr(2)/K) ' reducao']);
disp(['HMN-EI: ' num2str(tot(3)/K) ' acerto, ' num2str(totr(3)/K) ' reducao']);

if ICF_t
    
    [mean(tot_nnicf)*100     mean(tot_ricf)*100];
    mean(tot_icf_iter);
    
end;

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


%esse debaixo eh pra colar mais facil na planilha
disp(['HMN-C,E,EI: ' num2str(mean(tot_nn)) '	0	' num2str(tot(1)/K) '	' num2str(totr(1)/K) '	' num2str(tot(2)/K) '	' num2str(totr(2)/K) '	' num2str(tot(3)/K) '	' num2str(totr(3)/K) '	' num2str(mean(tot_nnicf)) '	' num2str(mean(tot_ricf)) '	' num2str(mean(tot_wil)) '	' num2str(mean(tot_rwil)) '	' num2str(mean(tot_nndrop)) '	' num2str(mean(tot_rdrop))]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp('     1-NN     ICF       E-NN       DROP3');
    [ mean(tot_nn) mean(tot_nnicf) mean(tot_wil) mean(tot_nndrop)  ];
    
    [ 0             mean(tot_ricf) mean(tot_rwil) mean(tot_rdrop)];

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

%if textdata
if 0
    text_wilcoxon = [h' p']
    text_ttest = [ht' pt']
    
    text_wilcoxonR = [rh' rp']
    text_ttestR  = [rht' rpt']
    
    text_Te = [tot_hmnedit' ALL];
    text_TeR = [tot_red' ALLR];
    save Text_results text_*;
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
    
    [mean(tot_nn)*100, std(tot_nn)*100     mean(tot_hmn)*100, std(tot_hmn)*100    mean(tot_r)*100, std(tot_r)*100]
    
    [mean(tot_nn)*100, std(tot_nn)*100     mean(tot_hmne)*100, std(tot_hmne)*100    mean(tot_re)*100, std(tot_re)*100]
    
    [mean(tot_nn)*100, std(tot_nn)*100     mean(tot_hmnedit)*100, std(tot_hmnedit)*100    mean(tot_red)*100, std(tot_red)*100  mean(tot_nnicf)*100 std(tot_nnicf)*100  mean(tot_ricf)*100 std(tot_ricf)*100]
    
end;


if 0
    if K > 1
        [mean(tot_nn)*100  std(tot_nn)*100    mean(tot_hmn)*100  std(tot_hmn)*100    mean(tot_r)*100, std(tot_r)*100  mean(tot_hmnedit)*100  std(tot_hmnedit)*100    mean(tot_red)*100 std(tot_red)*100 ]
        
        [mean(tot_nnicf)*100 std(tot_nnicf)*100  mean(tot_ricf)*100 std(tot_ricf)*100  mean(tot_wil)*100 std(tot_wil)*100 mean(tot_rwil)*100 std(tot_rwil)*100]
    else
        [mean(tot_nn)*100     mean(tot_hmn)*100     mean(tot_r)*100   mean(tot_hmnedit)*100    mean(tot_red)*100  tot_nnicf*100  (tot_ricf)*100 (tot_wil)*100 (tot_rwil)*100]
    end;
end;


nf = size(TRAIN,1);




do_figures_paper_jmlr =0 ;

if do_figures_paper_jmlr
    %%FIGURE 2
    %%%%%%%%plot training set and HMN-degrees
    
    
    %%%1
    EdL =  TRAIN_CL;
    E = TRAIN;
    
    plot_training_set(E, EdL);
    plot_degr(SO);
    degr = sum(SO');
    [sorted_tr, idx_tr ] = sort(degr,'descend');
    
    %%%%%%%%%%%%%end plot TS and HMN degrees END FIGURE 2
    
    %%FIGURE 3
    %%%%%%%%plot training set with random labels and HMN-degrees
    
    %%%%3
    
    rnd = randperm(length(TRAIN_CL));
    EdL =  TRAIN_CL(rnd);
    E = TRAIN(:,:);
    plot_training_set(E, EdL);
    
    %%%%%% G adjacency matrix describes edges of NHMN built from the training set
    [Gr,SOr,Ir] = HMN_construct_fast(DistM,EdL);
    plot_degr(SOr);
    
    %%%%%%%%%%%%%end plot TS and HMN degrees END FIGURE 3
    
    
    
    %%%%%%%%%%%%%%%%%% %points renoved by HMN-C FIGURE 4 LEFT
    if  nf==2
        %%%%%5
        
        EdL =  TRAIN_CL(sel);
        E= TRAIN(:,sel);
        
        resto = TRAIN(:,setdiff(1:nd,sel));
        restoL = TRAIN_CL(setdiff(1:nd,sel) );
        plot_removed_alg(E, EdL, resto, restoL);
        title('HMN-C');
    end;
    %%%%%%%%%%END %points renoved by HMN-C  FIGURE 4 LEFT
    
    
    
    
    %%%%%%%%%%%%%%%%%% %points removed by HMN-E FIGURE 4 RIGHT
    if  nf==2
        
        %%%%%6
        EdL =  TRAIN_CL(seledit);
        E= TRAIN(:,seledit);
        resto = TRAIN(:,setdiff(1:nd,seledit));
        restoL = TRAIN_CL(setdiff(1:nd,seledit) );
        plot_removed_alg(E, EdL, resto, restoL);
        title('HMN-E');
    end;
    %%%%%%%%%%END %points renoved by HMN-E  FIGURE 4 RIGHT
    
    %%%%%%%%%%%%%%%%%% %points renoved by WILSON FIGURE 6 LEFT
    if  nf==2
        %%%%%%7
        EdL =  TRAIN_CL(S);
        E= Edwil;
        resto = TRAIN(:,setdiff(1:nd,S));
        restoL = TRAIN_CL(setdiff(1:nd,S));
        plot_removed_alg(E, EdL, resto, restoL);
        title('ENN');
    end;
    %%%%%%%%%%END %points reMoved by WILSON FIGURE 6 LEFT
    
    
    
    %%%%%%%%%%%%%%%%%% %points reMoved by ICF FIGURE 6 CENTER
    
    if  nf==2
        %%%%%8
        EdL =  TRAIN_CL(icf);
        E= Edicf;
        resto = TRAIN(:,setdiff(1:nd,icf));
        restoL = TRAIN_CL(setdiff(1:nd,icf) );
        plot_removed_alg(E, EdL, resto, restoL);
        title('ICF');
    end;
    
    
    
    %%%%%%%%%%END %points reMoved by ICF FIGURE 6 CENTER
    
    
    
    %%%%%%%%%%%%%%%%%% %points reMoved by DROP FIGURE 6 RIGHT
    
    if  nf==2
        %%%%%%%9
        EdL =  L1(Eddrop);
        E =  T1(:, Eddrop );
        resto = [ T1(:,setdiff(1:length(L1), Eddrop)) Rimossi];
        restoL = [ L1(setdiff(1:length(L1), Eddrop) ) ; Labels_rimossi];
        plot_removed_alg(E, EdL, resto, restoL);
        title('DROP3');
    end;
    
    %%%%%%%%%%END %points reMoved by DROP FIGURE 6 RIGHT
    
    %%%%%%%%BEGIN FIGURE 7
    rem_enn = setdiff(1:nd,S);
    rem_icf = setdiff(1:nd,icf);
    rem_hmnc = setdiff(1:nd,sel);
    rem_hmne =setdiff(1:nd, seledit);
    
    %%%%%10
    figure;
    
    plot(1:nd,sorted_tr,'y.');
    hold on;
    [t,a,b] = intersect(idx_tr,rem_hmne);
    plot(a,sorted_tr(a),'k^','MarkerSize',10);
    title('HMNE');
    %%%%%%11
    figure;
    
    plot(1:nd,sorted_tr,'y.');
    hold on;
    [t,a,b] = intersect(idx_tr,rem_enn);
    plot(a,sorted_tr(a),'k^','MarkerSize',10);
    title('ENN');
    %%%%12
    figure;
    
    plot(1:nd,sorted_tr,'y.');
    hold on;
    [t,a,b] = intersect(idx_tr,rem_icf);
    plot(a,sorted_tr(a),'k^','MarkerSize',10);
    title('ICF');
    
    
    %%DROP3
    
    resto = [ T1(:,setdiff(1:length(L1), Eddrop)) Rimossi];
    restoL = [ L1(setdiff(1:length(L1), Eddrop) ) ; Labels_rimossi];
    
    X1 = [T1(:,Eddrop) resto];
    Y1 = [L1(Eddrop); restoL];
    
    clear DistM;
    
    [nf,nd ] = size(TRAIN);
    ntest = length(TEST_CL);
    DistM = [];
    
    for i=1:nd
        x = X1(:,i);
        D = sum((repmat(x,1,nd)-X1).^2,1);
        DistM = [DistM;  D];
    end;
    
    [G,SOtmp,I] = HMN_construct_fast(DistM,Y1);
    degr_tmp = sum(SOtmp');
    [sortedtmp, idx_dr ] = sort(degr_tmp,'descend');
    gradi_tmp = unique(sortedtmp);
    for j=1:length(gradi_tmp)
        id_tmp{j} = find(sortedtmp==gradi_tmp(j));
        nr(j) = size(id_tmp{j},2);
    end;
    
    rem_drop = length(Eddrop)+1:nd;
    
    %%%%%%13
    
    figure;
    
    plot(1:nd,sortedtmp,'y.');
    hold on;
    [t,a,b] = intersect(idx_dr,rem_drop);
    plot(a,sortedtmp(a),'k^','MarkerSize',10);
    title('DROP3');
    
    %%end DROP3
    
    %%%%%%%%END FIGURE 7
    
    
    %%%%%%HMN_NUOVO call_finction_hmn1 function
    
    restoH =  Rimossih;
    restoLH =  Labels_rimossih;
    X1 = [T1h restoH];
    Y1 = [L1h; restoLH];
    clear DistM;
    [nf,nd ] = size(TRAIN);
    ntest = length(TEST_CL);
    DistM = [];
    
    for i=1:nd
        x = X1(:,i);
        D = sum((repmat(x,1,nd)-X1).^2,1);
        DistM = [DistM;  D];
    end;
    
    [G,SOtmp,I] = HMN_construct_fast(DistM,Y1);
    degr_tmp = sum(SOtmp');
    [sorted_h1, idx_h1 ] = sort(degr_tmp,'descend');
    gradi_tmp = unique(sorted_h1);
    for j=1:length(gradi_tmp)
        id_tmp{j} = find(sorted_h1==gradi_tmp(j));
        nr(j) = size(id_tmp{j},2);
    end;
    
    rem_h1 = length(seledit1)+1:nd;
    
    %%%%%%14
    
    figure;
    
    plot(1:nd,sorted_h1,'y.');
    hold on;
    [t,a,b] = intersect(idx_h1,rem_h1);
    plot(a,sorted_h1(a),'k^','MarkerSize',10);
    title('HMN1');
    %%end hmn1 NUOVO
    
    %%%%%%%%END FIGURE
    
    
    %%%%%%HMN_NUOVO call_finction_hmn1 function
    
    restoH = TRAIN(:,setdiff(1:nd,sel_so_far));
    restoLH = TRAIN_CL(setdiff(1:nd,sel_so_far));
    X1 = [T2 restoH];
    Y1 = [L2; restoLH];
    clear DistM;
    [nf,nd ] = size(TRAIN);
    ntest = length(TEST_CL);
    DistM = [];
    
    for i=1:nd
        x = X1(:,i);
        D = sum((repmat(x,1,nd)-X1).^2,1);
        DistM = [DistM;  D];
    end;
    
    [G,SOtmp,I] = HMN_construct_fast(DistM,Y1);
    degr_tmp = sum(SOtmp');
    [sorted_iter, idx_iter ] = sort(degr_tmp,'descend');
    gradi_tmp = unique(sorted_iter);
    for j=1:length(gradi_tmp)
        id_tmp{j} = find(sorted_iter==gradi_tmp(j));
        nr(j) = size(id_tmp{j},2);
    end;
    
    rem_iter = length( sel_so_far)+1:nd;
    
    %%%%%%14
    
    figure;
    
    plot(1:nd,sorted_iter,'y.');
    hold on;
    [t,a,b] = intersect(idx_iter,rem_iter);
    plot(a,sorted_iter(a),'k^','MarkerSize',10);
    title('HMN-ITER');
    %%end hmn1 NUOVO
    
    %%%%%%%%END FIGURE HM1-ITER
    
    
    if  nf==2
        %%%%%%%15
        EdL =  L2;
        E =  T2;
        
        plot_removed_alg(E, EdL, restoH, restoLH);
        title('HMN-ITER');
    end;
    
    
    
    
    
end;
toc

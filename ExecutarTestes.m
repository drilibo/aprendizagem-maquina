% Este script foi inicialmente feito pela autora, o que fizemos foi retirar
% partes dele, deixando apenas o carregamento das bases, o E-NN, ICF e DROP3
% E adicionamos a execução de nossa implementação dos HMNs
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
tot = [];
totr = [];

% Para cada iteração, utilizamos 10
for K=1:n_runs
    %impressão para dar noção do quanto o processo andou
    fprintf('%d..', floor((K-1)*(100/n_runs)));
    novaBase = ecoli + segmentation + breastc;
    if(novaBase)
        %Se alguma das bases que adicionamos estiver selecionada para teste
        %fazemos o carregamento aqui
        cd am2
        [TRAIN,TEST] = carregarBase(ecoli, segmentation, permu(K));
        TRAIN_CL = TRAIN(:,end);
        TEST_CL = TEST(:,end);
        TRAIN = TRAIN(:,1:end-1)';
        TEST = TEST(:,1:end-1)';
        cd ..
    else
        % As demais bases são carregadas pelo script da autora
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
    [ret, retr] = Rodar([TRAIN' TRAIN_CL], [TEST' TEST_CL]);
    tot = [tot ret];
    totr = [totr retr];
    tot_nn = [tot_nn NN1([TRAIN' TRAIN_CL], [TEST' TEST_CL])];
    cd ..
    
end; %for K
fprintf('100\n');


disp(['HMN-C: ' num2str(mean(tot(1,:))) ' acerto, ' num2str(mean(totr(1,:))) ' reducao']);
disp(['HMN-E: ' num2str(mean(tot(2,:))) ' acerto, ' num2str(mean(totr(2,:))) ' reducao']);
disp(['HMN-EI: ' num2str(mean(tot(3,:))) ' acerto, ' num2str(mean(totr(3,:))) ' reducao']);

resultados = [tot_nn; zeros(1,n_runs); tot(1,:); totr(1,:); tot(2,:); totr(2,:); tot(3,:); totr(3,:); tot_nnicf; tot_ricf; tot_wil; tot_rwil; tot_nndrop; tot_rdrop];
disp(resultados);

%Os resultados dos algoritmos para cada iteração são guardados na pasta
%am2/resultados
dlmwrite(['am2/resultados/' nomebase '.txt'], resultados, ' ');


disp(['HMN-C,E,EI: ' num2str(mean(tot_nn)) '	0	' num2str(mean(tot(1,:))) '	' num2str(mean(totr(1,:))) '	' num2str(mean(tot(2,:))) '	' num2str(mean(totr(2,:))) '	' num2str(mean(tot(3,:))) '	' num2str(mean(totr(3,:))) '	' num2str(mean(tot_nnicf)) '	' num2str(mean(tot_ricf)) '	' num2str(mean(tot_wil)) '	' num2str(mean(tot_rwil)) '	' num2str(mean(tot_nndrop)) '	' num2str(mean(tot_rdrop))]);

    %disp('     1-NN     ICF       E-NN       DROP3');
    %[mean(tot_nn) mean(tot_nnicf) mean(tot_wil) mean(tot_nndrop)]%acerto
    %[0             mean(tot_ricf) mean(tot_rwil) mean(tot_rdrop)]%remocao

toc

%Esta função recebe os conjuntos de treinamento e teste e retorna:
%tot: que contém a taxa de acerto para o HMN-C, HMN-E e HMN-EI nesta ordem
%totr: que contém a taxa de redução para o HMN-C, HMN-E e HMN-EI nesta ordem
function [tot, totr] = Rodar(trainData, testeData)
    difClasses = unique( [trainData(:, end); testeData(:,end)] );
    ate = size(difClasses, 1);
    qntTrain = size(trainData, 1);
    qntTest = size(testeData,1);
    tot = zeros(3,1);
    totr = zeros(3,1);
    for i = 1:qntTrain,
        for j = 1: ate,
            if trainData(i, end) == difClasses(j),
                trainData(i, end) = j;
                break;
            end
        end
    end

    for i = 1:qntTest,
        for j = 1: ate,
            if testeData(i, end) == difClasses(j),
                testeData(i, end) = j;
                break;
            end
        end
    end
    
    %Chama a função HMN do arquivo HMN.m passando a opção de pegar os 3 HMNs
    [selecaoHMNC, selecaoHMNE, selecaoHMNEI] = HMN(trainData, 0.1, 4);
    total = size(trainData,1);
    
    %É computada a taxa de acerto e redução do HMN-C
    taxaAcerto = NN1(selecaoHMNC, testeData);
    reducao = 1 - size(selecaoHMNC,1)/total;
    tot(1) = tot(1) + taxaAcerto;
    totr(1) = totr(1) + reducao;

    %É computada a taxa de acerto e redução do HMN-E
    taxaAcerto = NN1(selecaoHMNE, testeData);
    reducao = 1 - size(selecaoHMNE,1)/total;
    tot(2) = tot(2) + taxaAcerto;
    totr(2) = totr(2) + reducao;

    %É computada a taxa de acerto e redução do HMN-EI
    taxaAcerto = NN1(selecaoHMNEI, testeData);
    reducao = 1 - size(selecaoHMNEI,1)/total;
    tot(3) = tot(3) + taxaAcerto;
    totr(3) = totr(3) + reducao;
    
end
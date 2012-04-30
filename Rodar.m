trainData = dlmread('imageSegmentation/tra', ' ');
testeData = dlmread('imageSegmentation/tes', ' ');

[selecaoHMNC, selecaoHMNE, selecaoHMNEI] = HMN(trainData, 0.1, 4);

taxaAcerto = NN1(selecaoHMNC, testeData);
disp(taxaAcerto);

taxaAcerto = NN1(selecaoHMNE, testeData);
disp(taxaAcerto);

taxaAcerto = NN1(selecaoHMNEI, testeData);
disp(taxaAcerto);

function Rodar(trainData, testeData)
[selecaoHMNC, selecaoHMNE, selecaoHMNEI] = HMN(trainData, 0.1, 4);
total = size(trainData,1);
taxaAcerto = NN1(selecaoHMNC, testeData);
reducao = 1 - size(selecaoHMNC,1)/total;
disp([num2str(taxaAcerto) ' acerto, ' num2str(reducao) ' reducao']);

taxaAcerto = NN1(selecaoHMNE, testeData);
reducao = 1 - size(selecaoHMNE,1)/total;
disp([num2str(taxaAcerto) ' acerto, ' num2str(reducao) ' reducao']);

taxaAcerto = NN1(selecaoHMNEI, testeData);
reducao = 1 - size(selecaoHMNEI,1)/total;
disp([num2str(taxaAcerto) ' acerto, ' num2str(reducao) ' reducao']);

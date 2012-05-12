function [treino,teste] = carregarBase(eco, seg, permutacao)
if(eco == 1)
    nome = 'ecoli';
elseif(seg == 1)
    nome = 'segmentation';
else
    nome = 'breastCancer';
end
dados = dlmread(['data/' nome '.data']);
decimo = floor(size(dados,1)/10);
atual = (permutacao-1)*decimo +1;
treino = [dados(1:atual-1,:) ; dados(atual+decimo:end,:)];
teste = dados(atual:min(end, atual+decimo-1),:);

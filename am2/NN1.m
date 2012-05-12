%Esta é uma implementação básica do 1-NN.
%Esta função recebe os conjuntos de treinamento e teste e retorna a taxa de
%acerto do 1-NN
function taxaAcerto = NN1(trainData, testData)
    classes = trainData(:, end);
    trainData = trainData(:, 1:end-1);
    qntTrain = size(trainData, 1);
    taxaAcerto = 0;
    qntTeste = size(testData, 1);
    for i=1:qntTeste,
        %Pega a posição da instância de treinamento mais próxima da
        %instância de teste i
        [~, pos] = min( sum( (repmat(testData(i, 1:end-1), qntTrain, 1) - trainData).^2, 2));
        class = classes( pos );
        if testData(i, end) == class,
            taxaAcerto = taxaAcerto+1;
        end
    end
    taxaAcerto = taxaAcerto/qntTeste;
end

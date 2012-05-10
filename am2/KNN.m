function taxaAcerto = KNN(trainData, testData)
    K = 5;
    classes = trainData(:, end);
    trainData = trainData(:, 1:end-1);
    qntTrain = size(trainData, 1);
    taxaAcerto = 0;
    qntTeste = size(testData, 1);
    for i=1:qntTeste,
        lista = [sum( (repmat(testData(i, 1:end-1), qntTrain, 1) - trainData).^2, 2) classes];
        lista = sortrows(lista, 1);
        pop = zeros(30,1);
        for z = 1:K
            pop(lista(z,2)+3) = pop(lista(z,2)+3)+1;
        end
        [~, resp] = max(pop);
        if resp == testData(i,end)+3,
            taxaAcerto = taxaAcerto+1;
        end
    end
    taxaAcerto = taxaAcerto/qntTeste;
end

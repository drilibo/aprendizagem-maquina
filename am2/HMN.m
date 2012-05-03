function [ selecao, selecao1, selecao2] = HMN( data, eps, hmnop)
    qntClass = max(data(:, end));
    qntTrain = size(data, 1);
    dataPorClass = cell(qntClass, 1);
    for i=1:qntTrain,
        dataPorClass{data(i, end)} = [dataPorClass{data(i, end)}; data(i,1:end-1)];
    end
    hits = cell(qntClass, 1);
    misses = cell(qntClass, 1);
    for c=1:qntClass,
        hits{c} = zeros(size(dataPorClass{c}, 1), 1);
        misses{c} = zeros(size(dataPorClass{c}, 1), 1);
    end
    
    for c1=1:qntClass,
        ate1 = size(dataPorClass{c1}, 1);
        for c2=1:qntClass,
            ate2 = size(dataPorClass{c2}, 1);
            if(ate2)
                for i=1:ate1,
                    dists = sum((repmat(dataPorClass{c1}(i,:), ate2, 1) - dataPorClass{c2}).^2, 2);
                    if(c1 == c2)
                        dists(i) = 1e20;
                        [~, a] = min(dists);
                        hits{c1}(a) = hits{c1}(a) + 1;
                    else
                        [~, a] = min(dists);
                        misses{c2}(a) = misses{c2}(a) + 1;
                    end
                end
            end
        end
    end
    selecao = [];
    selecao1 = [];
    selecao2 = [];
    if(hmnop == 1 || hmnop == 4)
        for c=1:qntClass,
            ate = size(dataPorClass{c}, 1);
            for i=1:ate,
                if (hits{c}(i) + misses{c}(i)) ~= 0,
                    selecao = [selecao; dataPorClass{c}(i, :), c];
                end
            end
        end
    end
    if(hmnop == 2 || hmnop == 4)
        selecao1 = HMNE(data, dataPorClass, misses, hits, qntClass, eps);
    end
    if(hmnop == 3 || hmnop == 4)
        if(hmnop == 3)
            selecao2 = HMNE(data, dataPorClass, misses, hits, qntClass, eps);
        else
            selecao2 = selecao1;
        end
        taxaAcerto = NN1(selecao2, data);
        ini = 1;
        while (true)
            [~, selecaoaux, ~] = HMN(selecao2, eps, 2);
            taxaAcertoaux = NN1(selecaoaux, data);
            if ini>1 && (taxaAcerto > taxaAcertoaux || all(size(selecao2,1) == size(selecaoaux,1)))
                break;
            end
            ini = ini+1;
            selecao2 = selecaoaux;
            taxaAcerto = taxaAcertoaux;
        end
    end
end

function selecao1 = HMNE(data, dataPorClass, misses, hits, qntClass, eps)

    selecao1 = [];
    selecionados = cell(qntClass, 1);
    left = zeros(qntClass, 1);
    for c=1:qntClass,
        selecionados{c} = zeros(size(dataPorClass{c}, 1), 1);
        left(c) = size(dataPorClass{c}, 1);
    end
    for c=1:qntClass, %regra 1
        ate = size(dataPorClass{c}, 1);
        wl = ate/size(data, 1);
        for i=1:ate,
            if ~(wl * misses{c}(i) + eps > (1-wl)*hits{c}(i)),
                selecao1 = [selecao1; dataPorClass{c}(i, :), c];
                left(c) = left(c) - 1;
                selecionados{c}(i) = 1;
            end
        end
    end
    for c=1:qntClass, %regra 2
        if(left(c) < 4)
            qnt = size(dataPorClass{c}, 1);
            for i=1:qnt,
                if(misses{c}(i) + hits{c}(i) > 0 && selecionados{c}(i) == 0)
                    selecionados{c}(i) = 1;
                    selecao1 = [selecao1; dataPorClass{c}(i, :), c];
                end
            end
        end
    end
    for c=1:qntClass, %regra 3 e 4
        ate = size(dataPorClass{c}, 1);
        for i=1:ate,
            if selecionados{c}(i) == 0,
                if qntClass > 3 && misses{c}(i) < qntClass/2 && misses{c}(i)+hits{c}(i) > 0,
                    selecionados{c}(i) = 1;
                    selecao1 = [selecao1; dataPorClass{c}(i, :), c];
                elseif hits{c}(i) >= ate/4,
                    selecionados{c}(i) = 1;
                    selecao1 = [selecao1; dataPorClass{c}(i, :), c];
                end
            end
        end
    end

end


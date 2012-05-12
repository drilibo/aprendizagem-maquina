%Esta funcao cria o grafo do HMN, contabilizando hits e misses de cada
%vertice e guardando nos arrays de cells "hits" e "misses". Em seguida s�o
%rodados os HMN-C, HMN-E, HMN-EI dependendo da op��o passada: 
%hmnop = 1 -> rodar apenas o HMN-C, apenas o output 'selecao' ser� usado
%hmnop = 2 -> rodar apenas o HMN-E, apenas o output 'selecao1' ser� usado
%hmnop = 3 -> rodar apenas o HMN-EI, apenas o output 'selecao2' ser� usado
%hmnop = 4 -> Os tr�s HMNs ser�o rodados e todos as tr�s sa�das estar�o
%preenchidas.
function [ selecao, selecao1, selecao2] = HMN( data, eps, hmnop)
    %inicializa��o de vari�veis
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
    %constru��o do grafo
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
    %in�cio das sele��es
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
            %reaproveita a primeira sele��o do HMNE
            selecao2 = selecao1;
        end
        taxaAcerto = NN1(selecao2, data);
        ini = 1;
        while (true)
            %o HMN-EI rechama o HMN pedindo apenas o resultado do HMN-E, �
            %feita esta recurs�o pois h� a necessidade de remontar o grafo
            %para as inst�ncias escolhidas at� ent�o.
            [~, selecaoaux, ~] = HMN(selecao2, eps, 2);
            taxaAcertoaux = NN1(selecaoaux, data);
            %� for�ado a existir pelo menos uma itera��o deste while, de acordo com a implementa��o
            %da autora. Se a taxa de acerto tiver diminuido, ou tamanho da
            %sele��o n�o mudou, parar a execu��o.
            if ini>1 && (taxaAcerto > taxaAcertoaux || all(size(selecao2,1) == size(selecaoaux,1)))
                break;
            end
            ini = ini+1;
            selecao2 = selecaoaux;
            taxaAcerto = taxaAcertoaux;
        end
    end
end

%Esta � a implementa��o do pseudo-c�digo apresentado no artigo para o HMN-E
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


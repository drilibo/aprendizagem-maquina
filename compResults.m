function [ mediasAcerto, ttestPorBaseAcerto, dadosFinaisAcerto, ...
    mediasRed, ttestPorBaseRed, dadosFinaisRed ] = compResults( nome_bases )
    qntbases = size(nome_bases, 2);
    alpha = 0.05;
    tail = 'both';
    alphaW = 0.01;
    
    mediasAcerto = zeros(qntbases,7);
    mediasRed = zeros(qntbases,7);
    
    
    ttestPorBaseAcerto = zeros(qntbases, 7);
    ttestPorBaseRed = zeros(qntbases, 7);
    for i=1:qntbases,
        resultados = dlmread(['am2/resultados/' nome_bases{i} '.txt'], ' ');
        resultados = resultados * 10;
        
        for j=1:7,
            mediasAcerto(i, j) = sum(resultados(j*2 - 1, :));
            mediasRed(i, j) = sum(resultados(j*2, :));
        end
        for j=1:7,
            if j == 4,
                continue;
            end
            resT = ttest(resultados(j*2-1, :), resultados(7, :), alpha, tail);
            resTRed = ttest(resultados(j*2, :)*10, resultados(8, :)*10, alpha, tail);
            
            ttestPorBaseAcerto(i, j) = resT + 2*(resT * (-1 * (mediasAcerto(i, j) > mediasAcerto(i, 4)) ));
            ttestPorBaseRed(i, j) = resTRed + 2*(resTRed * (-1 * (mediasRed(i, j) > mediasRed(i, 4)) ));
        end
        
        if 0,
            tot_1nn(i, 1) = sum(resultados(1, :));      tot_1nn(i, 2) = sum(resultados(2, :));
            tot_hmnc(i, 1) = sum(resultados(3, :));     tot_hmnc(i, 2) = sum(resultados(4, :));
            tot_hmne(i, 1) = sum(resultados(5, :));     tot_hmne(i, 2) = sum(resultados(6, :));
            tot_hmnei(i, 1) = sum(resultados(7, :));    tot_hmnei(i, 2) = sum(resultados(8, :));
            tot_icf(i, 1) = sum(resultados(9, :));      tot_icf(i, 2) = sum(resultados(10, :));
            tot_enn(i, 1) = sum(resultados(11, :));     tot_enn(i, 2) = sum(resultados(12, :));
            tot_drop3(i, 1) = sum(resultados(13, :));   tot_drop3(i, 2) = sum(resultados(14, :));
        end
    end
    
    dadosFinaisAcerto = zeros(5, 7);
    dadosFinaisRed = zeros(5, 7);
    dadosFinaisAcerto(1, :) = mean(mediasAcerto);
    dadosFinaisAcerto(2, :) = median(mediasAcerto);
    dadosFinaisRed(1, :) = mean(mediasRed);
    dadosFinaisRed(2, :) = median(mediasRed);
    
    for i=1:7,
        if i == 4,
            continue;
        end
        [~, ret] = signrank( mediasAcerto(:, i), mediasAcerto(:, 4), 'alpha', alphaW );
        dadosFinaisAcerto(5, i) = ret + 2*(ret * (-1 * (dadosFinaisAcerto(1, i) > dadosFinaisAcerto(1, 4)) ));
        
        [~, retRed] = signrank( mediasRed(:, i), mediasRed(:, 4), 'alpha', alphaW );
        dadosFinaisRed(5, i) = retRed + 2*(retRed * (-1 * (dadosFinaisRed(1, i) > dadosFinaisRed(1, 4)) ));
        
        dadosFinaisRed(3, i) = sum(ttestPorBaseRed(:,i) == 1);
        dadosFinaisRed(4, i) = sum(ttestPorBaseRed(:,i) == -1);
        
        dadosFinaisAcerto(3, i) = sum(ttestPorBaseAcerto(:,i) == 1);
        dadosFinaisAcerto(4, i) = sum(ttestPorBaseAcerto(:,i) == -1);
        
    end
    
    
    
    
end


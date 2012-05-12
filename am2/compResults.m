% Esta função recebe os nomes das bases as quais deve gerar os testes
% estatísticos, estas bases devem ter um arquivo 'nomebase.txt' na pasta
% /resultados. É importante que todas elas estejam lá, ou haverá erro de
% execução.
% Esta função retorna todos os resultados métricos, e também gera um
% arquivo tabela.txt onde ficará toda a tabela utilizada no relatório.
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
        resultados = dlmread(['resultados/' nome_bases{i} '.txt'], ' ');
        resultados = resultados * 10;
        % A matriz resultados contem 10 colunas e 14 linhas, cada algoritmo
        % tem 2 linhas destas, uma representa a taxa de acerto e a outra a
        % redução.
        % As linhas do 1-NN são 1 e 2, HMN-C 3 e 4, HMN-E 5 e 6, HMN-EI 7 e
        % 8, ICF 9 e 10, E-NN 11, 12 e DROP3 13 e 14
        
        for j=1:7,
            mediasAcerto(i, j) = sum(resultados(j*2 - 1, :));
            mediasRed(i, j) = sum(resultados(j*2, :));
        end
        % Teste de t-Studente para cada um dos algoritmos comparando com
        % HMN-EI
        for j=1:7,
            if j == 4,
                continue;
            end
            resT = ttest(resultados(j*2-1, :), resultados(7, :), alpha, tail);
            resTRed = ttest(resultados(j*2, :)*10, resultados(8, :)*10, alpha, tail);
            
            ttestPorBaseAcerto(i, j) = resT + 2*(resT * (-1 * (mediasAcerto(i, j) > mediasAcerto(i, 4)) ));
            ttestPorBaseRed(i, j) = resTRed + 2*(resTRed * (-1 * (mediasRed(i, j) > mediasRed(i, 4)) ));
        end
        
    end
    
    % Cálculo das médias, medianas, Wilcoxon e soma das "pontuações" no
    % t-Student
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
    
    % fazer tabela
    fileID = fopen('tabela.txt', 'w');
    for i=1:qntbases
        fprintf(fileID,'%s\t', nome_bases{i});
        for j=1:7,
            if(ttestPorBaseAcerto(i, j) == 1)
                fprintf(fileID,'%.1f +\t', mediasAcerto(i, j));
            elseif(ttestPorBaseAcerto(i, j) == -1)
                fprintf(fileID,'%.1f -\t', mediasAcerto(i, j));
            else
                fprintf(fileID,'%.1f\t', mediasAcerto(i, j));
            end
            if(ttestPorBaseRed(i, j) == 1)
                fprintf(fileID,'%.1f +\t', mediasRed(i, j));
            elseif(ttestPorBaseRed(i, j) == -1)
                fprintf(fileID,'%.1f -\t', mediasRed(i, j));
            else
                fprintf(fileID,'%.1f\t', mediasRed(i, j));
            end
        end
            fprintf(fileID,'\n');
    end
    
    fprintf(fileID,'Average\t');
    for i=1:7,
        fprintf(fileID,'%.1f\t%.1f\t', dadosFinaisAcerto(1, i), dadosFinaisRed(1, i));
    end
    fprintf(fileID,'\nMedian\t');
    for i=1:7,
        fprintf(fileID,'%.1f\t%.1f\t', dadosFinaisAcerto(2, i), dadosFinaisRed(2, i));
    end
    fprintf(fileID,'\nSig.+/-\t');
    for i=1:7,
        fprintf(fileID,'%d/%d\t%d/%d\t', dadosFinaisAcerto(3, i), dadosFinaisAcerto(4, i), dadosFinaisRed(3, i), dadosFinaisRed(4, i));
    end
    fprintf(fileID,'\nWilcoxon\t');
    for i=1:7,
        if(dadosFinaisAcerto(5, i) == 1)
            fprintf(fileID,'+\t');
        elseif(dadosFinaisAcerto(5, i) == -1)
            fprintf(fileID,'-\t');
        else
            fprintf(fileID,'~\t');
        end
        if(dadosFinaisRed(5, i) == 1)
            fprintf(fileID,'+\t');
        elseif(dadosFinaisRed(5, i) == -1)
            fprintf(fileID,'-\t');
        else
            fprintf(fileID,'~\t');
        end
    end
    fprintf(fileID,'\n');
end


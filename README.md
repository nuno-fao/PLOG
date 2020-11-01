# PLOG_TP1_RI_T2_Gauss4

## Jogo: Gauss

| Name                      | Turma     | Number    | E-Mail               |
| ------------------------- | --------- | --------- | ------------------   |
| Luís Miguel Pinto         |     2     | 201806206 | up201806206@fe.up.pt |
| Nuno Oliveira             |     2     | 201806525 | up201806525@fe.up.pt |


## Descrição do Jogo
O tabuleiro do jogo é hexagonal cada espaço sendo também um hexágono:
>![tabuleiro](./img/tabuleiro.jpg)

As bordas do hexágono são mais escuras porque são chamadas de void em que a única diferença comparadas com os restantes espaços é o valor duma peça que é recolhida dessa zona (explicado em mais detalhe à frente). Cada jogador dispõe também duma zona de bónus e outra de risco para onde vão as peças depois de pontuadas.

Cada jogador dispõe de 15 peças (10 da cor dele e 5 da cor do adversário). Um à vez os jogadores colocam uma peça da cor que desejarem no tabuleiro que como um íman atrai peças de cor diferente e afasta de cor igual que já estejam na área de jogo até bater noutra peça ou na borda/void (isto afeta apenas a primeira peça em cada uma das 6 direções). 

Se após uma jogada houver 4 ou mais peças adjacentes da mesma cor, o jogador dessa cor tem de as recolher e colocar numa das duas zonas, se a peça estiver num espaço void vai para a zona de risco e caso contrário vai para a zona de bónus. 

Quando não houver mais peças para jogar o jogo acaba e as que ficaram no tabuleiro permanecem lá dado que vão ser importantes para calcular as pontuações finais. 

As pontuações são calculadas da seguinte maneira:
- Cada peça na zona bónus vale 1 ponto.
- Se no fim do jogo um jogador tiver mais peças da sua cor na zona void do que o outro este terá de subtrair um ponto por cada peça que tem na zona de risco. 
- Depois destes cálculos feitos, o jogador com mais pontos ganha.
- Em caso de empate é considerado vencedor o jogador com menos peças da sua cor em zonas void.
- Se mesmo assim houver empate é considerado vencedor o jogador com menos peças na zona de risco.
- Se o empate persistir, por improvável que seja, ambos os jogadores são considerados vencedores.

Página oficial do jogo: https://nestorgames.com/#gauss_detail

Rulebook: https://nestorgames.com/rulebooks/GAUSS_EN.pdf

## Representação Interna do Estado de Jogo

- O tabuleiro de jogo original tem 7 filas com 4 a 7 hexágonos pequenos de maneira a representar um hexágono maior. No entanto, para conseguirmos desenhar o tabuleiro como pretendido em PROLOG teremos de o desenhar na vertical (com 13 filas "intercaladas" cada uma com 1 a 4 hexágonos) o que não altera logística do jogo em si.

- Internamente ' ', 'r' e 'b' representam vazio, peça vermelha e peça azul, respetivamente. 

-  O tabuleiro será iniciado assim: 
>![tabuleiro inicial](./img/Tabuleiro1.png)


-  Numa fase intermédia do jogo o tabuleiro estaria num estado idêntico a este: 
>![tabuleiro intermédio](./img/Tabuleiro2.png)

-  O jogo acaba quando não houver mais peças para jogar e sendo assim o tabuleiro tanto pode estar completamente vazio como com várias peças mas nunca com 4 ou mais da mesma cor adjacentes. 
>![tabuleiro final](./img/Tabuleiro3.png)

- O jogador atual será guardado como um inteiro que terá o valor de 1 ou 2

- As peças dos dois jogadores serão representadas por um lista com 2 elementos cada uma representando quantas peças de cada cor tem. Essas duas listas serão guardadas numa outra lista de peças. Ex: [ [ 10, 5 ], [ 10, 5 ] ]

- Peças recolhidas serão guardadas de maneira idêntica às que ainda não foram jogadas só que cada index em vez de representar uma cor, representa área de bónus ou risco.  Ex: [ [ 8, 1 ], [ 5, 0 ] ] 

## Visualização do estado de jogo
O predicado de visualização recebe o estado de jogo e com ele um elemento que começa em 1 e vai sendo iterado para saber qual fila a desenhar. A cada fila remove-se o HEAD da cópia da lista do tabuleiro para se desenhar os valores certos. 

Acima do tabuleiro terá 4 números (2 de cada lado) para representar a quantidade de peças de cada cor dos jogadores.

Novamente dentro do tabuleiro, cada canto será identificado como zona de bónus ou risco de cada jogador e terá um inteiro que vai ser atualizado quando for necessário mover uma peça do interior do tabuleiro para lá.

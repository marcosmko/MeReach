# MindMiners Desafio

Olá!<br/><br/>

Para este projeto, foi utilizado a arquitetura CleanSwift, uma implementação da Clean Architecture de Uncle Bob. Também foram utilizados o RxSwift e RxCocoa, conforme pedido pelo enunciado.<br/><br/>

Implementei duas formas de verificar se um servidor está online: uma utiliza um algoritmo de randomização para indicar se o servidor está online. Obviamente, esse algoritmo não retrata se o servidor está de fato online ou não. O segundo algoritmo apenas realiza um GET, e caso retorne como http status 200 (ou qualquer 2xx), significa que o servidor está online.<br/><br/>

Verás também que, na minha versão de arquitetura, o Interactor é responsável para jogar toda a execução em background, enquanto o Presenter é responsável em jogar toda a sua execução para a main thread. Para isso, tornamos todas as possíveis funções assíncronas como síncronas com a ajuda de semáforos. Assim, temos um controle claro e absoluto sobre todos os processos que rodam no app.<br/><br/>

Quanto ao Rx, restringi o seu uso apenas para as ViewControllers (elementos de interface) e no interactor, como forma de observar mudanças no data store. <br/><br/>

Qualquer dúvida, me avise! 😁

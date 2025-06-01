# Projeto do Banco de Dados Transacional para Locadora de Veículos (Fonte para DW)

## 1. Visão Geral

Este repositório contém a documentação completa e os scripts SQL para o projeto do banco de dados relacional transacional (OLTP) de uma empresa fictícia de aluguel de veículos. Este sistema é projetado para suportar as operações diárias da locadora e, crucialmente, para servir como uma das fontes de dados primárias para um futuro Data Warehouse (DW) integrado.

O contexto maior deste projeto é um cenário onde seis locadoras de veículos independentes formam um consórcio para compartilhar pátios e integrar seus dados, visando obter relatórios gerenciais globais e realizar análises de dados de forma unificada. Este repositório foca no sistema de uma dessas empresas.

## 2. Conteúdo do Repositório

O repositório está organizado da seguinte forma:

* **`/documentacao`**: Contém toda a documentação do projeto do banco de dados.
    * `01_Descricao_Projeto_BD_e_Justificativa_ETL.md`: Descreve o projeto do banco de dados relacional em detalhes, incluindo a justificativa e considerações para a extração de dados (ETL/ELT) para o Data Warehouse.
    * `02_Modelo_Conceitual.md`: Apresenta o modelo conceitual da base de dados, incluindo um guia textual para a construção de um diagrama Entidade-Relacionamento (MER).
    * `03_Modelo_Logico.md`: Detalha o esquema lógico do banco de dados, com a estrutura de tabelas, colunas e relacionamentos.
    * `04_Dicionario_de_Dados.md`: Fornece um dicionário completo para todas as tabelas e atributos, incluindo a especificação das restrições de integridade.
* **`/sql_scripts`**:
    * `DDL_Schema_Locadora.sql`: Script SQL (Data Definition Language) para criar a estrutura completa do banco de dados (tabelas, chaves, restrições).
* `README.md`: Este arquivo de descrição do repositório.

## 3. Descrição do Sistema Transacional Modelado

O banco de dados foi projetado para suportar as seguintes funcionalidades centrais de uma locadora de veículos:

* **Gestão de Frota:** Cadastro e controle de `Veiculos`, `GrupoVeiculo`, `Marca`, `Modelo`, `Acessorios` e `ProntuarioManutencao`.
* **Gestão de Pátios e Vagas:** Gerenciamento dos `Patios` da empresa e das `Vagas` individuais, incluindo status e localização atual dos veículos.
* **Gestão de Clientes:** Cadastro de `Clientes` (Pessoas Físicas e Jurídicas) e `Motoristas` autorizados, incluindo dados da CNH.
* **Gestão de Reservas:** Controle de `Reservas` de veículos.
* **Gestão de Locações:** Registro e acompanhamento dos contratos de `Locacao`, incluindo `Protecoes` adicionais e `FotosVeiculoEstado`.
* **Contexto de Múltiplas Empresas:** A tabela `Empresa` permite identificar a propriedade de ativos, crucial para a futura integração no DW.

O modelo é normalizado para garantir a integridade dos dados e otimizado para operações transacionais (OLTP).

## 4. Modelo Físico e Scripts DDL

O script DDL fornecido em `/sql_scripts/DDL_Schema_Locadora.sql` contém as instruções `CREATE TABLE` e a definição de todas as restrições (Chaves Primárias, Estrangeiras, `UNIQUE`, `CHECK`). O script foi escrito utilizando sintaxe ANSI SQL, buscando ampla compatibilidade com diferentes Sistemas Gerenciadores de Banco de Dados (SGBDs) relacionais.

**Nota Importante sobre SGBDs:** A geração de chaves primárias sequenciais (auto-incremento ou identidade) pode variar entre SGBDs. O script utiliza `INTEGER PRIMARY KEY` de forma padrão. Para funcionalidades como `AUTO_INCREMENT` (MySQL), `IDENTITY` (SQL Server), ou `SERIAL`/`GENERATED AS IDENTITY` (PostgreSQL), ajustes no DDL podem ser necessários ao implementar o esquema no SGBD de sua escolha.

## 5. Documentação Detalhada

A pasta `/documentacao` é o coração informativo deste projeto, contendo:

* **Descrição Completa do Projeto e Justificativa para ETL:** Essencial para entender o propósito do banco de dados e como ele se encaixa na estratégia de BI.
* **Modelos Conceitual e Lógico:** Para uma compreensão progressiva da estrutura dos dados.
* **Dicionário de Dados:** Referência indispensável para desenvolvedores e analistas, detalhando cada elemento do banco.

## 6. Papel no Projeto de Data Warehouse

Este banco de dados transacional é um dos pilares para a construção de um Data Warehouse integrado que permitirá às seis empresas associadas:

* **Gerar Relatórios Gerenciais Unificados:** Incluindo controle de pátio, locações, reservas, e veículos mais alugados.
* **Realizar Análises Avançadas:** Como a previsão de ocupação de pátio utilizando Cadeias de Markov, que depende da extração de dados de movimentação de veículos entre os pátios.

## 7. Como Utilizar

* **DBAs e Desenvolvedores Back-end:** O script DDL pode ser usado para instanciar o esquema do banco de dados. A documentação serve como guia de referência completo.
* **Engenheiros de Dados:** A "Descrição do Projeto... e Justificativa ETL" e o "Dicionário de Dados" são fundamentais para o design e implementação de pipelines de ETL/ELT para popular o Data Warehouse.
* **Analistas de Negócios e Gerentes de Projeto:** Os modelos e a descrição geral do projeto fornecem uma visão clara dos dados que podem ser explorados e das capacidades do sistema.

## 8. Contribuições

Este projeto é um exercício de modelagem e documentação. Sugestões para melhorias, correções na documentação ou otimizações nos scripts são bem-vindas. Por favor, sinta-se à vontade para abrir uma *Issue* para discussão ou um *Pull Request* com suas contribuições.

# ⚙️ Códigos de extração RStudio
## 📑 Descrição:
Repositório destinado à **extração e tratamento automatizado de dados públicos municipais** utilizando a API do **SIDRA (IBGE)** por meio do R.
Os scripts realizam a consulta de tabelas do SIDRA, aplicação de filtros geográficos e temporais, limpeza e padronização dos dados e exportação dos resultados em formato `.csv`.

## 📚 Bibliotecas utilizadas:
- `sidrar` — acesso à API do SIDRA/IBGE;
- `dplyr` — manipulação e transformação dos dados;
- `janitor` — limpeza e padronização dos nomes das colunas.
  
## 🖥️ Fluxo da extração:
1. Consulta das informações da tabela SIDRA;
2. Definição das variáveis e períodos desejados;
3. Extração dos dados em nível municipal;
4. Aplicação de filtros geográficos;
5. Limpeza e transformação dos dados;
6. Remoção de valores ausentes;
7. Exportação dos dados tratados para `.csv`.

O projeto tem como objetivo **facilitar a obtenção e organização de indicadores públicos municipais disponibilizados pelo IBGE/SIDRA**.

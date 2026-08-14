library(sidrar)
library(janitor)
library(dplyr)
library(tidyr)

# Montando Requisição  ----------------------------------------------------

#Exibindo informações sobre a tabela
info_sidra(9509)

#Captura as variáveis necessárias pelo código: var c(1606, 10143)
codigos_variavel <- c(1606, 10143, 706)

#Faz a requisição pro Sidra com os parâmetros 
dados_brutos <- get_sidra(
  x = 9509,                             #Número da tabela
  variable = codigos_variavel,          #Código das variáveis 
  period = c(last = 3),                 #Período 
  geo = "City",                         #Nível Geográfico (Municipio)
  geo.filter = list("State" = 26)       #Filtro para Pernambuco
)

#Faz a limpeza dos nomes (retira acentos,espaços e letras maiusculas)
dados_limpos <- dados_brutos |> 
  clean_names()

#Aplica os filtros para Limpeza da tabela
dados_limpos <- dados_limpos |> 
  select(
    unidade_de_medida,        
    valor,       
    municipio_codigo,              
    municipio,
    ano,
    variavel
  ) |> 
  mutate(
    valor = as.numeric(valor),       #Muda o tipo de variável de caracter para numérico
    orgao_fonte = "IBGE/SIDRA"       #Adiciona uma coluna orgao_fonte com a descrição
  ) |> 
  filter(!is.na(valor)) |>           #Remove tudo que não possui um valor
  pivot_wider(
      names_from = unidade_de_medida,     # Pega os nomes das observações presentes naquela coluna
      values_from = valor                 # Valores correspondentes a cada observação e que preencherão novas colunas 
  ) |> 
  clean_names() |> 
  rename(salario_minimo = salarios_minimos) |> 
  relocate(salario_minimo, .after = municipio_codigo) |> 
  relocate(c(reais, unidades), .after = salario_minimo)

# Separa os tipos de dados por coluna e aplica redução de valor NA
resultado <- dados_limpos |> 
  group_by(municipio_codigo, municipio, ano) |>         #Agrupa por código de municipio, nome e ano
  
  #Resume cada grupo em uma única linha, extraindo o primeiro valor não-nulo de cada coluna
  summarise(
    salario_minimo = first(na.omit(salario_minimo)),
    salario_reais = first(na.omit(reais)),
    unidades = first(na.omit(unidades)),
    .groups = "drop"
  )

#exporta o resultado em csv
write.csv(resultado, "salario_medio_mensal.csv", row.names = FALSE, fileEncoding = "UTF-8")

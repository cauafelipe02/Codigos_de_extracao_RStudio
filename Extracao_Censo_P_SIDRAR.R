library(sidrar)
library(janitor)
library(dplyr)

# Montando Requisição  ----------------------------------------------------

#Exibindo informações sobre a tabela
info_sidra(4714)

#Captura as variáveis necessárias pelo código: var c(93, 6318, 614)
codigos_variavel <- c(93, 6318, 614)

#Faz a requisição pro Sidra com os parâmetros 
dados_brutos <- get_sidra(
  x = 4714,                             #Número da tabela
  variable = codigos_variavel,          #Código das variáveis 
  period = "2022",                      #Período 
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
  filter(!is.na(valor))              #Remove tudo que não possui um valor

#exporta o resultado em csv
write.csv(dados_limpos, "Censo_P_2022.csv", row.names = FALSE, fileEncoding = "UTF-8")

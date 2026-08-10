library(sidrar)
library(janitor)
library(dplyr)

# Montando Requisição  ----------------------------------------------------

#Exibindo informações sobre a tabela
info_sidra(5938)

#Captura as variáveis necessárias pelo código: var 1(37), 13(498), 19(513),26(517), 33(6575)
codigos_variavel <- c(37, 498, 513, 517, 6575)

#Faz a requisição pro Sidra com os parâmetros 
dados_brutos <- get_sidra(
  x = 5938,                             #Número da tabela
  variable = codigos_variavel,          #Código das variáveis 
  period = "2021",                      #Período 
  geo = "City",                         #Nível Geográfico (Municipio)
  geo.filter = list("State" = 26)       #Filtro para Pernambuco
)

#Faz a limpeza dos nomes (retira acentos,espaços e letras maiusculas)
dados_limpos <- dados_brutos |> 
  clean_names()

#Aplica os filtros para Limpeza da tabela
dados_limpos <- dados_limpos |> 
  select(
    valor,                  #Pega a coluna de valor
    municipio_codigo,       #Pega a coluna de valor
    municipio,              #Pega a coluna de valor
    ano,#Pega a coluna de valor
    variavel#Pega a coluna de valor
  ) |> 
  mutate(
    valor = as.numeric(valor),       #Muda o tipo de variável de caracter para numérico
    orgao_fonte = "IBGE/SIDRA"       #Adiciona uma coluna orgao_fonte com a descrição
  ) |> 
  filter(!is.na(valor))              #Remove tudo que não possui um valor

#exporta o resultado em csv
write.csv(dados_limpos, "PIB_Municipal_2021.csv", row.names = FALSE, fileEncoding = "UTF-8")
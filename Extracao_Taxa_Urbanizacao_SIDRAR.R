library(sidrar)
library(janitor)
library(dplyr)

# Montando Requisição  ----------------------------------------------------

#Exibindo informações sobre a tabela
info_sidra(9923)

#Captura as variáveis necessárias pelo código: var c(93, 1000093)
codigos_variavel <- c(93, 1000093)

#Faz a requisição pro Sidra com os parâmetros 
dados_brutos <- get_sidra(
  x = 9923,                             #Número da tabela
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
    variavel,
    situacao_do_domicilio
  ) |> 
  mutate(
    valor = as.numeric(valor),       #Muda o tipo de variável de caracter para numérico
    orgao_fonte = "IBGE/SIDRA"       #Adiciona uma coluna orgao_fonte com a descrição
  ) |> 
  filter(!is.na(valor))              #Remove tudo que não possui um valor

#exporta o resultado em csv
write.csv(dados_limpos, "Taxa_Urbanizacao.csv", row.names = FALSE, fileEncoding = "UTF-8")

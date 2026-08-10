library(sidrar)
library(janitor)
library(dplyr)
library(scales)

# Montando Requisição  ----------------------------------------------------

#Faz a requisição pro Sidra com os parâmetros 
dados_10261 <- get_sidra(
  x = 10261,
  variable = 4090,
  period = "2022",
  geo = "City",
  geo.filter = list(State = 26),
  classific = "c11913",
  category = list("96165")
)

dados_6580 <- get_sidra(
  x = 6580,
  variable = 1641, 
  period = "2022",
  geo = "City",
  geo.filter = list(State = 26),
  classific = "c629",
  category = list("32385")
)


#Junta as duas tabelas e ajusta as informações por código de município
dados_brutos <- dados_10261 |> 
  left_join(
    dados_6580,
    by = "Município (Código)"
  )

#faz a limpesa dos dados brutos
dados_limpos <- dados_brutos |> 
  clean_names()

#Aplica os filtros para Limpeza da tabela
dados_limpos <- dados_limpos |> 
  select(
    unidade_de_medida = unidade_de_medida_x,        
    valor_x,
    valor_y,
    municipio_codigo,              
    municipio = municipio_x,
    ano = ano_x,
    variavel_x,
    variavel_y
  ) |> 
  filter(
    !is.na(valor_x) & !is.na(valor_y)
  ) |> 
  mutate(
    valor_x = as.numeric(valor_x),
    valor_y = as.numeric(valor_y),  #Muda o tipo de variável de caracter para numérico
    taxa_ocupacao = (valor_x/valor_y),  #Exibe o número de ocupação
    ocupacao_percentual = percent(valor_x/valor_y, accuracy = 0.01), #exibe o percentual da taxa de ocupação
    orgao_fonte = "IBGE/SIDRA"  #Adiciona uma coluna orgao_fonte com a descrição
  )  

#exporta o resultado em csv
write.csv(dados_limpos, "Pessoas_ocupadas_absoluta.csv", row.names = FALSE, fileEncoding = "UTF-8")
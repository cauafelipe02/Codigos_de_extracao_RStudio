library(purrr)
library(httr)
library(dplyr)

# Captura de dados --------------------------------------------------------

#Armasena a URL para solicitação
base_da_url <- "https://servicodados.ibge.gov.br/api/v1/localidades/estados/"
base_dados <- "26/municipios"
url <- paste0(base_da_url,base_dados)

#Envia uma solicitação e armazena a resposta
resp <- GET(
  url,
  query = list(
    orderBy = "nome"
    )
)
cont <- httr::content(resp)

#Compila tudo em um único DF
resultado <- purrr::map_dfr(cont, as.data.frame)

#Separa a coluna dos códigos (ID)
codigos_municipios <- resultado |> 
  filter(id != "2605459") |>
  rename(municipios = nome) |> 
  select(id, municipios)

#Exporta isso em um arquivo csv
write.csv(codigos_municipios, "codigos_municipios.csv", row.names = FALSE, fileEncoding = "UTF-8")
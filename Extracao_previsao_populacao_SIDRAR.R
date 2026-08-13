library(dplyr)
library(sidrar)
library(janitor)

# Captura de dados -------------------------------------------------------

info_sidra(7358)

dados_brutos <- get_sidra(
  x = 7358,
  variable = 606,
  period = "2018",
  geo = "Brazil",
  classific = c("c2", "c287", "c1933"),
  category = list(
    "6794", 
    "100362", 
    as.character(seq(49041, 49076))
    )
)

# Filtragem de dados ------------------------------------------------------

dados_limpos <- dados_brutos |> 
  clean_names() |> 
  rename(ano_previsao = ano_2) |> 
  relocate(ano_previsao, .after = brasil) |> 
  select(
    unidade_de_medida,
    valor,
    brasil,
    ano_previsao,
    variavel
  )

# Exporta em CSV
write.csv(dados_limpos, "previsao_populacao_2060.csv", row.names = FALSE, fileEncoding = "UTF-8")
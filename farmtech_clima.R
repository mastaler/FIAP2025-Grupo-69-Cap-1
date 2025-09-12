# ============================================
# Sistema Meteorológico com API REAL - FarmTech
# Versão com múltiplas opções de API
# ============================================

# Verificar e instalar pacotes necessários
pacotes <- c("httr", "jsonlite")
novos_pacotes <- pacotes[!(pacotes %in% installed.packages()[,"Package"])]

if(length(novos_pacotes) > 0) {
  cat("📦 Instalando pacotes necessários...\n")
  install.packages(novos_pacotes, repos = "http://cran.r-project.org")
}

library(httr)
library(jsonlite)

# ============================================
# OPÇÃO 1: WTTR.IN (Mais simples, sem chave)
# ============================================

buscar_clima_wttr <- function(cidade = "Sao_Paulo") {
  cat("\n🌤️  BUSCANDO DADOS METEOROLÓGICOS (wttr.in)...\n")
  cat("============================================\n")
  
  # Formatar cidade para URL
  cidade_url <- gsub(" ", "_", cidade)
  
  # URL simples do wttr.in
  url <- paste0("http://wttr.in/", cidade_url, "?format=%C+%t+%h+%p+%w")
  
  tryCatch({
    # Fazer requisição
    resposta <- GET(url, timeout(10))
    
    if (status_code(resposta) == 200) {
      # Obter texto da resposta
      dados_texto <- content(resposta, "text", encoding = "UTF-8")
      
      cat("\n✅ DADOS OBTIDOS COM SUCESSO!\n")
      cat("================================\n")
      cat(sprintf("📍 LOCAL: %s\n", gsub("_", " ", cidade)))
      cat(sprintf("🌤️  Condições: %s\n", dados_texto))
      
      # Buscar dados mais detalhados em JSON
      url_json <- paste0("http://wttr.in/", cidade_url, "?format=j1")
      resposta_json <- GET(url_json, timeout(10))
      
      if (status_code(resposta_json) == 200) {
        dados <- fromJSON(content(resposta_json, "text", encoding = "UTF-8"))
        atual <- dados$current_condition[[1]]
        
        cat("\n📊 DADOS DETALHADOS:\n")
        cat("--------------------\n")
        cat(sprintf("   Temperatura: %s°C\n", atual$temp_C))
        cat(sprintf("   Sensação térmica: %s°C\n", atual$FeelsLikeC))
        cat(sprintf("   Umidade: %s%%\n", atual$humidity))
        cat(sprintf("   Precipitação: %s mm\n", atual$precipMM))
        cat(sprintf("   Vento: %s km/h\n", atual$windspeedKmph))
        cat(sprintf("   Pressão: %s mb\n", atual$pressure))
        
        # Análise agrícola
        analisar_agricultura(
          as.numeric(atual$temp_C),
          as.numeric(atual$humidity),
          as.numeric(atual$precipMM)
        )
        
        return(invisible(dados))
      }
      
    } else {
      cat("❌ Erro ao conectar. Status:", status_code(resposta), "\n")
      return(NULL)
    }
    
  }, error = function(e) {
    cat("❌ Erro de conexão com wttr.in\n")
    cat("   Tentando método alternativo...\n")
    return(NULL)
  })
}

# ============================================
# OPÇÃO 2: OPENWEATHERMAP (Precisa de chave gratuita)
# ============================================

buscar_clima_openweather <- function(cidade = "São Paulo", api_key = "516babefc3a7bc3a80f4f1b4ea86384c") {
  if (is.null(api_key)) {
    cat("\n⚠️  OPENWEATHERMAP PRECISA DE CHAVE DE API\n")
    cat("=========================================\n")
    cat("Para obter uma chave GRATUITA:\n")
    cat("1. Acesse: https://openweathermap.org/api\n")
    cat("2. Crie uma conta gratuita\n")
    cat("3. Copie sua API key\n")
    cat("4. Use: buscar_clima_openweather('São Paulo', '516babefc3a7bc3a80f4f1b4ea86384c')\n")
    return(NULL)
  }
  
  cat("\n🌤️  BUSCANDO DADOS (OpenWeatherMap)...\n")
  
  # URL da API
  url <- sprintf(
    "https://api.openweathermap.org/data/2.5/weather?q=%s,BR&appid=%s&units=metric&lang=pt_br",
    URLencode(cidade),
    api_key
  )
  
  tryCatch({
    resposta <- GET(url, timeout(10))
    
    if (status_code(resposta) == 200) {
      dados <- fromJSON(content(resposta, "text", encoding = "UTF-8"))
      
      cat("\n✅ DADOS OBTIDOS COM SUCESSO!\n")
      cat("================================\n")
      cat(sprintf("📍 LOCAL: %s\n", dados$name))
      cat(sprintf("🌤️  Condição: %s\n", dados$weather[[1]]$description))
      
      cat("\n📊 DADOS ATUAIS:\n")
      cat("----------------\n")
      cat(sprintf("   Temperatura: %.1f°C\n", dados$main$temp))
      cat(sprintf("   Sensação: %.1f°C\n", dados$main$feels_like))
      cat(sprintf("   Umidade: %d%%\n", dados$main$humidity))
      cat(sprintf("   Pressão: %d hPa\n", dados$main$pressure))
      cat(sprintf("   Vento: %.1f km/h\n", dados$wind$speed * 3.6))
      
      # Análise agrícola
      analisar_agricultura(
        dados$main$temp,
        dados$main$humidity,
        0  # OpenWeather não retorna precipitação atual
      )
      
      return(invisible(dados))
      
    } else {
      cat("❌ Erro. Verifique sua chave de API.\n")
      return(NULL)
    }
    
  }, error = function(e) {
    cat("❌ Erro de conexão\n")
    return(NULL)
  })
}

# ============================================
# OPÇÃO 3: DADOS DE ARQUIVO LOCAL (Fallback)
# ============================================

usar_dados_locais <- function(cidade = "São Paulo") {
  cat("\n📁 USANDO DADOS DE EXEMPLO (LOCAL)...\n")
  cat("====================================\n")
  
  # Criar dados de exemplo baseados em médias reais
  dados_exemplo <- list(
    "São Paulo" = list(temp = 22, umid = 70, chuva = 3.5),
    "Campinas" = list(temp = 23, umid = 68, chuva = 3.2),
    "Ribeirão Preto" = list(temp = 25, umid = 65, chuva = 2.8),
    "Rio de Janeiro" = list(temp = 26, umid = 75, chuva = 4.1),
    "Curitiba" = list(temp = 18, umid = 78, chuva = 4.5),
    "Porto Alegre" = list(temp = 20, umid = 76, chuva = 4.0)
  )
  
  # Selecionar dados da cidade
  if (cidade %in% names(dados_exemplo)) {
    dados <- dados_exemplo[[cidade]]
  } else {
    dados <- dados_exemplo[["São Paulo"]]
  }
  
  # Adicionar variação aleatória
  set.seed(as.numeric(Sys.time()) %% 1000)
  dados$temp <- dados$temp + runif(1, -3, 3)
  dados$umid <- dados$umid + runif(1, -10, 10)
  dados$chuva <- max(0, dados$chuva + runif(1, -2, 2))
  
  cat(sprintf("📍 LOCAL: %s\n", cidade))
  cat("(Dados baseados em médias históricas)\n")
  cat("\n📊 CONDIÇÕES:\n")
  cat("--------------\n")
  cat(sprintf("   Temperatura: %.1f°C\n", dados$temp))
  cat(sprintf("   Umidade: %.0f%%\n", dados$umid))
  cat(sprintf("   Precipitação: %.1f mm\n", dados$chuva))
  
  # Análise agrícola
  analisar_agricultura(dados$temp, dados$umid, dados$chuva)
  
  return(invisible(dados))
}

# ============================================
# ANÁLISE AGRÍCOLA (Comum a todos os métodos)
# ============================================

analisar_agricultura <- function(temp, umidade, precipitacao) {
  cat("\n🌱 ANÁLISE PARA AGRICULTURA:\n")
  cat("============================\n")
  
  # Análise para CAFÉ
  cat("\n☕ CAFÉ:\n")
  if (temp >= 18 && temp <= 24) {
    cat("   ✅ Temperatura ideal (18-24°C)\n")
  } else if (temp < 18) {
    cat(sprintf("   ⚠️  Temperatura baixa (%.1f°C) - risco de geada\n", temp))
  } else {
    cat(sprintf("   ⚠️  Temperatura alta (%.1f°C) - estresse térmico\n", temp))
  }
  
  if (umidade >= 60 && umidade <= 80) {
    cat("   ✅ Umidade adequada (60-80%)\n")
  } else if (umidade < 60) {
    cat(sprintf("   ⚠️  Umidade baixa (%.0f%%) - irrigar\n", umidade))
  } else {
    cat(sprintf("   ⚠️  Umidade alta (%.0f%%) - risco de fungos\n", umidade))
  }
  
  # Análise para MILHO
  cat("\n🌽 MILHO:\n")
  if (temp >= 20 && temp <= 30) {
    cat("   ✅ Temperatura ideal (20-30°C)\n")
  } else if (temp < 20) {
    cat(sprintf("   ⚠️  Temperatura baixa (%.1f°C) - crescimento lento\n", temp))
  } else {
    cat(sprintf("   ⚠️  Temperatura alta (%.1f°C) - estresse\n", temp))
  }
  
  if (precipitacao > 0 && precipitacao < 10) {
    cat("   ✅ Precipitação adequada\n")
  } else if (precipitacao == 0) {
    cat("   ⚠️  Sem chuva - verificar irrigação\n")
  } else {
    cat(sprintf("   ⚠️  Chuva forte (%.1f mm) - erosão\n", precipitacao))
  }
  
  # Recomendações gerais
  cat("\n📝 RECOMENDAÇÕES:\n")
  cat("-----------------\n")
  
  if (temp < 10) {
    cat("   ⚠️  Proteger culturas sensíveis (geada)\n")
  }
  if (umidade > 85 && temp > 20) {
    cat("   ⚠️  Monitorar doenças fúngicas\n")
  }
  if (precipitacao > 15) {
    cat("   ⚠️  Adiar aplicação de defensivos\n")
  }
  if (temp > 30) {
    cat("   ⚠️  Aumentar frequência de irrigação\n")
  }
}

# ============================================
# MENU PRINCIPAL
# ============================================

menu_principal <- function() {
  cat("\n=====================================\n")
  cat("🌤️  SISTEMA METEOROLÓGICO FARMTECH\n")
  cat("     Com Conexão a API Externa\n")
  cat("=====================================\n")
  
  cidade_atual <- "São Paulo"
  api_key <- "516babefc3a7bc3a80f4f1b4ea86384c"
  continuar <- TRUE
  
  while(continuar) {
    cat("\n📋 MENU PRINCIPAL:\n")
    cat("1 - Buscar clima (API wttr.in)\n")
    cat("2 - Usar dados de exemplo\n")
    cat("3 - Mudar cidade\n")
    cat("4 - Sair\n\n")
    
    cat(sprintf("📍 Cidade: %s\n", cidade_atual))
    opcao <- readline("Escolha (1-7): ")
    
    if (opcao == "1") {
      resultado <- buscar_clima_wttr(gsub(" ", "_", cidade_atual))
      if (is.null(resultado)) {
        cat("\n⚠️  Falha na conexão. Usando dados locais...\n")
        usar_dados_locais(cidade_atual)
      }
      
    } else if (opcao == "2") {
      usar_dados_locais(cidade_atual)
      
    } else if (opcao == "3") {
      cat("\n📍 CIDADES DISPONÍVEIS:\n")
      cidades <- c("São Paulo", "Campinas", "Ribeirão Preto",
                   "Rio de Janeiro", "Curitiba", "Porto Alegre")
      for (i in 1:length(cidades)) {
        cat(sprintf("%d - %s\n", i, cidades[i]))
      }
      cat("\nEscolha (1-6): ")
      escolha <- as.integer(readline())
      if (!is.na(escolha) && escolha >= 1 && escolha <= 6) {
        cidade_atual <- cidades[escolha]
        cat(sprintf("✅ Cidade: %s\n", cidade_atual))
      }
      
    } else if (opcao == "4") {
      cat("\n👋 Encerrando sistema...\n")
      cat("   FarmTech Solutions\n\n")
      continuar <- FALSE
      
    } else {
      cat("❌ Opção inválida!\n")
    }
    
    if (continuar && opcao %in% c("1", "2", "3", "4")) {
      cat("\nPressione ENTER para continuar...")
      readline()
    }
  }
}

# ============================================
# EXECUTAR PROGRAMA
# ============================================

cat("\n🌱 FarmTech Solutions\n")
cat("Sistema Meteorológico com API Externa\n")
cat("=====================================\n")

cat("\n📡 MÉTODOS DISPONÍVEIS:\n")
cat("   1. API wttr.in (sem cadastro)\n")
cat("   2. OpenWeatherMap (precisa chave)\n")
cat("   3. Dados de exemplo (sempre funciona)\n")

cat("\n💡 DICA: Use a opção 1 primeiro!\n")

# Executar menu
menu_principal()

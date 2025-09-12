# ============================================
# Sistema de Análise Estatística - FarmTech Solutions
# Análise de dados agrícolas em R
# ============================================

# Limpar ambiente
rm(list = ls())

# ============================================
# ENTRADA DE DADOS
# ============================================

cat("=========================================\n")
cat("   ANÁLISE ESTATÍSTICA - FARMTECH\n")
cat("=========================================\n\n")

# Função para entrada segura de dados numéricos
entrada_numerica <- function(mensagem) {
  while(TRUE) {
    cat(mensagem)
    valor <- readline()
    valor_num <- suppressWarnings(as.numeric(valor))
    if (!is.na(valor_num) && valor_num > 0) {
      return(valor_num)
    }
    cat("❌ Erro: Digite um número válido maior que zero!\n")
  }
}

# Menu principal
menu_principal <- function() {
  cat("\n📊 OPÇÕES DE ANÁLISE:\n")
  cat("1 - Análise de Áreas de Plantio\n")
  cat("2 - Análise de Consumo de Insumos\n")
  cat("3 - Análise Comparativa (Café vs Milho)\n")
  cat("4 - Sair\n\n")
  
  opcao <- readline("Escolha uma opção (1-4): ")
  return(opcao)
}

# ============================================
# ANÁLISE DE ÁREAS
# ============================================

analise_areas <- function() {
  cat("\n📐 ANÁLISE DE ÁREAS DE PLANTIO\n")
  cat("--------------------------------\n")
  
  # Coleta quantidade de amostras
  n <- as.integer(entrada_numerica("Quantas áreas deseja analisar? "))
  
  # Vetor para armazenar as áreas
  areas <- numeric(n)
  culturas <- character(n)
  
  # Coleta dados de cada área
  for (i in 1:n) {
    cat(paste("\n📍 Área", i, ":\n"))
    areas[i] <- entrada_numerica("   Digite a área em m²: ")
    
    cat("   Tipo de cultura (1-Café, 2-Milho): ")
    tipo <- readline()
    culturas[i] <- ifelse(tipo == "1", "Café", "Milho")
  }
  
  # Cálculos estatísticos
  cat("\n📈 RESULTADOS ESTATÍSTICOS:\n")
  cat("============================\n")
  
  # Média
  media_area <- mean(areas)
  cat(sprintf("📊 Média das áreas: %.2f m²\n", media_area))
  cat(sprintf("   Equivalente a: %.2f hectares\n", media_area/10000))
  
  # Mediana
  mediana_area <- median(areas)
  cat(sprintf("📊 Mediana das áreas: %.2f m²\n", mediana_area))
  
  # Desvio padrão
  desvio_area <- sd(areas)
  cat(sprintf("📊 Desvio padrão: %.2f m²\n", desvio_area))
  
  # Coeficiente de variação
  cv <- (desvio_area / media_area) * 100
  cat(sprintf("📊 Coeficiente de variação: %.2f%%\n", cv))
  
  # Valores mínimo e máximo
  cat(sprintf("📊 Área mínima: %.2f m²\n", min(areas)))
  cat(sprintf("📊 Área máxima: %.2f m²\n", max(areas)))
  
  # Amplitude
  amplitude <- max(areas) - min(areas)
  cat(sprintf("📊 Amplitude: %.2f m²\n", amplitude))
  
  # Análise por cultura
  cat("\n📊 ANÁLISE POR CULTURA:\n")
  cat("------------------------\n")
  
  # Contagem por tipo
  cafe_count <- sum(culturas == "Café")
  milho_count <- sum(culturas == "Milho")
  
  cat(sprintf("☕ Áreas de Café: %d (%.1f%%)\n", 
              cafe_count, (cafe_count/n)*100))
  cat(sprintf("🌽 Áreas de Milho: %d (%.1f%%)\n", 
              milho_count, (milho_count/n)*100))
  
  # Médias por cultura se houver dados
  if (cafe_count > 0) {
    media_cafe <- mean(areas[culturas == "Café"])
    cat(sprintf("☕ Média Café: %.2f m²\n", media_cafe))
  }
  
  if (milho_count > 0) {
    media_milho <- mean(areas[culturas == "Milho"])
    cat(sprintf("🌽 Média Milho: %.2f m²\n", media_milho))
  }
  
  # Criar gráfico simples no terminal
  cat("\n📊 DISTRIBUIÇÃO VISUAL:\n")
  cat("----------------------\n")
  hist_data <- hist(areas, plot = FALSE)
  for (i in 1:length(hist_data$counts)) {
    cat(sprintf("[%.0f-%.0f]: ", 
                hist_data$breaks[i], 
                hist_data$breaks[i+1]))
    cat(rep("█", hist_data$counts[i]))
    cat(sprintf(" (%d)\n", hist_data$counts[i]))
  }
  
  return(list(areas = areas, culturas = culturas))
}

# ============================================
# ANÁLISE DE INSUMOS
# ============================================

analise_insumos <- function() {
  cat("\n💧 ANÁLISE DE CONSUMO DE INSUMOS\n")
  cat("---------------------------------\n")
  
  # Coleta quantidade de amostras
  n <- as.integer(entrada_numerica("Quantos registros de insumo deseja analisar? "))
  
  # Vetores para armazenar os dados
  quantidades <- numeric(n)
  tipos_insumo <- character(n)
  culturas <- character(n)
  
  # Coleta dados
  for (i in 1:n) {
    cat(paste("\n📍 Registro", i, ":\n"))
    
    cat("   Cultura (1-Café, 2-Milho): ")
    tipo_cultura <- readline()
    culturas[i] <- ifelse(tipo_cultura == "1", "Café", "Milho")
    
    if (culturas[i] == "Café") {
      quantidades[i] <- entrada_numerica("   Quantidade de insumo (litros): ")
      cat("   Tipo (1-Fosfato, 2-Fungicida, 3-Herbicida): ")
      tipo <- readline()
      tipos_insumo[i] <- switch(tipo, 
                                "1" = "Fosfato",
                                "2" = "Fungicida", 
                                "3" = "Herbicida",
                                "Fosfato")
    } else {
      quantidades[i] <- entrada_numerica("   Quantidade de insumo (kg): ")
      cat("   Tipo (1-Nitrogênio, 2-Fósforo, 3-Potássio): ")
      tipo <- readline()
      tipos_insumo[i] <- switch(tipo,
                                "1" = "Nitrogênio",
                                "2" = "Fósforo",
                                "3" = "Potássio",
                                "Nitrogênio")
    }
  }
  
  # Estatísticas gerais
  cat("\n📈 RESULTADOS ESTATÍSTICOS:\n")
  cat("============================\n")
  
  # Separar por cultura para análise
  cafe_idx <- culturas == "Café"
  milho_idx <- culturas == "Milho"
  
  # Análise para Café
  if (sum(cafe_idx) > 0) {
    cat("\n☕ CAFÉ (em litros):\n")
    quant_cafe <- quantidades[cafe_idx]
    cat(sprintf("   Média: %.2f L\n", mean(quant_cafe)))
    cat(sprintf("   Desvio padrão: %.2f L\n", sd(quant_cafe)))
    cat(sprintf("   Mínimo: %.2f L\n", min(quant_cafe)))
    cat(sprintf("   Máximo: %.2f L\n", max(quant_cafe)))
    cat(sprintf("   Total consumido: %.2f L\n", sum(quant_cafe)))
  }
  
  # Análise para Milho
  if (sum(milho_idx) > 0) {
    cat("\n🌽 MILHO (em kg):\n")
    quant_milho <- quantidades[milho_idx]
    cat(sprintf("   Média: %.2f kg\n", mean(quant_milho)))
    cat(sprintf("   Desvio padrão: %.2f kg\n", sd(quant_milho)))
    cat(sprintf("   Mínimo: %.2f kg\n", min(quant_milho)))
    cat(sprintf("   Máximo: %.2f kg\n", max(quant_milho)))
    cat(sprintf("   Total consumido: %.2f kg\n", sum(quant_milho)))
  }
  
  # Análise por tipo de insumo
  cat("\n📊 CONSUMO POR TIPO DE INSUMO:\n")
  cat("-------------------------------\n")
  
  insumos_unicos <- unique(tipos_insumo)
  for (insumo in insumos_unicos) {
    idx <- tipos_insumo == insumo
    cultura_principal <- culturas[idx][1]
    unidade <- ifelse(cultura_principal == "Café", "L", "kg")
    
    cat(sprintf("%s: %.2f %s (média), %.2f %s (total)\n",
                insumo,
                mean(quantidades[idx]),
                unidade,
                sum(quantidades[idx]),
                unidade))
  }
  
  return(list(quantidades = quantidades, 
              tipos = tipos_insumo, 
              culturas = culturas))
}

# ============================================
# ANÁLISE COMPARATIVA
# ============================================

analise_comparativa <- function() {
  cat("\n🔄 ANÁLISE COMPARATIVA CAFÉ vs MILHO\n")
  cat("-------------------------------------\n")
  
  # Coleta dados para café
  cat("\n☕ DADOS DO CAFÉ:\n")
  n_cafe <- as.integer(entrada_numerica("Quantas amostras de café? "))
  areas_cafe <- numeric(n_cafe)
  
  for (i in 1:n_cafe) {
    areas_cafe[i] <- entrada_numerica(paste("   Área", i, "(m²): "))
  }
  
  # Coleta dados para milho
  cat("\n🌽 DADOS DO MILHO:\n")
  n_milho <- as.integer(entrada_numerica("Quantas amostras de milho? "))
  areas_milho <- numeric(n_milho)
  
  for (i in 1:n_milho) {
    areas_milho[i] <- entrada_numerica(paste("   Área", i, "(m²): "))
  }
  
  # Análise estatística comparativa
  cat("\n📊 RESULTADOS COMPARATIVOS:\n")
  cat("============================\n")
  
  # Médias
  media_cafe <- mean(areas_cafe)
  media_milho <- mean(areas_milho)
  cat(sprintf("\n📈 MÉDIAS:\n"))
  cat(sprintf("   ☕ Café: %.2f m² (%.2f ha)\n", 
              media_cafe, media_cafe/10000))
  cat(sprintf("   🌽 Milho: %.2f m² (%.2f ha)\n", 
              media_milho, media_milho/10000))
  cat(sprintf("   Diferença: %.2f m²\n", abs(media_cafe - media_milho)))
  
  # Desvios padrão
  desvio_cafe <- sd(areas_cafe)
  desvio_milho <- sd(areas_milho)
  cat(sprintf("\n📊 DESVIOS PADRÃO:\n"))
  cat(sprintf("   ☕ Café: %.2f m²\n", desvio_cafe))
  cat(sprintf("   🌽 Milho: %.2f m²\n", desvio_milho))
  
  # Coeficiente de variação
  cv_cafe <- (desvio_cafe / media_cafe) * 100
  cv_milho <- (desvio_milho / media_milho) * 100
  cat(sprintf("\n📊 COEFICIENTE DE VARIAÇÃO:\n"))
  cat(sprintf("   ☕ Café: %.2f%%\n", cv_cafe))
  cat(sprintf("   🌽 Milho: %.2f%%\n", cv_milho))
  
  # Qual cultura tem maior variabilidade?
  if (cv_cafe > cv_milho) {
    cat("\n⚠️  O Café apresenta maior variabilidade nas áreas!\n")
  } else if (cv_milho > cv_cafe) {
    cat("\n⚠️  O Milho apresenta maior variabilidade nas áreas!\n")
  } else {
    cat("\n⚠️  Ambas culturas têm variabilidade similar!\n")
  }
  
  # Teste estatístico simples (comparação de médias)
  if (n_cafe >= 2 && n_milho >= 2) {
    cat("\n📊 TESTE DE HIPÓTESE:\n")
    cat("   H0: As médias são iguais\n")
    cat("   H1: As médias são diferentes\n")
    
    # Teste t de Student
    teste_t <- t.test(areas_cafe, areas_milho)
    cat(sprintf("   Valor-p: %.4f\n", teste_t$p.value))
    
    if (teste_t$p.value < 0.05) {
      cat("   ✅ Diferença estatisticamente significativa (p < 0.05)\n")
    } else {
      cat("   ❌ Diferença não é estatisticamente significativa (p >= 0.05)\n")
    }
  }
  
  # Visualização comparativa no terminal
  cat("\n📊 DISTRIBUIÇÃO VISUAL:\n")
  cat("----------------------\n")
  cat("☕ Café:  ")
  cat(rep("█", round(media_cafe/1000)))
  cat(sprintf(" (%.0f m²)\n", media_cafe))
  cat("🌽 Milho: ")
  cat(rep("█", round(media_milho/1000)))
  cat(sprintf(" (%.0f m²)\n", media_milho))
}

# ============================================
# PROGRAMA PRINCIPAL
# ============================================

# Loop principal do programa
executar_programa <- function() {
  cat("\n🌱 BEM-VINDO AO SISTEMA DE ANÁLISE FARMTECH! 🌱\n")
  
  continuar <- TRUE
  
  while(continuar) {
    opcao <- menu_principal()
    
    if (opcao == "1") {
      analise_areas()
    } else if (opcao == "2") {
      analise_insumos()
    } else if (opcao == "3") {
      analise_comparativa()
    } else if (opcao == "4") {
      cat("\n👋 Obrigado por usar FarmTech Solutions!\n")
      cat("   Agricultura Digital é o futuro! 🚜\n\n")
      continuar <- FALSE
    } else {
      cat("❌ Opção inválida! Tente novamente.\n")
    }
    
    if (continuar && opcao %in% c("1", "2", "3")) {
      cat("\n")
      cat("Pressione ENTER para continuar...")
      readline()
    }
  }
}

# Executar o programa
executar_programa()

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Sistema de Gerenciamento Agrícola - FarmTech Solutions
Desenvolvido para suportar agricultura digital
Culturas suportadas: Café e Milho
"""

import math
import os
import time

# ========================================
# VETORES GLOBAIS PARA ARMAZENAR OS DADOS
# ========================================
culturas = []           # Tipo de cultura (café ou milho)
areas_plantio = []      # Áreas calculadas em m²
insumos_tipo = []       # Tipo de insumo usado
insumos_quantidade = [] # Quantidade total de insumo necessária
datas_registro = []     # Data de registro dos dados

# ========================================
# FUNÇÕES AUXILIARES
# ========================================

def limpar_tela():
    """Limpa a tela do terminal"""
    os.system('cls' if os.name == 'nt' else 'clear')

def pausar():
    """Pausa a execução esperando o usuário pressionar Enter"""
    input("\nPressione ENTER para continuar...")

def validar_numero(mensagem, tipo=float, minimo=0):
    """
    Valida entrada numérica do usuário
    
    Parâmetros:
    - mensagem: texto a ser exibido
    - tipo: tipo de dado (int ou float)
    - minimo: valor mínimo aceito
    """
    while True:
        try:
            valor = tipo(input(mensagem))
            if valor > minimo:
                return valor
            else:
                print(f"❌ Erro: O valor deve ser maior que {minimo}")
        except ValueError:
            print("❌ Erro: Digite um número válido!")

# ========================================
# FUNÇÕES DE CÁLCULO
# ========================================

def calcular_area_retangular(comprimento, largura):
    """
    Calcula área retangular (usado para café)
    
    Parâmetros:
    - comprimento: comprimento do talhão em metros
    - largura: largura do talhão em metros
    
    Retorna:
    - área em metros quadrados
    """
    return comprimento * largura

def calcular_area_circular(raio):
    """
    Calcula área circular (usado para milho - pivô central)
    
    Parâmetros:
    - raio: raio do pivô em metros
    
    Retorna:
    - área em metros quadrados
    """
    return math.pi * (raio ** 2)

def calcular_insumo_cafe(area, ml_por_metro, num_ruas, comprimento_rua):
    """
    Calcula quantidade de insumo para café
    
    Parâmetros:
    - area: área total plantada em m²
    - ml_por_metro: quantidade de produto em mL por metro linear
    - num_ruas: número de ruas na lavoura
    - comprimento_rua: comprimento de cada rua em metros
    
    Retorna:
    - quantidade total de insumo em litros
    """
    # Calcula o total de metros lineares
    metros_lineares_total = num_ruas * comprimento_rua
    
    # Calcula quantidade em mL e converte para litros
    quantidade_ml = metros_lineares_total * ml_por_metro
    quantidade_litros = quantidade_ml / 1000
    
    return quantidade_litros

def calcular_insumo_milho(area, kg_por_hectare):
    """
    Calcula quantidade de insumo para milho
    
    Parâmetros:
    - area: área total plantada em m²
    - kg_por_hectare: quantidade de produto em kg por hectare
    
    Retorna:
    - quantidade total de insumo em kg
    """
    # Converte área de m² para hectares (1 hectare = 10.000 m²)
    area_hectares = area / 10000
    
    # Calcula quantidade total
    quantidade_kg = area_hectares * kg_por_hectare
    
    return quantidade_kg

# ========================================
# FUNÇÕES DO MENU PRINCIPAL
# ========================================

def entrada_dados():
    """Função para entrada de novos dados no sistema"""
    limpar_tela()
    print("=" * 50)
    print("       ENTRADA DE DADOS - FARMTECH")
    print("=" * 50)
    
    # Escolha da cultura
    print("\n📌 TIPO DE CULTURA:")
    print("1 - Café ☕")
    print("2 - Milho 🌽")
    
    while True:
        escolha = input("\nEscolha a cultura (1 ou 2): ")
        if escolha in ['1', '2']:
            break
        print("❌ Opção inválida! Digite 1 ou 2.")
    
    if escolha == '1':
        # CAFÉ - Área retangular
        print("\n☕ CULTURA: CAFÉ")
        print("-" * 30)
        
        culturas.append("Café")
        
        # Cálculo da área
        print("\n📐 CÁLCULO DA ÁREA (Formato Retangular)")
        comprimento = validar_numero("Digite o comprimento do talhão (metros): ")
        largura = validar_numero("Digite a largura do talhão (metros): ")
        area = calcular_area_retangular(comprimento, largura)
        areas_plantio.append(area)
        
        print(f"\n✅ Área calculada: {area:,.2f} m²")
        print(f"   Equivalente a: {area/10000:,.2f} hectares")
        
        # Cálculo de insumos
        print("\n💧 CÁLCULO DE INSUMOS")
        print("Produtos disponíveis:")
        print("1 - Fosfato")
        print("2 - Fungicida")
        print("3 - Herbicida")
        
        produto = input("Escolha o produto (1, 2 ou 3): ")
        produtos_nomes = {
            '1': 'Fosfato',
            '2': 'Fungicida', 
            '3': 'Herbicida'
        }
        nome_produto = produtos_nomes.get(produto, 'Fosfato')
        insumos_tipo.append(nome_produto)
        
        print(f"\nProduto selecionado: {nome_produto}")
        ml_por_metro = validar_numero("Quantidade em mL por metro linear: ")
        num_ruas = validar_numero("Número de ruas na lavoura: ", int)
        comprimento_rua = validar_numero("Comprimento médio de cada rua (metros): ")
        
        quantidade = calcular_insumo_cafe(area, ml_por_metro, num_ruas, comprimento_rua)
        insumos_quantidade.append(quantidade)
        
        print(f"\n✅ Quantidade necessária: {quantidade:,.2f} litros")
        
    else:
        # MILHO - Área circular (pivô)
        print("\n🌽 CULTURA: MILHO")
        print("-" * 30)
        
        culturas.append("Milho")
        
        # Cálculo da área
        print("\n📐 CÁLCULO DA ÁREA (Pivô Central Circular)")
        raio = validar_numero("Digite o raio do pivô (metros): ")
        area = calcular_area_circular(raio)
        areas_plantio.append(area)
        
        print(f"\n✅ Área calculada: {area:,.2f} m²")
        print(f"   Equivalente a: {area/10000:,.2f} hectares")
        
        # Cálculo de insumos
        print("\n💧 CÁLCULO DE INSUMOS")
        print("Produtos disponíveis:")
        print("1 - Nitrogênio")
        print("2 - Fósforo")
        print("3 - Potássio")
        
        produto = input("Escolha o produto (1, 2 ou 3): ")
        produtos_nomes = {
            '1': 'Nitrogênio',
            '2': 'Fósforo',
            '3': 'Potássio'
        }
        nome_produto = produtos_nomes.get(produto, 'Nitrogênio')
        insumos_tipo.append(nome_produto)
        
        print(f"\nProduto selecionado: {nome_produto}")
        kg_por_hectare = validar_numero("Quantidade em kg por hectare: ")
        
        quantidade = calcular_insumo_milho(area, kg_por_hectare)
        insumos_quantidade.append(quantidade)
        
        print(f"\n✅ Quantidade necessária: {quantidade:,.2f} kg")
    
    # Adiciona data do registro
    from datetime import datetime
    datas_registro.append(datetime.now().strftime("%d/%m/%Y %H:%M"))
    
    print("\n✅ Dados salvos com sucesso!")
    pausar()

def saida_dados():
    """Função para exibir todos os dados cadastrados"""
    limpar_tela()
    print("=" * 50)
    print("       RELATÓRIO DE DADOS - FARMTECH")
    print("=" * 50)
    
    if len(culturas) == 0:
        print("\n⚠️  Nenhum dado cadastrado no sistema!")
    else:
        print(f"\n📊 Total de registros: {len(culturas)}")
        print("-" * 50)
        
        # Loop para exibir cada registro
        for i in range(len(culturas)):
            print(f"\n📌 REGISTRO #{i+1}")
            print(f"   Data/Hora: {datas_registro[i]}")
            print(f"   Cultura: {culturas[i]}")
            print(f"   Área plantada: {areas_plantio[i]:,.2f} m²")
            print(f"   Insumo: {insumos_tipo[i]}")
            
            # Unidade depende da cultura
            if culturas[i] == "Café":
                print(f"   Quantidade: {insumos_quantidade[i]:,.2f} litros")
            else:
                print(f"   Quantidade: {insumos_quantidade[i]:,.2f} kg")
            print("-" * 50)
        
        # Estatísticas gerais
        print("\n📈 ESTATÍSTICAS GERAIS:")
        total_area = sum(areas_plantio)
        print(f"   Área total cultivada: {total_area:,.2f} m²")
        print(f"   Área média por cultura: {total_area/len(areas_plantio):,.2f} m²")
        
        # Contagem por tipo de cultura
        cafe_count = culturas.count("Café")
        milho_count = culturas.count("Milho")
        print(f"   Registros de Café: {cafe_count}")
        print(f"   Registros de Milho: {milho_count}")
    
    pausar()

def atualizar_dados():
    """Função para atualizar dados em uma posição específica"""
    limpar_tela()
    print("=" * 50)
    print("       ATUALIZAÇÃO DE DADOS - FARMTECH")
    print("=" * 50)
    
    if len(culturas) == 0:
        print("\n⚠️  Nenhum dado para atualizar!")
        pausar()
        return
    
    # Mostra dados atuais
    print("\n📋 REGISTROS ATUAIS:")
    for i in range(len(culturas)):
        print(f"{i+1}. {culturas[i]} - Área: {areas_plantio[i]:,.2f} m² - Insumo: {insumos_tipo[i]}")
    
    # Solicita posição
    posicao = validar_numero(f"\nQual registro deseja atualizar (1 a {len(culturas)})? ", int, 0)
    
    # Valida posição
    if posicao < 1 or posicao > len(culturas):
        print("❌ Posição inválida!")
        pausar()
        return
    
    # Ajusta para índice do vetor (começa em 0)
    indice = posicao - 1
    
    print(f"\n📝 Atualizando registro #{posicao}")
    print("O que deseja atualizar?")
    print("1 - Área plantada")
    print("2 - Tipo de insumo")
    print("3 - Quantidade de insumo")
    print("4 - Todos os dados")
    
    opcao = input("\nEscolha uma opção: ")
    
    if opcao in ['1', '4']:
        # Atualiza área baseado no tipo de cultura
        if culturas[indice] == "Café":
            print("\n📐 Nova área (Retângulo):")
            comprimento = validar_numero("Novo comprimento (metros): ")
            largura = validar_numero("Nova largura (metros): ")
            areas_plantio[indice] = calcular_area_retangular(comprimento, largura)
        else:
            print("\n📐 Nova área (Círculo):")
            raio = validar_numero("Novo raio do pivô (metros): ")
            areas_plantio[indice] = calcular_area_circular(raio)
    
    if opcao in ['2', '4']:
        # Atualiza tipo de insumo
        if culturas[indice] == "Café":
            print("\n💧 Novo insumo (1-Fosfato, 2-Fungicida, 3-Herbicida):")
            produto = input("Escolha: ")
            produtos_nomes = {'1': 'Fosfato', '2': 'Fungicida', '3': 'Herbicida'}
            insumos_tipo[indice] = produtos_nomes.get(produto, insumos_tipo[indice])
        else:
            print("\n💧 Novo insumo (1-Nitrogênio, 2-Fósforo, 3-Potássio):")
            produto = input("Escolha: ")
            produtos_nomes = {'1': 'Nitrogênio', '2': 'Fósforo', '3': 'Potássio'}
            insumos_tipo[indice] = produtos_nomes.get(produto, insumos_tipo[indice])
    
    if opcao in ['3', '4']:
        # Atualiza quantidade de insumo
        if culturas[indice] == "Café":
            print("\n💧 Nova quantidade de insumo:")
            ml_por_metro = validar_numero("mL por metro linear: ")
            num_ruas = validar_numero("Número de ruas: ", int)
            comprimento_rua = validar_numero("Comprimento da rua (metros): ")
            insumos_quantidade[indice] = calcular_insumo_cafe(
                areas_plantio[indice], ml_por_metro, num_ruas, comprimento_rua
            )
        else:
            print("\n💧 Nova quantidade de insumo:")
            kg_por_hectare = validar_numero("kg por hectare: ")
            insumos_quantidade[indice] = calcular_insumo_milho(
                areas_plantio[indice], kg_por_hectare
            )
    
    # Atualiza data de modificação
    from datetime import datetime
    datas_registro[indice] = datetime.now().strftime("%d/%m/%Y %H:%M")
    
    print("\n✅ Dados atualizados com sucesso!")
    pausar()

def deletar_dados():
    """Função para deletar dados de uma posição específica"""
    limpar_tela()
    print("=" * 50)
    print("       EXCLUSÃO DE DADOS - FARMTECH")
    print("=" * 50)
    
    if len(culturas) == 0:
        print("\n⚠️  Nenhum dado para deletar!")
        pausar()
        return
    
    # Mostra dados atuais
    print("\n📋 REGISTROS ATUAIS:")
    for i in range(len(culturas)):
        print(f"{i+1}. {culturas[i]} - Área: {areas_plantio[i]:,.2f} m² - Insumo: {insumos_tipo[i]}")
    
    # Solicita posição
    posicao = validar_numero(f"\nQual registro deseja deletar (1 a {len(culturas)})? ", int, 0)
    
    # Valida posição
    if posicao < 1 or posicao > len(culturas):
        print("❌ Posição inválida!")
        pausar()
        return
    
    # Ajusta para índice do vetor
    indice = posicao - 1
    
    # Confirmação
    print(f"\n⚠️  Confirma exclusão do registro #{posicao}?")
    print(f"   Cultura: {culturas[indice]}")
    print(f"   Área: {areas_plantio[indice]:,.2f} m²")
    confirma = input("\nDigite S para confirmar ou N para cancelar: ").upper()
    
    if confirma == 'S':
        # Remove de todos os vetores
        culturas.pop(indice)
        areas_plantio.pop(indice)
        insumos_tipo.pop(indice)
        insumos_quantidade.pop(indice)
        datas_registro.pop(indice)
        
        print("\n✅ Registro deletado com sucesso!")
    else:
        print("\n❌ Exclusão cancelada!")
    
    pausar()

def menu_principal():
    """Menu principal do sistema"""
    while True:
        limpar_tela()
        print("=" * 50)
        print("     🌱 FARMTECH SOLUTIONS 🌱")
        print("    Sistema de Agricultura Digital")
        print("=" * 50)
        print("\n📋 MENU PRINCIPAL:")
        print("\n1️⃣  - Entrada de Dados")
        print("2️⃣  - Saída de Dados (Relatório)")
        print("3️⃣  - Atualizar Dados")
        print("4️⃣  - Deletar Dados")
        print("5️⃣  - Sair do Programa")
        print("\n" + "=" * 50)
        
        opcao = input("\nEscolha uma opção (1-5): ")
        
        # Estrutura de decisão para processar opção
        if opcao == '1':
            entrada_dados()
        elif opcao == '2':
            saida_dados()
        elif opcao == '3':
            atualizar_dados()
        elif opcao == '4':
            deletar_dados()
        elif opcao == '5':
            limpar_tela()
            print("\n" + "=" * 50)
            print("    👋 Obrigado por usar FarmTech Solutions!")
            print("         Agricultura Digital é o futuro! 🚜")
            print("=" * 50)
            print("\nEncerrando sistema...")
            time.sleep(2)
            break
        else:
            print("\n❌ Opção inválida! Digite um número de 1 a 5.")
            pausar()

# ========================================
# PROGRAMA PRINCIPAL
# ========================================

if __name__ == "__main__":
    # Inicia o sistema
    menu_principal()

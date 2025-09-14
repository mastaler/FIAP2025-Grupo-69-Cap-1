# 🌱 FarmTech Solutions - Sistema de Agricultura Digital

## 📋 Descrição do Projeto
Sistema desenvolvido para a startup **FarmTech Solutions** para gerenciamento de culturas agrícolas, focando em **Café** e **Milho**. O sistema permite calcular áreas de plantio, gerenciar insumos e realizar análises estatísticas dos dados.

## 🚀 Funcionalidades

### Sistema Python (`farmtech_sistema.py`)
- ✅ **Suporte a 2 culturas**: Café e Milho
- ✅ **Cálculo de área de plantio**: 
  - Café: área retangular
  - Milho: área circular (pivô central)
- ✅ **Cálculo de manejo de insumos**:
  - Café: litros de produto (Fosfato, Fungicida, Herbicida)
  - Milho: kg de produto (Nitrogênio, Fósforo, Potássio)
- ✅ **Armazenamento em vetores**
- ✅ **Menu CRUD completo**:
  - Entrada de dados
  - Saída de dados (relatório)
  - Atualização de dados
  - Deleção de dados
  - Sair do programa
- ✅ **Estruturas de loop e decisão**

### Sistema R (`farmtech_analise.R`)
- 📊 Análise estatística de áreas de plantio
- 📊 Análise de consumo de insumos
- 📊 Análise comparativa entre culturas
- 📊 Cálculo de média, mediana, desvio padrão
- 📊 Teste de hipótese (teste t)

### Sistema R Meteorológico (`farmtech_clima.R`) - BÔNUS
- 🌤️ Conexão com API meteorológica pública
- 🌤️ Dados climáticos em tempo real
- 🌤️ Previsão do tempo
- 🌤️ Recomendações para agricultura

## 💻 Como Executar

### Requisitos
- **Python 3.x**
- **R** (versão 4.0 ou superior)
- Pacotes R (opcional, para sistema meteorológico):
  - `httr`
  - `jsonlite`

### Executando o Sistema Python
```bash
python3 farmtech_sistema.py
```
ou
```bash
python farmtech_sistema.py
```

### Executando a Análise em R
```bash
Rscript farmtech_analise.R
```
ou abra o R e execute:
```r
source("farmtech_analise.R")
```

### Executando o Sistema Meteorológico (Bônus)
```bash
Rscript farmtech_clima.R
```

## 📁 Estrutura dos Arquivos
```
projeto-farmtech/
│
├── farmtech_sistema.py    # Sistema principal em Python
├── farmtech_analise.R     # Análise estatística em R
├── farmtech_clima.R       # Sistema meteorológico (bônus)
├── README.md              # Este arquivo
└── git_comandos.txt       # Comandos Git para versionamento
```

## 📊 Exemplo de Uso

### Python - Cadastro de Café
1. Escolha opção 1 (Entrada de Dados)
2. Selecione cultura: Café
3. Digite comprimento: 100 metros
4. Digite largura: 50 metros
5. Escolha insumo: Fosfato
6. Digite mL por metro: 500
7. Número de ruas: 10
8. Comprimento da rua: 100 metros

**Resultado**: Área = 5.000 m², Insumo = 500 litros

### Python - Cadastro de Milho
1. Escolha opção 1 (Entrada de Dados)
2. Selecione cultura: Milho
3. Digite raio do pivô: 200 metros
4. Escolha insumo: Nitrogênio
5. Digite kg por hectare: 150

**Resultado**: Área = 125.663,71 m² (12,57 ha), Insumo = 1.885 kg

## 🎥 Vídeo de Demonstração
- Grave um vídeo de até 5 minutos mostrando:
  1. Execução do sistema Python com todas as funcionalidades
  2. Execução da análise em R
  3. (Opcional) Sistema meteorológico funcionando
- Poste no YouTube como "não listado"
- Adicione o link em `link_video.txt`

## 📚 Referências
- Artigo sobre Agricultura Digital (para resumo): [Link do artigo](https://www.alice.cnptia.embrapa.br/alice/bitstream/doc/1003485/1/CAP8.pdf)
- Resumo no documento https://github.com/mastaler/FIAP2025-Grupo-69-Cap-1/blob/main/resumo_artigo_vants.docx

## 👥 Equipe
- Fabio Mastaler   RM567153
- Paulo Henrique Prado Martelli   RM567266
- Wanderlei Grizolli Junior   RM568198
- Lucas Cariello Massena   RM567530
- Raul Mauro Sarai de Jesus   RM567329

## 📝 Observações
- O sistema foi desenvolvido para fins educacionais
- Primeiro semestre do curso - código simples e bem comentado
- Todos os comentários estão em português
- Uso de IA foi permitido e utilizado com senso crítico

## ⚠️ Entrega
1. **Compactar todos os arquivos em ZIP**:
   - farmtech_sistema.py
   - farmtech_analise.R
   - farmtech_clima.R (opcional)
   - README.md
   - link_video.txt (com link do YouTube)
   - resumo_artigo.pdf (1 página A4)
   - git_comandos.txt

2. **Resumo na disciplina de Formação Social**:
   - Artigo sobre Agricultura Digital (para resumo): [Link do artigo](https://www.alice.cnptia.embrapa.br/alice/bitstream/doc/1003485/1/CAP8.pdf)
   - Resumo no documento https://github.com/mastaler/FIAP2025-Grupo-69-Cap-1/blob/main/resumo_artigo_vants.docx

---
**FarmTech Solutions** - Transformando a agricultura através da tecnologia 🚜🌱

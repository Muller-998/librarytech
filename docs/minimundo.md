# 📖 Minimundo - Sistema LibraryTech

## Descrição Completa do Sistema

### Contexto

A Biblioteca LibraryTech é uma biblioteca pública de médio porte localizada em São Paulo que atende estudantes, professores, pesquisadores e membros da comunidade em geral. A biblioteca possui um acervo diversificado que inclui livros, periódicos, DVDs, e-books e obras de referência.

### Objetivo do Sistema

Desenvolver um sistema completo de gestão bibliotecária que automatize e centralize todos os processos operacionais, desde o cadastro de usuários até o controle de multas, proporcionando:

- Melhor experiência para os usuários
- Otimização dos processos administrativos
- Relatórios gerenciais para tomada de decisão
- Controle eficiente do acervo
- Rastreabilidade completa de operações

---

## Atores do Sistema

### 1. Usuários/Leitores

Pessoas cadastradas que utilizam os serviços da biblioteca. Divididos em três categorias:

**Estudante:**

- Prazo de empréstimo: 14 dias
- Limite: 3 livros simultâneos
- Multa: R$ 1,00/dia de atraso

**Professor:**

- Prazo de empréstimo: 30 dias
- Limite: 5 livros simultâneos
- Multa: R$ 1,50/dia de atraso

**Comunidade:**

- Prazo de empréstimo: 7 dias
- Limite: 2 livros simultâneos
- Multa: R$ 2,00/dia de atraso

### 2. Funcionários

Responsáveis pela operação diária da biblioteca:

- **Bibliotecário**: Realiza empréstimos, devoluções, cadastros
- **Catalogador**: Responsável pela catalogação de novos materiais
- **Administrador**: Gestão geral, relatórios, configurações
- **Atendente**: Suporte aos usuários

---

## Processos Principais

### 1. Cadastro de Usuário

**Fluxo:**

1. Usuário apresenta documentação (RG, CPF, comprovante de residência)
2. Funcionário verifica dados e escolhe categoria
3. Sistema gera cadastro único
4. Usuário recebe número de matrícula

**Dados Coletados:**

- CPF (único)
- Nome completo
- Email (único)
- Telefone
- Endereço
- Data de nascimento
- Categoria (Estudante/Professor/Comunidade)

### 2. Catalogação de Material

**Fluxo:**

1. Material chega à biblioteca (compra/doação)
2. Catalogador registra metadados bibliográficos
3. Sistema gera código de barras para cada exemplar
4. Material é etiquetado e arquivado

**Dados do Material:**

- ISBN (quando aplicável)
- Título e subtítulo
- Autor(es)
- Editora
- Ano de publicação
- Categoria (Ficção, Não-ficção, etc.)
- Classificação Decimal de Dewey (CDD)

**Dados do Exemplar:**

- Código de barras único
- Número do exemplar (1, 2, 3...)
- Localização física (estante)
- Data de aquisição
- Valor de aquisição
- Status (Disponível, Emprestado, Em Manutenção, Perdido)

### 3. Empréstimo

**Fluxo:**

1. Usuário solicita empréstimo
2. Funcionário verifica:
   - Se usuário atingiu limite de empréstimos
   - Se há multas pendentes
   - Se material está disponível
3. Sistema registra empréstimo com data prevista de devolução
4. Exemplar é marcado como "Emprestado"

**Regras:**

- Calcular data de devolução baseada na categoria do usuário
- Bloquear empréstimo se houver multas pendentes > R$ 50,00
- Bloquear se limite de empréstimos atingido

### 4. Devolução

**Fluxo:**

1. Usuário devolve material
2. Funcionário verifica condições físicas
3. Sistema calcula atraso (se houver)
4. Multa é gerada automaticamente se atrasado
5. Exemplar volta ao status "Disponível"
6. Se houver reserva, primeiro da fila é notificado

**Cálculo de Multa:**

multa = dias_atraso × valor_multa_categoria

### 5. Renovação

**Fluxo:**

1. Usuário solicita renovação antes do vencimento
2. Sistema verifica se há reservas pendentes
3. Se não houver reservas, prorroga por mais um período
4. Limite: 2 renovações por empréstimo

### 6. Reserva

**Fluxo:**

1. Usuário busca material indisponível
2. Sistema permite reserva
3. Usuário entra na fila de espera
4. Quando material é devolvido, primeiro da fila é notificado
5. Reserva tem validade de 7 dias

---

## Regras de Negócio

### RN01 - Unicidade de Usuário

Cada usuário deve ter CPF e email únicos no sistema.

### RN02 - Limite de Empréstimos

Usuário não pode exceder o limite de empréstimos simultâneos da sua categoria.

### RN03 - Bloqueio por Inadimplência

Usuários com multas pendentes acima de R$ 50,00 ficam bloqueados para novos empréstimos.

### RN04 - Multa Automática

Sistema calcula e gera multa automaticamente quando:

- Data real de devolução > Data prevista de devolução
- Valor: dias_atraso × valor_multa_categoria

### RN05 - Relação Material-Exemplar

Um material (obra) pode ter múltiplos exemplares (cópias físicas).

### RN06 - Relação Material-Autor (N:N)

Um material pode ter múltiplos autores e um autor pode ter escrito múltiplos materiais.

### RN07 - Reserva FIFO

Reservas são atendidas por ordem de chegada (primeiro a reservar, primeiro a ser atendido).

### RN08 - Limite de Renovação

Cada empréstimo pode ser renovado no máximo 2 vezes, desde que não haja reservas.

### RN09 - Multa Única por Empréstimo

Cada empréstimo atrasado gera apenas uma multa (relação 1:1).

### RN10 - Rastreabilidade

Todos os empréstimos e devoluções devem registrar qual funcionário executou a operação.

---

## Dados Estatísticos

### Volumes Estimados

- **Usuários Ativos**: ~500
- **Materiais no Acervo**: ~5.000
- **Exemplares Físicos**: ~8.000
- **Empréstimos/Mês**: ~1.200
- **Reservas Ativas**: ~50
- **Multas Mensais**: ~30

### Operações Diárias

- Empréstimos: ~40
- Devoluções: ~35
- Renovações: ~15
- Novas reservas: ~5
- Cadastros novos: ~3

---

## Cenários de Uso

### Cenário 1: Empréstimo Simples

**Ator:** Ana (Estudante)  
**Situação:** Ana quer emprestar "Dom Casmurro"

1. Ana apresenta carteirinha
2. Bibliotecária verifica disponibilidade
3. Sistema registra empréstimo
4. Data de devolução: 14 dias (categoria Estudante)
5. Ana sai com o livro

### Cenário 2: Empréstimo com Reserva

**Ator:** Carlos (Professor)  
**Situação:** Carlos quer "1984" mas está emprestado

1. Carlos solicita o livro
2. Sistema informa: emprestado, devolução prevista 10/12
3. Carlos faz reserva
4. Posição na fila: 1
5. Quando devolvido, Carlos recebe email
6. Reserva válida por 7 dias

### Cenário 3: Devolução com Atraso

**Ator:** João (Comunidade)  
**Situação:** João devolveu livro com 10 dias de atraso

1. Data prevista: 01/11
2. Data real: 11/11
3. Atraso: 10 dias
4. Categoria: Comunidade (R$ 2,00/dia)
5. Multa gerada: R$ 20,00
6. João só poderá emprestar novamente após pagar

---

## Integrações Futuras (Fora do Escopo Atual)

- Integração com catálogo online (OPAC)
- Integração com catracas biométricas
- App mobile para usuários
- Sistema de recomendação baseado em IA
- Integração com bases de dados acadêmicas
- E-books e audiobooks digitais

---

**Versão:** 1.0  
**Última Atualização:** Novembro 2024  
**Sistema:** LibraryTech

# 📐 Modelo Lógico - Sistema LibraryTech

## Especificação Técnica Completa do Banco de Dados

---

## 📋 Visão Geral

Este documento descreve o modelo lógico normalizado (3FN) do Sistema de Gestão de Biblioteca LibraryTech, contendo 13 tabelas inter-relacionadas que suportam todos os processos operacionais da biblioteca.

---

## 🗂️ Tabelas e Estruturas

### **1. CATEGORIA_USUARIO**

**Descrição:** Categorias de usuários com regras específicas de empréstimo.

**Estrutura:**

```sql
CATEGORIA_USUARIO (
    id_categoria          INTEGER      PRIMARY KEY AUTOINCREMENT,
    nome_categoria        VARCHAR(50)  NOT NULL UNIQUE,
    prazo_emprestimo_dias INTEGER      NOT NULL CHECK(prazo_emprestimo_dias > 0),
    qtd_max_emprestimos   INTEGER      NOT NULL CHECK(qtd_max_emprestimos > 0),
    valor_multa_diaria    DECIMAL(5,2) NOT NULL CHECK(valor_multa_diaria >= 0)
)
```

**Chaves:**

- **PK:** id_categoria
- **UK:** nome_categoria

**Valores Exemplo:**

- Estudante: 14 dias, 3 livros, R$ 1,00/dia
- Professor: 30 dias, 5 livros, R$ 1,50/dia
- Comunidade: 7 dias, 2 livros, R$ 2,00/dia

---

### **2. USUARIO**

**Descrição:** Cadastro completo de usuários da biblioteca.

**Estrutura:**

```sql
USUARIO (
    id_usuario       INTEGER      PRIMARY KEY AUTOINCREMENT,
    id_categoria     INTEGER      NOT NULL,
    cpf              VARCHAR(14)  NOT NULL UNIQUE,
    nome             VARCHAR(100) NOT NULL,
    email            VARCHAR(100) NOT NULL UNIQUE,
    telefone         VARCHAR(20),
    endereco         VARCHAR(200),
    data_nascimento  DATE,
    data_cadastro    DATE         NOT NULL DEFAULT CURRENT_DATE,
    foto_perfil      VARCHAR(255),
    status_ativo     BOOLEAN      NOT NULL DEFAULT 1,
    
    FOREIGN KEY (id_categoria) REFERENCES CATEGORIA_USUARIO(id_categoria)
)
```

**Chaves:**

- **PK:** id_usuario
- **FK:** id_categoria → CATEGORIA_USUARIO
- **UK:** cpf, email

**Índices:**

- idx_usuario_cpf
- idx_usuario_email
- idx_usuario_categoria

---

### **3. EDITORA**

**Descrição:** Cadastro de editoras publicadoras.

**Estrutura:**

```sql
EDITORA (
    id_editora   INTEGER      PRIMARY KEY AUTOINCREMENT,
    nome_editora VARCHAR(100) NOT NULL,
    pais         VARCHAR(50),
    cidade       VARCHAR(50),
    telefone     VARCHAR(20),
    email        VARCHAR(100)
)
```

**Chaves:**

- **PK:** id_editora

---

### **4. AUTOR**

**Descrição:** Cadastro de autores de obras.

**Estrutura:**

```sql
AUTOR (
    id_autor         INTEGER      PRIMARY KEY AUTOINCREMENT,
    nome_autor       VARCHAR(100) NOT NULL,
    nacionalidade    VARCHAR(50),
    data_nascimento  DATE,
    biografia        TEXT
)
```

**Chaves:**

- **PK:** id_autor

---

### **5. CATEGORIA_MATERIAL**

**Descrição:** Categorias de classificação do acervo.

**Estrutura:**

```sql
CATEGORIA_MATERIAL (
    id_categoria_material  INTEGER      PRIMARY KEY AUTOINCREMENT,
    nome_categoria         VARCHAR(50)  NOT NULL UNIQUE,
    descricao              TEXT,
    classificacao_decimal  VARCHAR(20)
)
```

**Chaves:**

- **PK:** id_categoria_material
- **UK:** nome_categoria

**Classificação:** Baseada no sistema CDD (Classificação Decimal de Dewey)

---

### **6. MATERIAL**

**Descrição:** Cadastro de materiais do acervo (livros, DVDs, periódicos).

**Estrutura:**

```sql
MATERIAL (
    id_material           INTEGER      PRIMARY KEY AUTOINCREMENT,
    id_editora            INTEGER,
    id_categoria_material INTEGER      NOT NULL,
    isbn                  VARCHAR(17)  UNIQUE,
    titulo                VARCHAR(200) NOT NULL,
    subtitulo             VARCHAR(200),
    ano_publicacao        INTEGER,
    edicao                VARCHAR(20),
    numero_paginas        INTEGER,
    idioma                VARCHAR(30)  NOT NULL,
    tipo_material         VARCHAR(30)  NOT NULL,
    sinopse               TEXT,
    imagem_capa           VARCHAR(255),
    
    FOREIGN KEY (id_editora) REFERENCES EDITORA(id_editora),
    FOREIGN KEY (id_categoria_material) REFERENCES CATEGORIA_MATERIAL(id_categoria_material)
)
```

**Chaves:**

- **PK:** id_material
- **FK:** id_editora → EDITORA
- **FK:** id_categoria_material → CATEGORIA_MATERIAL
- **UK:** isbn

**Índices:**

- idx_material_isbn
- idx_material_titulo

**Tipos de Material:** Livro, DVD, Periódico, E-book

---

### **7. MATERIAL_AUTOR** *(Tabela Associativa)*

**Descrição:** Relacionamento N:N entre materiais e autores.

**Estrutura:**

```sql
MATERIAL_AUTOR (
    id_material_autor INTEGER PRIMARY KEY AUTOINCREMENT,
    id_material       INTEGER NOT NULL,
    id_autor          INTEGER NOT NULL,
    ordem_autoria     INTEGER,
    
    FOREIGN KEY (id_material) REFERENCES MATERIAL(id_material) ON DELETE CASCADE,
    FOREIGN KEY (id_autor) REFERENCES AUTOR(id_autor) ON DELETE CASCADE,
    UNIQUE(id_material, id_autor)
)
```

**Chaves:**

- **PK:** id_material_autor
- **FK:** id_material → MATERIAL
- **FK:** id_autor → AUTOR
- **UK:** (id_material, id_autor)

**Propósito:** Suportar obras com múltiplos autores e autores com múltiplas obras.

---

### **8. EXEMPLAR**

**Descrição:** Exemplares físicos (cópias) de cada material.

**Estrutura:**

```sql
EXEMPLAR (
    id_exemplar        INTEGER      PRIMARY KEY AUTOINCREMENT,
    id_material        INTEGER      NOT NULL,
    codigo_barras      VARCHAR(20)  NOT NULL UNIQUE,
    numero_exemplar    INTEGER      NOT NULL,
    localizacao_fisica VARCHAR(50)  NOT NULL,
    status_exemplar    VARCHAR(30)  NOT NULL CHECK(status_exemplar IN ('Disponível', 'Emprestado', 'Em Manutenção', 'Perdido')),
    data_aquisicao     DATE,
    valor_aquisicao    DECIMAL(10,2),
    observacoes        TEXT,
    
    FOREIGN KEY (id_material) REFERENCES MATERIAL(id_material)
)
```

**Chaves:**

- **PK:** id_exemplar
- **FK:** id_material → MATERIAL
- **UK:** codigo_barras

**Índices:**

- idx_exemplar_codigo
- idx_exemplar_status

**Status Possíveis:**

- Disponível
- Emprestado
- Em Manutenção
- Perdido

---

### **9. FUNCIONARIO**

**Descrição:** Cadastro de funcionários da biblioteca.

**Estrutura:**

```sql
FUNCIONARIO (
    id_funcionario   INTEGER      PRIMARY KEY AUTOINCREMENT,
    cpf              VARCHAR(14)  NOT NULL UNIQUE,
    nome             VARCHAR(100) NOT NULL,
    cargo            VARCHAR(50)  NOT NULL,
    email            VARCHAR(100) NOT NULL UNIQUE,
    telefone         VARCHAR(20),
    data_contratacao DATE         NOT NULL,
    status_ativo     BOOLEAN      NOT NULL DEFAULT 1
)
```

**Chaves:**

- **PK:** id_funcionario
- **UK:** cpf, email

**Cargos:** Bibliotecário, Administrador, Catalogador, Atendente

---

### **10. EMPRESTIMO**

**Descrição:** Registro de empréstimos de exemplares.

**Estrutura:**

```sql
EMPRESTIMO (
    id_emprestimo              INTEGER     PRIMARY KEY AUTOINCREMENT,
    id_usuario                 INTEGER     NOT NULL,
    id_exemplar                INTEGER     NOT NULL,
    id_funcionario_emprestimo  INTEGER     NOT NULL,
    id_funcionario_devolucao   INTEGER,
    data_emprestimo            DATE        NOT NULL,
    data_prevista_devolucao    DATE        NOT NULL,
    data_real_devolucao        DATE,
    status_emprestimo          VARCHAR(30) NOT NULL CHECK(status_emprestimo IN ('Ativo', 'Devolvido', 'Atrasado')),
    observacoes                TEXT,
    
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
    FOREIGN KEY (id_exemplar) REFERENCES EXEMPLAR(id_exemplar),
    FOREIGN KEY (id_funcionario_emprestimo) REFERENCES FUNCIONARIO(id_funcionario),
    FOREIGN KEY (id_funcionario_devolucao) REFERENCES FUNCIONARIO(id_funcionario),
    CHECK(data_prevista_devolucao >= data_emprestimo),
    CHECK(data_real_devolucao IS NULL OR data_real_devolucao >= data_emprestimo)
)
```

**Chaves:**

- **PK:** id_emprestimo
- **FK:** id_usuario → USUARIO
- **FK:** id_exemplar → EXEMPLAR
- **FK:** id_funcionario_emprestimo → FUNCIONARIO
- **FK:** id_funcionario_devolucao → FUNCIONARIO

**Índices:**

- idx_emprestimo_usuario
- idx_emprestimo_status

**Status Possíveis:**

- Ativo
- Devolvido
- Atrasado

---

### **11. RENOVACAO**

**Descrição:** Histórico de renovações de empréstimos.

**Estrutura:**

```sql
RENOVACAO (
    id_renovacao        INTEGER PRIMARY KEY AUTOINCREMENT,
    id_emprestimo       INTEGER NOT NULL,
    data_renovacao      DATE    NOT NULL,
    nova_data_prevista  DATE    NOT NULL,
    motivo              TEXT,
    
    FOREIGN KEY (id_emprestimo) REFERENCES EMPRESTIMO(id_emprestimo) ON DELETE CASCADE,
    CHECK(nova_data_prevista > data_renovacao)
)
```

**Chaves:**

- **PK:** id_renovacao
- **FK:** id_emprestimo → EMPRESTIMO

**Regra:** Limite de 2 renovações por empréstimo.

---

### **12. RESERVA**

**Descrição:** Sistema de reservas de materiais indisponíveis.

**Estrutura:**

```sql
RESERVA (
    id_reserva      INTEGER     PRIMARY KEY AUTOINCREMENT,
    id_usuario      INTEGER     NOT NULL,
    id_material     INTEGER     NOT NULL,
    data_reserva    DATE        NOT NULL,
    data_validade   DATE        NOT NULL,
    status_reserva  VARCHAR(30) NOT NULL CHECK(status_reserva IN ('Ativa', 'Atendida', 'Cancelada', 'Expirada')),
    posicao_fila    INTEGER,
    
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
    FOREIGN KEY (id_material) REFERENCES MATERIAL(id_material),
    CHECK(data_validade >= data_reserva)
)
```

**Chaves:**

- **PK:** id_reserva
- **FK:** id_usuario → USUARIO
- **FK:** id_material → MATERIAL

**Índices:**

- idx_reserva_usuario
- idx_reserva_status

**Sistema de Fila:** Atendimento por ordem de chegada (FIFO).

---

### **13. MULTA**

**Descrição:** Multas por atraso na devolução.

**Estrutura:**

```sql
MULTA (
    id_multa          INTEGER      PRIMARY KEY AUTOINCREMENT,
    id_emprestimo     INTEGER      NOT NULL UNIQUE,
    valor_multa       DECIMAL(10,2) NOT NULL CHECK(valor_multa >= 0),
    dias_atraso       INTEGER      NOT NULL CHECK(dias_atraso > 0),
    data_geracao      DATE         NOT NULL,
    data_pagamento    DATE,
    status_pagamento  VARCHAR(30)  NOT NULL CHECK(status_pagamento IN ('Pendente', 'Pago', 'Cancelado')),
    forma_pagamento   VARCHAR(30),
    
    FOREIGN KEY (id_emprestimo) REFERENCES EMPRESTIMO(id_emprestimo),
    CHECK(data_pagamento IS NULL OR data_pagamento >= data_geracao)
)
```

**Chaves:**

- **PK:** id_multa
- **FK:** id_emprestimo → EMPRESTIMO (UNIQUE = relação 1:1)

**Cálculo:**

```sql
valor_multa = dias_atraso × valor_multa_diaria (da categoria do usuário)
```

---

## 🔗 Mapeamento de Relacionamentos

| De | Para | Cardinalidade | Descrição |
|----|------|---------------|-----------|
| CATEGORIA_USUARIO | USUARIO | 1:N | Uma categoria agrupa vários usuários |
| USUARIO | EMPRESTIMO | 1:N | Um usuário faz vários empréstimos |
| USUARIO | RESERVA | 1:N | Um usuário faz várias reservas |
| EDITORA | MATERIAL | 1:N | Uma editora publica vários materiais |
| CATEGORIA_MATERIAL | MATERIAL | 1:N | Uma categoria contém vários materiais |
| MATERIAL | AUTOR | N:N | Através de MATERIAL_AUTOR |
| MATERIAL | EXEMPLAR | 1:N | Um material tem vários exemplares |
| MATERIAL | RESERVA | 1:N | Um material pode ter várias reservas |
| EXEMPLAR | EMPRESTIMO | 1:N | Um exemplar é emprestado várias vezes |
| EMPRESTIMO | RENOVACAO | 1:N | Um empréstimo pode ser renovado |
| EMPRESTIMO | MULTA | 1:1 | Um empréstimo gera no máximo uma multa |
| FUNCIONARIO | EMPRESTIMO | 1:N | Um funcionário registra vários empréstimos |

---

## 📊 Normalização

### Primeira Forma Normal (1FN)

✅ Todos os atributos são atômicos
✅ Não existem grupos repetitivos
✅ Cada tabela possui chave primária

### Segunda Forma Normal (2FN)

✅ Está em 1FN
✅ Todos os atributos não-chave dependem completamente da chave primária
✅ Não existem dependências parciais

### Terceira Forma Normal (3FN)

✅ Está em 2FN
✅ Não existem dependências transitivas
✅ Informações de categoria separadas em tabelas próprias
✅ Relacionamento N:N resolvido com tabela associativa

---

## 🎯 Regras de Integridade

### Restrições de Domínio

- Status com valores pré-definidos (CHECK constraints)
- Valores numéricos positivos (CHECK > 0)
- Datas coerentes (data_devolucao >= data_emprestimo)

### Integridade Referencial

- Todas as chaves estrangeiras implementadas
- ON DELETE CASCADE em tabelas dependentes
- Índices em todas as FKs para performance

### Restrições de Unicidade

- CPF único por usuário
- Email único por usuário
- ISBN único por material
- Código de barras único por exemplar

---

## 📈 Considerações de Performance

### Índices Criados

- Campos de busca frequente (CPF, email, ISBN)
- Chaves estrangeiras
- Status de exemplares e empréstimos

### Otimizações

- Campos TEXT apenas onde necessário
- VARCHAR com tamanhos adequados
- Uso de INTEGER para PKs (autoincrement)

---

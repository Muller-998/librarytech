-- ============================================
-- SISTEMA DE GESTÃO DE BIBLIOTECA LIBRARYTECH
-- Script 01: Criação do Banco de Dados (DDL)
-- ============================================
-- Autor: Seu Nome
-- Data: Novembro 2024
-- SGBD: SQLite / PostgreSQL / MySQL
-- ============================================

-- Desabilita chaves estrangeiras temporariamente (SQLite)
PRAGMA foreign_keys = OFF;

-- Remove tabelas se existirem (ordem inversa das dependências)
DROP TABLE IF EXISTS RENOVACAO;

DROP TABLE IF EXISTS MULTA;

DROP TABLE IF EXISTS EMPRESTIMO;

DROP TABLE IF EXISTS RESERVA;

DROP TABLE IF EXISTS EXEMPLAR;

DROP TABLE IF EXISTS MATERIAL_AUTOR;

DROP TABLE IF EXISTS MATERIAL;

DROP TABLE IF EXISTS CATEGORIA_MATERIAL;

DROP TABLE IF EXISTS AUTOR;

DROP TABLE IF EXISTS EDITORA;

DROP TABLE IF EXISTS USUARIO;

DROP TABLE IF EXISTS CATEGORIA_USUARIO;

DROP TABLE IF EXISTS FUNCIONARIO;

-- ============================================
-- TABELA: CATEGORIA_USUARIO
-- Descrição: Armazena categorias de usuários com regras específicas
-- ============================================
CREATE TABLE CATEGORIA_USUARIO (
    id_categoria INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_categoria VARCHAR(50) NOT NULL UNIQUE,
    prazo_emprestimo_dias INTEGER NOT NULL CHECK (prazo_emprestimo_dias > 0),
    qtd_max_emprestimos INTEGER NOT NULL CHECK (qtd_max_emprestimos > 0),
    valor_multa_diaria DECIMAL(5, 2) NOT NULL CHECK (valor_multa_diaria >= 0)
);

-- ============================================
-- TABELA: USUARIO
-- Descrição: Cadastro de todos os usuários da biblioteca
-- ============================================
CREATE TABLE USUARIO (
    id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
    id_categoria INTEGER NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    endereco VARCHAR(200),
    data_nascimento DATE,
    data_cadastro DATE NOT NULL DEFAULT CURRENT_DATE,
    foto_perfil VARCHAR(255),
    status_ativo BOOLEAN NOT NULL DEFAULT 1,
    FOREIGN KEY (id_categoria) REFERENCES CATEGORIA_USUARIO (id_categoria)
);

-- ============================================
-- TABELA: EDITORA
-- Descrição: Cadastro de editoras
-- ============================================
CREATE TABLE EDITORA (
    id_editora INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_editora VARCHAR(100) NOT NULL,
    pais VARCHAR(50),
    cidade VARCHAR(50),
    telefone VARCHAR(20),
    email VARCHAR(100)
);

-- ============================================
-- TABELA: AUTOR
-- Descrição: Cadastro de autores
-- ============================================
CREATE TABLE AUTOR (
    id_autor INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_autor VARCHAR(100) NOT NULL,
    nacionalidade VARCHAR(50),
    data_nascimento DATE,
    biografia TEXT
);

-- ============================================
-- TABELA: CATEGORIA_MATERIAL
-- Descrição: Categorias de classificação dos materiais
-- ============================================
CREATE TABLE CATEGORIA_MATERIAL (
    id_categoria_material INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_categoria VARCHAR(50) NOT NULL UNIQUE,
    descricao TEXT,
    classificacao_decimal VARCHAR(20)
);

-- ============================================
-- TABELA: MATERIAL
-- Descrição: Cadastro de materiais (livros, DVDs, etc)
-- ============================================
CREATE TABLE MATERIAL (
    id_material INTEGER PRIMARY KEY AUTOINCREMENT,
    id_editora INTEGER,
    id_categoria_material INTEGER NOT NULL,
    isbn VARCHAR(17) UNIQUE,
    titulo VARCHAR(200) NOT NULL,
    subtitulo VARCHAR(200),
    ano_publicacao INTEGER,
    edicao VARCHAR(20),
    numero_paginas INTEGER,
    idioma VARCHAR(30) NOT NULL,
    tipo_material VARCHAR(30) NOT NULL,
    sinopse TEXT,
    imagem_capa VARCHAR(255),
    FOREIGN KEY (id_editora) REFERENCES EDITORA (id_editora),
    FOREIGN KEY (id_categoria_material) REFERENCES CATEGORIA_MATERIAL (id_categoria_material)
);

-- ============================================
-- TABELA: MATERIAL_AUTOR (Relacionamento N:N)
-- Descrição: Associação entre materiais e autores
-- ============================================
CREATE TABLE MATERIAL_AUTOR (
    id_material_autor INTEGER PRIMARY KEY AUTOINCREMENT,
    id_material INTEGER NOT NULL,
    id_autor INTEGER NOT NULL,
    ordem_autoria INTEGER,
    FOREIGN KEY (id_material) REFERENCES MATERIAL (id_material) ON DELETE CASCADE,
    FOREIGN KEY (id_autor) REFERENCES AUTOR (id_autor) ON DELETE CASCADE,
    UNIQUE (id_material, id_autor)
);

-- ============================================
-- TABELA: EXEMPLAR
-- Descrição: Exemplares físicos de cada material
-- ============================================
CREATE TABLE EXEMPLAR (
    id_exemplar INTEGER PRIMARY KEY AUTOINCREMENT,
    id_material INTEGER NOT NULL,
    codigo_barras VARCHAR(20) NOT NULL UNIQUE,
    numero_exemplar INTEGER NOT NULL,
    localizacao_fisica VARCHAR(50) NOT NULL,
    status_exemplar VARCHAR(30) NOT NULL CHECK (
        status_exemplar IN (
            'Disponível',
            'Emprestado',
            'Em Manutenção',
            'Perdido'
        )
    ),
    data_aquisicao DATE,
    valor_aquisicao DECIMAL(10, 2),
    observacoes TEXT,
    FOREIGN KEY (id_material) REFERENCES MATERIAL (id_material)
);

-- ============================================
-- TABELA: FUNCIONARIO
-- Descrição: Cadastro de funcionários da biblioteca
-- ============================================
CREATE TABLE FUNCIONARIO (
    id_funcionario INTEGER PRIMARY KEY AUTOINCREMENT,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    data_contratacao DATE NOT NULL,
    status_ativo BOOLEAN NOT NULL DEFAULT 1
);

-- ============================================
-- TABELA: EMPRESTIMO
-- Descrição: Registro de empréstimos de exemplares
-- ============================================
CREATE TABLE EMPRESTIMO (
    id_emprestimo INTEGER PRIMARY KEY AUTOINCREMENT,
    id_usuario INTEGER NOT NULL,
    id_exemplar INTEGER NOT NULL,
    id_funcionario_emprestimo INTEGER NOT NULL,
    id_funcionario_devolucao INTEGER,
    data_emprestimo DATE NOT NULL,
    data_prevista_devolucao DATE NOT NULL,
    data_real_devolucao DATE,
    status_emprestimo VARCHAR(30) NOT NULL CHECK (
        status_emprestimo IN (
            'Ativo',
            'Devolvido',
            'Atrasado'
        )
    ),
    observacoes TEXT,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO (id_usuario),
    FOREIGN KEY (id_exemplar) REFERENCES EXEMPLAR (id_exemplar),
    FOREIGN KEY (id_funcionario_emprestimo) REFERENCES FUNCIONARIO (id_funcionario),
    FOREIGN KEY (id_funcionario_devolucao) REFERENCES FUNCIONARIO (id_funcionario),
    CHECK (
        data_prevista_devolucao >= data_emprestimo
    ),
    CHECK (
        data_real_devolucao IS NULL
        OR data_real_devolucao >= data_emprestimo
    )
);

-- ============================================
-- TABELA: RENOVACAO
-- Descrição: Registro de renovações de empréstimos
-- ============================================
CREATE TABLE RENOVACAO (
    id_renovacao INTEGER PRIMARY KEY AUTOINCREMENT,
    id_emprestimo INTEGER NOT NULL,
    data_renovacao DATE NOT NULL,
    nova_data_prevista DATE NOT NULL,
    motivo TEXT,
    FOREIGN KEY (id_emprestimo) REFERENCES EMPRESTIMO (id_emprestimo) ON DELETE CASCADE,
    CHECK (
        nova_data_prevista > data_renovacao
    )
);

-- ============================================
-- TABELA: RESERVA
-- Descrição: Reservas de materiais
-- ============================================
CREATE TABLE RESERVA (
    id_reserva INTEGER PRIMARY KEY AUTOINCREMENT,
    id_usuario INTEGER NOT NULL,
    id_material INTEGER NOT NULL,
    data_reserva DATE NOT NULL,
    data_validade DATE NOT NULL,
    status_reserva VARCHAR(30) NOT NULL CHECK (
        status_reserva IN (
            'Ativa',
            'Atendida',
            'Cancelada',
            'Expirada'
        )
    ),
    posicao_fila INTEGER,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO (id_usuario),
    FOREIGN KEY (id_material) REFERENCES MATERIAL (id_material),
    CHECK (data_validade >= data_reserva)
);

-- ============================================
-- TABELA: MULTA
-- Descrição: Multas por atraso na devolução
-- ============================================
CREATE TABLE MULTA (
    id_multa INTEGER PRIMARY KEY AUTOINCREMENT,
    id_emprestimo INTEGER NOT NULL UNIQUE,
    valor_multa DECIMAL(10, 2) NOT NULL CHECK (valor_multa >= 0),
    dias_atraso INTEGER NOT NULL CHECK (dias_atraso > 0),
    data_geracao DATE NOT NULL,
    data_pagamento DATE,
    status_pagamento VARCHAR(30) NOT NULL CHECK (
        status_pagamento IN (
            'Pendente',
            'Pago',
            'Cancelado'
        )
    ),
    forma_pagamento VARCHAR(30),
    FOREIGN KEY (id_emprestimo) REFERENCES EMPRESTIMO (id_emprestimo),
    CHECK (
        data_pagamento IS NULL
        OR data_pagamento >= data_geracao
    )
);

-- ============================================
-- ÍNDICES para otimização de consultas
-- ============================================
CREATE INDEX idx_usuario_cpf ON USUARIO (cpf);

CREATE INDEX idx_usuario_email ON USUARIO (email);

CREATE INDEX idx_usuario_categoria ON USUARIO (id_categoria);

CREATE INDEX idx_material_isbn ON MATERIAL (isbn);

CREATE INDEX idx_material_titulo ON MATERIAL (titulo);

CREATE INDEX idx_exemplar_codigo ON EXEMPLAR (codigo_barras);

CREATE INDEX idx_exemplar_status ON EXEMPLAR (status_exemplar);

CREATE INDEX idx_emprestimo_usuario ON EMPRESTIMO (id_usuario);

CREATE INDEX idx_emprestimo_status ON EMPRESTIMO (status_emprestimo);

CREATE INDEX idx_reserva_usuario ON RESERVA (id_usuario);

CREATE INDEX idx_reserva_status ON RESERVA (status_reserva);

-- Reabilita chaves estrangeiras
PRAGMA foreign_keys = ON;

-- ============================================
-- Mensagem de Confirmação
-- ============================================
SELECT 'Banco de dados LibraryTech criado com sucesso!' AS status;

SELECT 'Total de tabelas criadas: 13' AS info;
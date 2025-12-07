-- ============================================
-- SISTEMA DE GESTÃO DE BIBLIOTECA LIBRARYTECH
-- Script 02: Inserção de Dados (DML - INSERT)
-- ============================================
-- Autor: Seu Nome
-- Data: Novembro 2024
-- Descrição: Popula o banco com dados de exemplo
-- ============================================

-- ============================================
-- 1. CATEGORIA_USUARIO
-- ============================================
INSERT INTO
    CATEGORIA_USUARIO (
        nome_categoria,
        prazo_emprestimo_dias,
        qtd_max_emprestimos,
        valor_multa_diaria
    )
VALUES ('Estudante', 14, 3, 1.00),
    ('Professor', 30, 5, 1.50),
    ('Comunidade', 7, 2, 2.00);

-- ============================================
-- 2. USUARIO
-- ============================================
INSERT INTO
    USUARIO (
        id_categoria,
        cpf,
        nome,
        email,
        telefone,
        endereco,
        data_nascimento,
        data_cadastro,
        status_ativo
    )
VALUES (
        1,
        '123.456.789-00',
        'Ana Costa Silva',
        'ana.costa@email.com',
        '(11) 91234-5678',
        'Rua das Flores, 123, São Paulo-SP',
        '2000-03-15',
        '2024-01-10',
        1
    ),
    (
        2,
        '234.567.890-11',
        'Carlos Eduardo Lima',
        'carlos.lima@email.com',
        '(11) 92345-6789',
        'Av. Paulista, 1500, São Paulo-SP',
        '1985-07-22',
        '2024-02-05',
        1
    ),
    (
        3,
        '345.678.901-22',
        'Paula Rocha Santos',
        'paula.rocha@email.com',
        '(11) 93456-7890',
        'Rua Augusta, 789, São Paulo-SP',
        '1990-11-30',
        '2024-03-12',
        1
    ),
    (
        1,
        '456.789.012-33',
        'João Pedro Oliveira',
        'joao.oliveira@email.com',
        '(11) 94567-8901',
        'Rua Consolação, 456, São Paulo-SP',
        '2001-05-18',
        '2024-04-20',
        1
    ),
    (
        1,
        '567.890.123-44',
        'Maria Fernanda Costa',
        'maria.costa@email.com',
        '(11) 95678-9012',
        'Av. Rebouças, 234, São Paulo-SP',
        '1999-09-25',
        '2024-05-15',
        1
    ),
    (
        2,
        '678.901.234-55',
        'Roberto Carlos Souza',
        'roberto.souza@email.com',
        '(11) 96789-0123',
        'Rua Oscar Freire, 678, São Paulo-SP',
        '1978-12-10',
        '2024-06-01',
        1
    ),
    (
        3,
        '789.012.345-66',
        'Juliana Mendes Alves',
        'juliana.alves@email.com',
        '(11) 97890-1234',
        'Av. Faria Lima, 901, São Paulo-SP',
        '1995-02-14',
        '2024-07-08',
        1
    ),
    (
        1,
        '890.123.456-77',
        'Pedro Henrique Dias',
        'pedro.dias@email.com',
        '(11) 98901-2345',
        'Rua Haddock Lobo, 345, São Paulo-SP',
        '2002-08-30',
        '2024-08-22',
        1
    ),
    (
        2,
        '901.234.567-88',
        'Beatriz Oliveira Lima',
        'beatriz.lima@email.com',
        '(11) 99012-3456',
        'Av. Europa, 567, São Paulo-SP',
        '1982-04-05',
        '2024-09-10',
        1
    ),
    (
        3,
        '012.345.678-99',
        'Lucas Gabriel Martins',
        'lucas.martins@email.com',
        '(11) 90123-4567',
        'Rua Padre João Manuel, 890, São Paulo-SP',
        '1988-11-20',
        '2024-10-05',
        1
    );

-- ============================================
-- 3. EDITORA
-- ============================================
INSERT INTO
    EDITORA (
        nome_editora,
        pais,
        cidade,
        telefone,
        email
    )
VALUES (
        'Companhia das Letras',
        'Brasil',
        'São Paulo',
        '(11) 3707-3500',
        'contato@companhiadasletras.com.br'
    ),
    (
        'Editora Globo',
        'Brasil',
        'Rio de Janeiro',
        '(21) 2534-8000',
        'contato@editoraglobo.com.br'
    ),
    (
        'Editora Rocco',
        'Brasil',
        'Rio de Janeiro',
        '(21) 3525-2000',
        'contato@rocco.com.br'
    ),
    (
        'Intrínseca',
        'Brasil',
        'Rio de Janeiro',
        '(21) 3206-7400',
        'contato@intrinseca.com.br'
    ),
    (
        'Editora Record',
        'Brasil',
        'Rio de Janeiro',
        '(21) 2585-2000',
        'contato@record.com.br'
    ),
    (
        'Penguin Random House',
        'Estados Unidos',
        'Nova York',
        '+1 212-782-9000',
        'contact@penguinrandomhouse.com'
    ),
    (
        'HarperCollins',
        'Estados Unidos',
        'Nova York',
        '+1 212-207-7000',
        'contact@harpercollins.com'
    );

-- ============================================
-- 4. AUTOR
-- ============================================
INSERT INTO
    AUTOR (
        nome_autor,
        nacionalidade,
        data_nascimento,
        biografia
    )
VALUES (
        'Machado de Assis',
        'Brasileiro',
        '1839-06-21',
        'Joaquim Maria Machado de Assis, considerado o maior nome da literatura brasileira.'
    ),
    (
        'Clarice Lispector',
        'Brasileira',
        '1920-12-10',
        'Escritora e jornalista nascida na Ucrânia e naturalizada brasileira.'
    ),
    (
        'Jorge Amado',
        'Brasileiro',
        '1912-08-10',
        'Um dos mais famosos e traduzidos escritores brasileiros.'
    ),
    (
        'J.K. Rowling',
        'Britânica',
        '1965-07-31',
        'Autora da série Harry Potter, uma das mais vendidas da história.'
    ),
    (
        'George Orwell',
        'Britânico',
        '1903-06-25',
        'Escritor, jornalista e ensaísta político inglês.'
    ),
    (
        'Gabriel García Márquez',
        'Colombiano',
        '1927-03-06',
        'Escritor, jornalista e ganhador do Prêmio Nobel de Literatura.'
    ),
    (
        'Paulo Coelho',
        'Brasileiro',
        '1947-08-24',
        'Um dos escritores mais lidos do mundo, autor de O Alquimista.'
    ),
    (
        'Agatha Christie',
        'Britânica',
        '1890-09-15',
        'Escritora britânica de romances policiais e de mistério.'
    ),
    (
        'Carlos Drummond de Andrade',
        'Brasileiro',
        '1902-10-31',
        'Poeta, contista e cronista brasileiro, considerado por muitos o mais influente poeta brasileiro.'
    ),
    (
        'Cecília Meireles',
        'Brasileira',
        '1901-11-07',
        'Poetisa, pintora, professora e jornalista brasileira.'
    );

-- ============================================
-- 5. CATEGORIA_MATERIAL
-- ============================================
INSERT INTO
    CATEGORIA_MATERIAL (
        nome_categoria,
        descricao,
        classificacao_decimal
    )
VALUES (
        'Ficção Brasileira',
        'Obras de ficção de autores brasileiros',
        '869.3'
    ),
    (
        'Ficção Estrangeira',
        'Obras de ficção de autores estrangeiros',
        '823'
    ),
    (
        'Não-ficção',
        'Livros técnicos, biografias e ensaios',
        '000'
    ),
    (
        'Referência',
        'Dicionários, enciclopédias e obras de consulta',
        '030'
    ),
    (
        'Poesia',
        'Coleção de poesias e poemas',
        '869.1'
    ),
    (
        'Literatura Infantojuvenil',
        'Livros para crianças e jovens',
        '028.5'
    ),
    (
        'Ciências',
        'Livros sobre ciências naturais e exatas',
        '500'
    );

-- ============================================
-- 6. MATERIAL
-- ============================================
INSERT INTO
    MATERIAL (
        id_editora,
        id_categoria_material,
        isbn,
        titulo,
        subtitulo,
        ano_publicacao,
        edicao,
        numero_paginas,
        idioma,
        tipo_material,
        sinopse
    )
VALUES (
        1,
        1,
        '978-8535902778',
        'Dom Casmurro',
        NULL,
        1899,
        '1ª',
        256,
        'Português',
        'Livro',
        'Romance clássico brasileiro sobre ciúmes e traição, narrado por Bentinho.'
    ),
    (
        2,
        1,
        '978-8520925683',
        'A Hora da Estrela',
        NULL,
        1977,
        '1ª',
        88,
        'Português',
        'Livro',
        'História de Macabéa, uma nordestina em São Paulo.'
    ),
    (
        3,
        1,
        '978-8532511010',
        'Capitães da Areia',
        NULL,
        1937,
        '1ª',
        280,
        'Português',
        'Livro',
        'Romance sobre meninos de rua em Salvador.'
    ),
    (
        3,
        2,
        '978-8532530787',
        'Harry Potter e a Pedra Filosofal',
        NULL,
        1997,
        '1ª',
        264,
        'Português',
        'Livro',
        'Primeiro livro da saga do bruxo Harry Potter.'
    ),
    (
        6,
        2,
        '978-0451524935',
        '1984',
        NULL,
        1949,
        '1ª',
        328,
        'Português',
        'Livro',
        'Distopia sobre um regime totalitário e vigilância em massa.'
    ),
    (
        5,
        2,
        '978-8501061867',
        'Cem Anos de Solidão',
        NULL,
        1967,
        '1ª',
        432,
        'Português',
        'Livro',
        'Obra-prima do realismo mágico sobre a família Buendía.'
    ),
    (
        4,
        3,
        '978-8598078378',
        'O Alquimista',
        NULL,
        1988,
        '1ª',
        208,
        'Português',
        'Livro',
        'Fábula sobre seguir seus sonhos e encontrar seu destino.'
    ),
    (
        7,
        2,
        '978-0062073488',
        'Assassinato no Expresso do Oriente',
        NULL,
        1934,
        '1ª',
        256,
        'Português',
        'Livro',
        'Mistério clássico com o detetive Hercule Poirot.'
    ),
    (
        1,
        5,
        '978-8535908770',
        'Claro Enigma',
        NULL,
        1951,
        '1ª',
        144,
        'Português',
        'Livro',
        'Coleção de poemas de Carlos Drummond de Andrade.'
    ),
    (
        2,
        5,
        '978-8526020146',
        'Viagem',
        NULL,
        1939,
        '1ª',
        96,
        'Português',
        'Livro',
        'Poesias de Cecília Meireles.'
    ),
    (
        3,
        2,
        '978-8532530794',
        'Harry Potter e a Câmara Secreta',
        NULL,
        1998,
        '1ª',
        288,
        'Português',
        'Livro',
        'Segundo livro da saga Harry Potter.'
    ),
    (
        3,
        2,
        '978-8532530800',
        'Harry Potter e o Prisioneiro de Azkaban',
        NULL,
        1999,
        '1ª',
        348,
        'Português',
        'Livro',
        'Terceiro livro da saga Harry Potter.'
    ),
    (
        1,
        1,
        '978-8535911664',
        'Memórias Póstumas de Brás Cubas',
        NULL,
        1881,
        '1ª',
        368,
        'Português',
        'Livro',
        'Romance narrado por um defunto autor.'
    ),
    (
        2,
        1,
        '978-8520923085',
        'A Paixão Segundo G.H.',
        NULL,
        1964,
        '1ª',
        176,
        'Português',
        'Livro',
        'Romance filosófico e introspectivo.'
    ),
    (
        5,
        3,
        '978-8501080284',
        'O Amor nos Tempos do Cólera',
        NULL,
        1985,
        '1ª',
        464,
        'Português',
        'Livro',
        'Romance sobre um amor que dura mais de cinquenta anos.'
    );

-- ============================================
-- 7. MATERIAL_AUTOR
-- ============================================
INSERT INTO
    MATERIAL_AUTOR (
        id_material,
        id_autor,
        ordem_autoria
    )
VALUES (1, 1, 1), -- Dom Casmurro - Machado de Assis
    (2, 2, 1), -- A Hora da Estrela - Clarice Lispector
    (3, 3, 1), -- Capitães da Areia - Jorge Amado
    (4, 4, 1), -- Harry Potter 1 - J.K. Rowling
    (5, 5, 1), -- 1984 - George Orwell
    (6, 6, 1), -- Cem Anos de Solidão - Gabriel García Márquez
    (7, 7, 1), -- O Alquimista - Paulo Coelho
    (8, 8, 1), -- Assassinato no Expresso - Agatha Christie
    (9, 9, 1), -- Claro Enigma - Drummond
    (10, 10, 1), -- Viagem - Cecília Meireles
    (11, 4, 1), -- Harry Potter 2 - J.K. Rowling
    (12, 4, 1), -- Harry Potter 3 - J.K. Rowling
    (13, 1, 1), -- Memórias Póstumas - Machado de Assis
    (14, 2, 1), -- A Paixão Segundo G.H. - Clarice Lispector
    (15, 6, 1);
-- O Amor nos Tempos do Cólera - García Márquez

-- ============================================
-- 8. EXEMPLAR
-- ============================================
INSERT INTO
    EXEMPLAR (
        id_material,
        codigo_barras,
        numero_exemplar,
        localizacao_fisica,
        status_exemplar,
        data_aquisicao,
        valor_aquisicao
    )
VALUES (
        1,
        '001234567890',
        1,
        'Estante A-12',
        'Disponível',
        '2023-01-15',
        35.00
    ),
    (
        1,
        '001234567891',
        2,
        'Estante A-12',
        'Disponível',
        '2023-01-15',
        35.00
    ),
    (
        2,
        '002345678901',
        1,
        'Estante A-15',
        'Disponível',
        '2023-02-20',
        28.00
    ),
    (
        3,
        '003456789012',
        1,
        'Estante B-03',
        'Disponível',
        '2023-03-10',
        42.00
    ),
    (
        4,
        '004567890123',
        1,
        'Estante C-18',
        'Emprestado',
        '2023-03-10',
        45.00
    ),
    (
        4,
        '004567890124',
        2,
        'Estante C-18',
        'Disponível',
        '2023-03-10',
        45.00
    ),
    (
        4,
        '004567890125',
        3,
        'Estante C-18',
        'Disponível',
        '2023-03-10',
        45.00
    ),
    (
        5,
        '005678901234',
        1,
        'Estante D-05',
        'Emprestado',
        '2023-04-05',
        38.00
    ),
    (
        6,
        '006789012345',
        1,
        'Estante D-08',
        'Disponível',
        '2023-04-15',
        52.00
    ),
    (
        7,
        '007890123456',
        1,
        'Estante E-01',
        'Disponível',
        '2023-05-20',
        30.00
    ),
    (
        7,
        '007890123457',
        2,
        'Estante E-01',
        'Emprestado',
        '2023-05-20',
        30.00
    ),
    (
        8,
        '008901234567',
        1,
        'Estante E-10',
        'Disponível',
        '2023-06-12',
        35.00
    ),
    (
        9,
        '009012345678',
        1,
        'Estante F-02',
        'Disponível',
        '2023-07-08',
        28.00
    ),
    (
        10,
        '010123456789',
        1,
        'Estante F-05',
        'Disponível',
        '2023-08-14',
        25.00
    ),
    (
        11,
        '011234567890',
        1,
        'Estante C-19',
        'Disponível',
        '2023-09-01',
        47.00
    ),
    (
        12,
        '012345678901',
        1,
        'Estante C-20',
        'Disponível',
        '2023-09-01',
        50.00
    ),
    (
        13,
        '013456789012',
        1,
        'Estante A-13',
        'Em Manutenção',
        '2023-10-05',
        40.00
    ),
    (
        14,
        '014567890123',
        1,
        'Estante A-16',
        'Disponível',
        '2023-10-20',
        32.00
    ),
    (
        15,
        '015678901234',
        1,
        'Estante D-09',
        'Disponível',
        '2023-11-10',
        54.00
    );

-- ============================================
-- 9. FUNCIONARIO
-- ============================================
INSERT INTO
    FUNCIONARIO (
        cpf,
        nome,
        cargo,
        email,
        telefone,
        data_contratacao,
        status_ativo
    )
VALUES (
        '111.222.333-44',
        'Maria Silva Santos',
        'Bibliotecária',
        'maria.silva@librarytech.com',
        '(11) 98765-4321',
        '2020-01-10',
        1
    ),
    (
        '222.333.444-55',
        'João Santos Oliveira',
        'Administrador',
        'joao.santos@librarytech.com',
        '(11) 98765-4322',
        '2019-05-15',
        1
    ),
    (
        '333.444.555-66',
        'Fernanda Costa Lima',
        'Catalogadora',
        'fernanda.costa@librarytech.com',
        '(11) 98765-4323',
        '2021-03-20',
        1
    ),
    (
        '444.555.666-77',
        'Ricardo Alves Pereira',
        'Atendente',
        'ricardo.alves@librarytech.com',
        '(11) 98765-4324',
        '2022-07-01',
        1
    );

-- ============================================
-- 10. EMPRESTIMO
-- ============================================
INSERT INTO
    EMPRESTIMO (
        id_usuario,
        id_exemplar,
        id_funcionario_emprestimo,
        id_funcionario_devolucao,
        data_emprestimo,
        data_prevista_devolucao,
        data_real_devolucao,
        status_emprestimo,
        observacoes
    )
VALUES (
        1,
        5,
        1,
        1,
        '2024-11-01',
        '2024-11-15',
        '2024-11-14',
        'Devolvido',
        'Devolução no prazo'
    ),
    (
        2,
        8,
        1,
        NULL,
        '2024-11-10',
        '2024-12-10',
        NULL,
        'Ativo',
        NULL
    ),
    (
        3,
        11,
        2,
        NULL,
        '2024-11-15',
        '2024-11-22',
        NULL,
        'Ativo',
        NULL
    ),
    (
        4,
        4,
        1,
        NULL,
        '2024-10-20',
        '2024-11-03',
        NULL,
        'Atrasado',
        'Usuário já foi notificado'
    ),
    (
        5,
        2,
        2,
        2,
        '2024-10-25',
        '2024-11-08',
        '2024-11-07',
        'Devolvido',
        'Devolvido em perfeito estado'
    ),
    (
        6,
        15,
        1,
        NULL,
        '2024-11-18',
        '2024-12-18',
        NULL,
        'Ativo',
        NULL
    ),
    (
        7,
        1,
        3,
        3,
        '2024-10-15',
        '2024-10-22',
        '2024-10-21',
        'Devolvido',
        NULL
    ),
    (
        8,
        10,
        1,
        NULL,
        '2024-11-12',
        '2024-11-26',
        NULL,
        'Ativo',
        NULL
    ),
    (
        1,
        12,
        2,
        NULL,
        '2024-11-20',
        '2024-12-04',
        NULL,
        'Ativo',
        'Segundo empréstimo do usuário'
    ),
    (
        9,
        14,
        1,
        NULL,
        '2024-11-05',
        '2024-12-05',
        NULL,
        'Ativo',
        NULL
    );

-- ============================================
-- 11. RENOVACAO
-- ============================================
INSERT INTO
    RENOVACAO (
        id_emprestimo,
        data_renovacao,
        nova_data_prevista,
        motivo
    )
VALUES (
        2,
        '2024-11-20',
        '2024-12-20',
        'Usuário solicitou renovação por ainda estar lendo'
    ),
    (
        3,
        '2024-11-22',
        '2024-11-29',
        'Primeira renovação'
    ),
    (
        6,
        '2024-11-25',
        '2024-12-25',
        'Material necessário para pesquisa'
    );

-- ============================================
-- 12. RESERVA
-- ============================================
INSERT INTO
    RESERVA (
        id_usuario,
        id_material,
        data_reserva,
        data_validade,
        status_reserva,
        posicao_fila
    )
VALUES (
        5,
        4,
        '2024-11-20',
        '2024-11-27',
        'Ativa',
        1
    ),
    (
        6,
        4,
        '2024-11-21',
        '2024-11-28',
        'Ativa',
        2
    ),
    (
        7,
        5,
        '2024-11-18',
        '2024-11-25',
        'Ativa',
        1
    ),
    (
        3,
        7,
        '2024-11-10',
        '2024-11-17',
        'Atendida',
        1
    ),
    (
        8,
        1,
        '2024-11-01',
        '2024-11-08',
        'Expirada',
        1
    );

-- ============================================
-- 13. MULTA
-- ============================================
INSERT INTO
    MULTA (
        id_emprestimo,
        valor_multa,
        dias_atraso,
        data_geracao,
        data_pagamento,
        status_pagamento,
        forma_pagamento
    )
VALUES (
        4,
        27.00,
        27,
        '2024-11-20',
        NULL,
        'Pendente',
        NULL
    ),
    (
        1,
        0.00,
        0,
        '2024-11-15',
        '2024-11-15',
        'Cancelado',
        NULL
    );

-- ============================================
-- Mensagem de Confirmação
-- ============================================
SELECT 'Dados inseridos com sucesso!' AS status;

SELECT COUNT(*) AS total_usuarios FROM USUARIO;

SELECT COUNT(*) AS total_materiais FROM MATERIAL;

SELECT COUNT(*) AS total_exemplares FROM EXEMPLAR;

SELECT COUNT(*) AS total_emprestimos FROM EMPRESTIMO;
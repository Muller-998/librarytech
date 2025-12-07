-- ============================================
-- SISTEMA DE GESTÃO DE BIBLIOTECA LIBRARYTECH
-- Script 03: Consultas (DML - SELECT)
-- ============================================
-- Autor: Seu Nome
-- Data: Novembro 2024
-- Descrição: Consultas variadas para análise de dados
-- ============================================

-- ============================================
-- CONSULTA 1: Listar todos os livros disponíveis
-- Objetivo: Mostrar acervo disponível para empréstimo
-- Recursos: WHERE, JOIN, ORDER BY
-- ============================================
SELECT m.titulo AS 'Título', a.nome_autor AS 'Autor', m.ano_publicacao AS 'Ano', e.localizacao_fisica AS 'Localização', e.codigo_barras AS 'Código de Barras'
FROM
    MATERIAL m
    INNER JOIN EXEMPLAR e ON m.id_material = e.id_material
    INNER JOIN MATERIAL_AUTOR ma ON m.id_material = ma.id_material
    INNER JOIN AUTOR a ON ma.id_autor = a.id_autor
WHERE
    e.status_exemplar = 'Disponível'
    AND m.tipo_material = 'Livro'
ORDER BY m.titulo;

-- ============================================
-- CONSULTA 2: Empréstimos ativos com informações completas
-- Objetivo: Monitorar empréstimos em andamento
-- Recursos: Multiple JOINs, WHERE, ORDER BY, Concatenação
-- ============================================
SELECT u.nome AS 'Usuário', u.cpf AS 'CPF', m.titulo AS 'Livro Emprestado', e_emp.data_emprestimo AS 'Data Empréstimo', e_emp.data_prevista_devolucao AS 'Previsão Devolução', (
        julianday ('now') - julianday (e_emp.data_prevista_devolucao)
    ) AS 'Dias de Atraso', f.nome AS 'Atendente'
FROM
    EMPRESTIMO e_emp
    INNER JOIN USUARIO u ON e_emp.id_usuario = u.id_usuario
    INNER JOIN EXEMPLAR ex ON e_emp.id_exemplar = ex.id_exemplar
    INNER JOIN MATERIAL m ON ex.id_material = m.id_material
    INNER JOIN FUNCIONARIO f ON e_emp.id_funcionario_emprestimo = f.id_funcionario
WHERE
    e_emp.status_emprestimo IN ('Ativo', 'Atrasado')
ORDER BY e_emp.data_prevista_devolucao ASC;

-- ============================================
-- CONSULTA 3: Ranking de livros mais emprestados
-- Objetivo: Identificar materiais populares
-- Recursos: COUNT, GROUP BY, ORDER BY, LIMIT, JOIN
-- ============================================
SELECT m.titulo AS 'Título', a.nome_autor AS 'Autor', COUNT(e.id_emprestimo) AS 'Total de Empréstimos', m.ano_publicacao AS 'Ano Publicação'
FROM
    MATERIAL m
    INNER JOIN MATERIAL_AUTOR ma ON m.id_material = ma.id_material
    INNER JOIN AUTOR a ON ma.id_autor = a.id_autor
    INNER JOIN EXEMPLAR ex ON m.id_material = ex.id_material
    LEFT JOIN EMPRESTIMO e ON ex.id_exemplar = e.id_exemplar
GROUP BY
    m.id_material,
    m.titulo,
    a.nome_autor,
    m.ano_publicacao
ORDER BY COUNT(e.id_emprestimo) DESC
LIMIT 10;

-- ============================================
-- CONSULTA 4: Usuários com multas pendentes
-- Objetivo: Controlar inadimplência
-- Recursos: WHERE, JOIN, Funções de agregação
-- ============================================
SELECT u.nome AS 'Nome do Usuário', u.cpf AS 'CPF', u.email AS 'Email', m_multa.valor_multa AS 'Valor da Multa (R$)', m_multa.dias_atraso AS 'Dias de Atraso', m_multa.data_geracao AS 'Data Geração', mat.titulo AS 'Livro Relacionado'
FROM
    MULTA m_multa
    INNER JOIN EMPRESTIMO e ON m_multa.id_emprestimo = e.id_emprestimo
    INNER JOIN USUARIO u ON e.id_usuario = u.id_usuario
    INNER JOIN EXEMPLAR ex ON e.id_exemplar = ex.id_exemplar
    INNER JOIN MATERIAL mat ON ex.id_material = mat.id_material
WHERE
    m_multa.status_pagamento = 'Pendente'
ORDER BY m_multa.valor_multa DESC;

-- ============================================
-- CONSULTA 5: Estatísticas por categoria de usuário
-- Objetivo: Analisar uso da biblioteca por perfil
-- Recursos: Subquery, GROUP BY, AVG, COUNT
-- ============================================
SELECT cu.nome_categoria AS 'Categoria', COUNT(DISTINCT u.id_usuario) AS 'Total de Usuários', COUNT(e.id_emprestimo) AS 'Total de Empréstimos', ROUND(
        CAST(
            COUNT(e.id_emprestimo) AS FLOAT
        ) / COUNT(DISTINCT u.id_usuario), 2
    ) AS 'Média Empréstimos/Usuário', cu.qtd_max_emprestimos AS 'Limite Permitido'
FROM
    CATEGORIA_USUARIO cu
    INNER JOIN USUARIO u ON cu.id_categoria = u.id_categoria
    LEFT JOIN EMPRESTIMO e ON u.id_usuario = e.id_usuario
GROUP BY
    cu.id_categoria,
    cu.nome_categoria,
    cu.qtd_max_emprestimos
ORDER BY COUNT(e.id_emprestimo) DESC;

-- ============================================
-- CONSULTA 6 (BÔNUS): Reservas ativas com fila de espera
-- Objetivo: Gerenciar demanda por materiais
-- Recursos: WHERE, ORDER BY, JOIN
-- ============================================
SELECT m.titulo AS 'Material Reservado', u.nome AS 'Usuário', u.email AS 'Email', r.data_reserva AS 'Data Reserva', r.data_validade AS 'Válido Até', r.posicao_fila AS 'Posição na Fila', r.status_reserva AS 'Status'
FROM
    RESERVA r
    INNER JOIN USUARIO u ON r.id_usuario = u.id_usuario
    INNER JOIN MATERIAL m ON r.id_material = m.id_material
WHERE
    r.status_reserva = 'Ativa'
ORDER BY m.titulo, r.posicao_fila;

-- ============================================
-- CONSULTA 7 (BÔNUS): Histórico completo de um usuário específico
-- Objetivo: Rastreabilidade de atividades
-- Recursos: WHERE com CPF, Multiple JOINs, UNION
-- ============================================
-- Empréstimos do usuário
SELECT
    'Empréstimo' AS 'Tipo',
    m.titulo AS 'Material',
    e.data_emprestimo AS 'Data',
    e.status_emprestimo AS 'Status',
    CASE
        WHEN e.data_real_devolucao IS NOT NULL THEN 'Devolvido em ' || e.data_real_devolucao
        ELSE 'Previsão: ' || e.data_prevista_devolucao
    END AS 'Detalhes'
FROM
    EMPRESTIMO e
    INNER JOIN USUARIO u ON e.id_usuario = u.id_usuario
    INNER JOIN EXEMPLAR ex ON e.id_exemplar = ex.id_exemplar
    INNER JOIN MATERIAL m ON ex.id_material = m.id_material
WHERE
    u.cpf = '123.456.789-00'
UNION ALL

-- Reservas do usuário
SELECT 'Reserva' AS 'Tipo', m.titulo AS 'Material', r.data_reserva AS 'Data', r.status_reserva AS 'Status', 'Posição na fila: ' || r.posicao_fila AS 'Detalhes'
FROM
    RESERVA r
    INNER JOIN USUARIO u ON r.id_usuario = u.id_usuario
    INNER JOIN MATERIAL m ON r.id_material = m.id_material
WHERE
    u.cpf = '123.456.789-00'
ORDER BY Data DESC;

-- ============================================
-- CONSULTA 8 (BÔNUS): Autores mais populares
-- Objetivo: Identificar preferências dos leitores
-- Recursos: GROUP BY, COUNT, JOIN
-- ============================================
SELECT a.nome_autor AS 'Autor', a.nacionalidade AS 'Nacionalidade', COUNT(DISTINCT m.id_material) AS 'Obras no Acervo', COUNT(e.id_emprestimo) AS 'Total Empréstimos', ROUND(
        CAST(
            COUNT(e.id_emprestimo) AS FLOAT
        ) / COUNT(DISTINCT m.id_material), 2
    ) AS 'Média Emp/Obra'
FROM
    AUTOR a
    INNER JOIN MATERIAL_AUTOR ma ON a.id_autor = ma.id_autor
    INNER JOIN MATERIAL m ON ma.id_material = m.id_material
    INNER JOIN EXEMPLAR ex ON m.id_material = ex.id_material
    LEFT JOIN EMPRESTIMO e ON ex.id_exemplar = e.id_exemplar
GROUP BY
    a.id_autor,
    a.nome_autor,
    a.nacionalidade
HAVING
    COUNT(e.id_emprestimo) > 0
ORDER BY COUNT(e.id_emprestimo) DESC
LIMIT 5;

-- ============================================
-- RESUMO DAS CONSULTAS REALIZADAS
-- ============================================
SELECT '=== Resumo das Consultas Executadas ===' AS '';

SELECT '1. Livros Disponíveis' AS 'Consulta';

SELECT '2. Empréstimos Ativos' AS 'Consulta';

SELECT '3. Ranking de Livros Mais Emprestados' AS 'Consulta';

SELECT '4. Usuários com Multas Pendentes' AS 'Consulta';

SELECT '5. Estatísticas por Categoria de Usuário' AS 'Consulta';

SELECT '6. Reservas Ativas (Bônus)' AS 'Consulta';

SELECT '7. Histórico de Usuário (Bônus)' AS 'Consulta';

SELECT '8. Autores Mais Populares (Bônus)' AS 'Consulta';
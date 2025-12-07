-- ============================================
-- SISTEMA DE GESTÃO DE BIBLIOTECA BIBLIOTECH
-- Script 04: Atualizações (DML - UPDATE)
-- ============================================
-- Autor: Seu Nome
-- Data: Novembro 2024
-- Descrição: Comandos de atualização de dados
-- ============================================

-- ============================================
-- UPDATE 1: Atualizar email de um usuário
-- Cenário: Usuário solicitou alteração de email
-- ============================================
UPDATE USUARIO
SET
    email = 'ana.costa.nova@email.com'
WHERE
    cpf = '123.456.789-00';

-- Verificação
SELECT nome, cpf, email FROM USUARIO WHERE cpf = '123.456.789-00';

-- ============================================
-- UPDATE 2: Registrar devolução de livro
-- Cenário: Usuário devolveu livro emprestado
-- ============================================
UPDATE EMPRESTIMO
SET
    data_real_devolucao = '2024-11-25',
    status_emprestimo = 'Devolvido',
    id_funcionario_devolucao = 2,
    observacoes = 'Livro devolvido em perfeito estado'
WHERE
    id_emprestimo = 3;

-- Atualizar status do exemplar para disponível
UPDATE EXEMPLAR
SET
    status_exemplar = 'Disponível'
WHERE
    id_exemplar = (
        SELECT id_exemplar
        FROM EMPRESTIMO
        WHERE
            id_emprestimo = 3
    );

-- Verificação
SELECT e.id_emprestimo, u.nome, m.titulo, e.status_emprestimo, e.data_real_devolucao
FROM
    EMPRESTIMO e
    JOIN USUARIO u ON e.id_usuario = u.id_usuario
    JOIN EXEMPLAR ex ON e.id_exemplar = ex.id_exemplar
    JOIN MATERIAL m ON ex.id_material = m.id_material
WHERE
    e.id_emprestimo = 3;

-- ============================================
-- UPDATE 3: Registrar pagamento de multa
-- Cenário: Usuário pagou multa pendente
-- ============================================
UPDATE MULTA
SET
    status_pagamento = 'Pago',
    data_pagamento = '2024-11-26',
    forma_pagamento = 'PIX'
WHERE
    id_multa = 1;

-- Verificação
SELECT m.id_multa, u.nome, m.valor_multa, m.status_pagamento, m.forma_pagamento
FROM
    MULTA m
    JOIN EMPRESTIMO e ON m.id_emprestimo = e.id_emprestimo
    JOIN USUARIO u ON e.id_usuario = u.id_usuario
WHERE
    m.id_multa = 1;

-- ============================================
-- UPDATE 4: Atualizar localização de exemplar
-- Cenário: Reorganização do acervo
-- ============================================
UPDATE EXEMPLAR
SET
    localizacao_fisica = 'Estante A-14'
WHERE
    codigo_barras = '001234567890';

-- Verificação
SELECT e.codigo_barras, m.titulo, e.localizacao_fisica
FROM EXEMPLAR e
    JOIN MATERIAL m ON e.id_material = m.id_material
WHERE
    e.codigo_barras = '001234567890';

-- ============================================
-- UPDATE 5: Marcar empréstimo como atrasado
-- Cenário: Sistema identifica atrasos automaticamente
-- ============================================
UPDATE EMPRESTIMO
SET
    status_emprestimo = 'Atrasado'
WHERE
    data_prevista_devolucao < DATE('now')
    AND data_real_devolucao IS NULL
    AND status_emprestimo = 'Ativo';

-- Verificação
SELECT u.nome, m.titulo, e.data_prevista_devolucao, e.status_emprestimo, (
        julianday ('now') - julianday (e.data_prevista_devolucao)
    ) AS dias_atraso
FROM
    EMPRESTIMO e
    JOIN USUARIO u ON e.id_usuario = u.id_usuario
    JOIN EXEMPLAR ex ON e.id_exemplar = ex.id_exemplar
    JOIN MATERIAL m ON ex.id_material = m.id_material
WHERE
    e.status_emprestimo = 'Atrasado';

-- ============================================
-- UPDATE 6: Atualizar telefone de múltiplos usuários
-- Cenário: Atualização em lote de dados de contato
-- ============================================
UPDATE USUARIO
SET
    telefone = '(11) 99999-' || SUBSTR(cpf, 10, 4)
WHERE
    id_categoria = 1
    AND telefone IS NULL;

-- Verificação
SELECT nome, cpf, telefone, id_categoria
FROM USUARIO
WHERE
    id_categoria = 1;

-- ============================================
-- UPDATE 7: Desativar usuários inativos há mais de 1 ano
-- Cenário: Limpeza de cadastros inativos
-- ============================================
-- Primeiro, vamos verificar quem seria afetado
SELECT u.nome, u.email, u.data_cadastro, (
        julianday ('now') - julianday (u.data_cadastro)
    ) AS dias_sem_atividade
FROM USUARIO u
WHERE
    NOT EXISTS (
        SELECT 1
        FROM EMPRESTIMO e
        WHERE
            e.id_usuario = u.id_usuario
            AND e.data_emprestimo > DATE('now', '-365 days')
    )
    AND u.status_ativo = 1;

-- Executar a desativação (comentado por segurança)
-- UPDATE USUARIO
-- SET status_ativo = 0
-- WHERE NOT EXISTS (
--     SELECT 1
--     FROM EMPRESTIMO e
--     WHERE e.id_usuario = USUARIO.id_usuario
--       AND e.data_emprestimo > DATE('now', '-365 days')
-- )
-- AND status_ativo = 1;

-- ============================================
-- UPDATE 8 (BÔNUS): Atender reserva automaticamente
-- Cenário: Material foi devolvido e há reserva ativa
-- ============================================
UPDATE RESERVA
SET
    status_reserva = 'Atendida'
WHERE
    id_material = 4
    AND posicao_fila = 1
    AND status_reserva = 'Ativa';

-- Notificação (simulada com SELECT)
SELECT 'NOTIFICAÇÃO: Material disponível!' AS mensagem, u.nome, u.email, m.titulo
FROM
    RESERVA r
    JOIN USUARIO u ON r.id_usuario = u.id_usuario
    JOIN MATERIAL m ON r.id_material = m.id_material
WHERE
    r.id_material = 4
    AND r.status_reserva = 'Atendida'
    AND r.posicao_fila = 1;

-- ============================================
-- UPDATE 9 (BÔNUS): Corrigir dados de material
-- Cenário: Erro identificado em cadastro
-- ============================================
UPDATE MATERIAL
SET
    ano_publicacao = 2007,
    edicao = '2ª Edição Revisada'
WHERE
    isbn = '978-8532530787';

-- Verificação
SELECT
    titulo,
    ano_publicacao,
    edicao,
    isbn
FROM MATERIAL
WHERE
    isbn = '978-8532530787';

-- ============================================
-- RESUMO DAS ATUALIZAÇÕES REALIZADAS
-- ============================================
SELECT '=== Resumo das Atualizações Executadas ===' AS '';

SELECT 'UPDATE 1: Email de usuário atualizado' AS 'Operação';

SELECT 'UPDATE 2: Devolução de livro registrada' AS 'Operação';

SELECT 'UPDATE 3: Multa paga e quitada' AS 'Operação';

SELECT 'UPDATE 4: Localização de exemplar atualizada' AS 'Operação';

SELECT 'UPDATE 5: Empréstimos marcados como atrasados' AS 'Operação';

SELECT 'UPDATE 6: Telefones atualizados em lote' AS 'Operação';

SELECT 'UPDATE 7: Verificação de usuários inativos' AS 'Operação';

SELECT 'UPDATE 8: Reserva atendida' AS 'Operação';

SELECT 'UPDATE 9: Dados de material corrigidos' AS 'Operação';
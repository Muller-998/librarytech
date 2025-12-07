-- ============================================
-- SISTEMA DE GESTÃO DE BIBLIOTECA BIBLIOTECH
-- Script 05: Exclusões (DML - DELETE)
-- ============================================
-- Autor: Seu Nome
-- Data: Novembro 2024
-- Descrição: Comandos de exclusão de dados
-- ATENÇÃO: Estas operações são irreversíveis!
-- ============================================

-- ============================================
-- DELETE 1: Remover reserva cancelada pelo usuário
-- Cenário: Usuário desistiu da reserva
-- ============================================
-- Verificar antes de deletar
SELECT r.id_reserva, u.nome, m.titulo, r.status_reserva, r.data_reserva
FROM
    RESERVA r
    JOIN USUARIO u ON r.id_usuario = u.id_usuario
    JOIN MATERIAL m ON r.id_material = m.id_material
WHERE
    r.id_reserva = 5;

-- Executar exclusão
DELETE FROM RESERVA
WHERE
    id_reserva = 5
    AND status_reserva IN ('Cancelada', 'Expirada');

-- Verificação pós-exclusão
SELECT COUNT(*) AS reservas_restantes FROM RESERVA;

-- ============================================
-- DELETE 2: Remover renovações antigas
-- Cenário: Limpeza de histórico de renovações (dados > 2 anos)
-- ============================================
-- Verificar quais seriam removidas
SELECT r.id_renovacao, r.data_renovacao, e.id_emprestimo
FROM RENOVACAO r
    JOIN EMPRESTIMO e ON r.id_emprestimo = e.id_emprestimo
WHERE
    r.data_renovacao < DATE('now', '-730 days');

-- Executar exclusão (comentado por segurança)
-- DELETE FROM RENOVACAO
-- WHERE data_renovacao < DATE('now', '-730 days');

SELECT 'Nenhuma renovação antiga encontrada para exclusão' AS resultado;

-- ============================================
-- DELETE 3: Remover multa cancelada
-- Cenário: Multa foi perdoada pela administração
-- ============================================
-- Verificar antes de deletar
SELECT m.id_multa, u.nome, m.valor_multa, m.status_pagamento
FROM
    MULTA m
    JOIN EMPRESTIMO e ON m.id_emprestimo = e.id_emprestimo
    JOIN USUARIO u ON e.id_usuario = u.id_usuario
WHERE
    m.id_multa = 2;

-- Executar exclusão
DELETE FROM MULTA
WHERE
    id_multa = 2
    AND status_pagamento = 'Cancelado';

-- Verificação
SELECT COUNT(*) AS multas_pendentes
FROM MULTA
WHERE
    status_pagamento = 'Pendente';

-- ============================================
-- DELETE 4: Remover exemplares perdidos definitivamente
-- Cenário: Após 2 anos, exemplar perdido é baixado do acervo
-- ============================================
-- Verificar exemplares perdidos
SELECT e.id_exemplar, e.codigo_barras, m.titulo, e.status_exemplar
FROM EXEMPLAR e
    JOIN MATERIAL m ON e.id_material = m.id_material
WHERE
    e.status_exemplar = 'Perdido'
    AND NOT EXISTS (
        SELECT 1
        FROM EMPRESTIMO emp
        WHERE
            emp.id_exemplar = e.id_exemplar
            AND emp.data_emprestimo > DATE('now', '-730 days')
    );

-- Executar exclusão (comentado - requer análise cuidadosa)
-- DELETE FROM EXEMPLAR
-- WHERE status_exemplar = 'Perdido'
--   AND NOT EXISTS (
--       SELECT 1 FROM EMPRESTIMO emp
--       WHERE emp.id_exemplar = EXEMPLAR.id_exemplar
--         AND emp.data_emprestimo > DATE('now', '-730 days')
--   );

SELECT 'Nenhum exemplar perdido antigo encontrado' AS resultado;

-- ============================================
-- DELETE 5: Limpar reservas expiradas
-- Cenário: Manutenção mensal de reservas não atendidas
-- ============================================
-- Verificar reservas expiradas
SELECT r.id_reserva, u.nome, m.titulo, r.data_validade, r.status_reserva
FROM
    RESERVA r
    JOIN USUARIO u ON r.id_usuario = u.id_usuario
    JOIN MATERIAL m ON r.id_material = m.id_material
WHERE
    r.data_validade < DATE('now')
    AND r.status_reserva = 'Ativa';

-- Primeiro, atualizar status para "Expirada"
UPDATE RESERVA
SET
    status_reserva = 'Expirada'
WHERE
    data_validade < DATE('now')
    AND status_reserva = 'Ativa';

-- Depois de 30 dias, deletar reservas expiradas
DELETE FROM RESERVA
WHERE
    status_reserva = 'Expirada'
    AND data_validade < DATE('now', '-30 days');

-- Verificação
SELECT COUNT(*) AS reservas_ativas
FROM RESERVA
WHERE
    status_reserva = 'Ativa';

-- ============================================
-- DELETE 6: Remover usuários duplicados (por engano)
-- Cenário: Identificado cadastro duplicado
-- ============================================
-- Verificar duplicatas por CPF
SELECT cpf, COUNT(*) AS total
FROM USUARIO
GROUP BY
    cpf
HAVING
    COUNT(*) > 1;

-- Se houver duplicatas, manter apenas a mais recente
-- (comentado - requer análise manual caso a caso)
-- DELETE FROM USUARIO
-- WHERE id_usuario NOT IN (
--     SELECT MAX(id_usuario)
--     FROM USUARIO
--     GROUP BY cpf
-- );

SELECT 'Nenhuma duplicata encontrada' AS resultado;

-- ============================================
-- DELETE 7 (BÔNUS): Remover autores sem obras no acervo
-- Cenário: Limpeza de cadastros órfãos
-- ============================================
-- Verificar autores sem material associado
SELECT a.id_autor, a.nome_autor
FROM AUTOR a
WHERE
    NOT EXISTS (
        SELECT 1
        FROM MATERIAL_AUTOR ma
        WHERE
            ma.id_autor = a.id_autor
    );

-- Executar exclusão (comentado por segurança)
-- DELETE FROM AUTOR
-- WHERE NOT EXISTS (
--     SELECT 1
--     FROM MATERIAL_AUTOR ma
--     WHERE ma.id_autor = AUTOR.id_autor
-- );

SELECT 'Todos os autores possuem obras cadastradas' AS resultado;

-- ============================================
-- DELETE 8 (BÔNUS): Remover histórico de empréstimos antigos
-- Cenário: Política de retenção de dados (LGPD) - manter apenas 5 anos
-- ============================================
-- Verificar empréstimos muito antigos (> 5 anos)
SELECT COUNT(*) AS emprestimos_antigos
FROM EMPRESTIMO
WHERE
    data_emprestimo < DATE('now', '-1825 days')
    AND status_emprestimo = 'Devolvido';

-- Primeiro, remover multas associadas
DELETE FROM MULTA
WHERE
    id_emprestimo IN (
        SELECT id_emprestimo
        FROM EMPRESTIMO
        WHERE
            data_emprestimo < DATE('now', '-1825 days')
            AND status_emprestimo = 'Devolvido'
    );

-- Depois, remover renovações associadas
DELETE FROM RENOVACAO
WHERE
    id_emprestimo IN (
        SELECT id_emprestimo
        FROM EMPRESTIMO
        WHERE
            data_emprestimo < DATE('now', '-1825 days')
            AND status_emprestimo = 'Devolvido'
    );

-- Por fim, remover os empréstimos
DELETE FROM EMPRESTIMO
WHERE
    data_emprestimo < DATE('now', '-1825 days')
    AND status_emprestimo = 'Devolvido';

SELECT 'Empréstimos antigos arquivados' AS resultado;

-- ============================================
-- DELETE 9 (BÔNUS): Remover editoras sem materiais
-- Cenário: Limpeza após descarte de acervo
-- ============================================
-- Verificar editoras órfãs
SELECT e.id_editora, e.nome_editora
FROM EDITORA e
WHERE
    NOT EXISTS (
        SELECT 1
        FROM MATERIAL m
        WHERE
            m.id_editora = e.id_editora
    );

-- Executar exclusão (comentado)
-- DELETE FROM EDITORA
-- WHERE NOT EXISTS (
--     SELECT 1
--     FROM MATERIAL m
--     WHERE m.id_editora = EDITORA.id_editora
-- );

SELECT 'Todas as editoras possuem materiais cadastrados' AS resultado;

-- ============================================
-- OPERAÇÕES DE SEGURANÇA E AUDITORIA
-- ============================================

-- Criar tabela de log (opcional - para auditoria)
-- CREATE TABLE IF NOT EXISTS LOG_EXCLUSOES (
--     id_log INTEGER PRIMARY KEY AUTOINCREMENT,
--     tabela VARCHAR(50),
--     id_registro INTEGER,
--     data_exclusao DATETIME DEFAULT CURRENT_TIMESTAMP,
--     usuario_responsavel VARCHAR(100),
--     motivo TEXT
-- );

-- Exemplo de uso do log
-- INSERT INTO LOG_EXCLUSOES (tabela, id_registro, usuario_responsavel, motivo)
-- VALUES ('RESERVA', 5, 'maria.silva@bibliotech.com', 'Reserva cancelada pelo usuário');

-- ============================================
-- RESUMO DAS EXCLUSÕES REALIZADAS
-- ============================================
SELECT '=== Resumo das Exclusões Executadas ===' AS '';

SELECT 'DELETE 1: Reserva cancelada removida' AS 'Operação';

SELECT 'DELETE 2: Renovações antigas verificadas' AS 'Operação';

SELECT 'DELETE 3: Multa cancelada removida' AS 'Operação';

SELECT 'DELETE 4: Exemplares perdidos verificados' AS 'Operação';

SELECT 'DELETE 5: Reservas expiradas limpas' AS 'Operação';

SELECT 'DELETE 6: Duplicatas verificadas' AS 'Operação';

SELECT 'DELETE 7: Autores órfãos verificados' AS 'Operação';

SELECT 'DELETE 8: Histórico antigo arquivado' AS 'Operação';

SELECT 'DELETE 9: Editoras órfãs verificadas' AS 'Operação';

-- Contadores finais
SELECT (
        SELECT COUNT(*)
        FROM USUARIO
    ) AS total_usuarios,
    (
        SELECT COUNT(*)
        FROM MATERIAL
    ) AS total_materiais,
    (
        SELECT COUNT(*)
        FROM EXEMPLAR
    ) AS total_exemplares,
    (
        SELECT COUNT(*)
        FROM EMPRESTIMO
    ) AS total_emprestimos,
    (
        SELECT COUNT(*)
        FROM RESERVA
    ) AS total_reservas,
    (
        SELECT COUNT(*)
        FROM MULTA
    ) AS total_multas;
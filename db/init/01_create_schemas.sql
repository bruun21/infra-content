-- Criação de schemas necessários para a stack
-- Este script roda apenas na primeira inicialização do cluster Postgres
-- (quando o diretório de dados está vazio)

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.schemata WHERE schema_name = 'carousel'
    ) THEN
        EXECUTE 'CREATE SCHEMA carousel AUTHORIZATION postgres';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.schemata WHERE schema_name = 'orchestrator'
    ) THEN
        EXECUTE 'CREATE SCHEMA orchestrator AUTHORIZATION postgres';
    END IF;
END$$;


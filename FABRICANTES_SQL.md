# Script SQL para Tabela de Fabricantes - SQLite

## Criação da Tabela Principal

```sql
CREATE TABLE IF NOT EXISTS fabricantes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL UNIQUE,
    descricao TEXT,
    nome_contato_principal TEXT,
    email_contato TEXT,
    telefone_contato TEXT,
    ativo INTEGER NOT NULL DEFAULT 1,
    data_criacao TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints de validação
    CONSTRAINT chk_nome_length CHECK (LENGTH(nome) >= 2),
    CONSTRAINT chk_email_format CHECK (
        email_contato IS NULL OR 
        email_contato LIKE '%@%.%'
    ),
    CONSTRAINT chk_telefone_format CHECK (
        telefone_contato IS NULL OR 
        LENGTH(telefone_contato) >= 10
    ),
    CONSTRAINT chk_ativo_bool CHECK (ativo IN (0, 1))
);
```

## Índices para Performance

```sql
-- Índice para busca por nome
CREATE INDEX IF NOT EXISTS idx_fabricantes_nome 
ON fabricantes(nome);

-- Índice para filtrar por status ativo
CREATE INDEX IF NOT EXISTS idx_fabricantes_ativo 
ON fabricantes(ativo);

-- Índice para busca por email
CREATE INDEX IF NOT EXISTS idx_fabricantes_email 
ON fabricantes(email_contato);
```

## Trigger para Atualização Automática de Timestamp

```sql
CREATE TRIGGER IF NOT EXISTS update_fabricantes_timestamp 
AFTER UPDATE ON fabricantes
BEGIN
    UPDATE fabricantes 
    SET data_atualizacao = CURRENT_TIMESTAMP 
    WHERE id = NEW.id;
END;
```

## Explicação dos Campos

### Campos Obrigatórios:
- **id**: Chave primária auto-incremento
- **nome**: Nome do fabricante (único, mínimo 2 caracteres)
- **ativo**: Status booleano (0 = inativo, 1 = ativo)
- **data_criacao**: Timestamp de criação automático
- **data_atualizacao**: Timestamp de última atualização automático

### Campos Opcionais:
- **descricao**: Descrição detalhada do fabricante
- **nome_contato_principal**: Nome do contato principal
- **email_contato**: Email de contato (validação básica de formato)
- **telefone_contato**: Telefone com máscara aplicada pela aplicação

## Validações Implementadas:

1. **Nome único**: Evita duplicação de fabricantes
2. **Nome mínimo**: Pelo menos 2 caracteres
3. **Email válido**: Formato básico de email quando informado
4. **Telefone válido**: Mínimo 10 caracteres quando informado
5. **Status booleano**: Apenas valores 0 ou 1
6. **Timestamps automáticos**: Controle de criação e atualização

## Características do SQLite Utilizadas:

- **AUTOINCREMENT**: Para chave primária sequencial
- **UNIQUE**: Para evitar nomes duplicados
- **CHECK CONSTRAINTS**: Para validação de dados
- **DEFAULT VALUES**: Para valores padrão
- **TRIGGERS**: Para automação de timestamps
- **INDEXES**: Para otimização de consultas
- **CURRENT_TIMESTAMP**: Para timestamps automáticos

## Padrões de Telefone Suportados:

- **Fixo**: (11) 1234-5678
- **Celular**: (11) 91234-5678
- Formato aplicado automaticamente pela aplicação Flutter

## Operações CRUD Disponíveis:

1. **Create**: Inserção com validações
2. **Read**: Consultas com filtros e ordenação
3. **Update**: Atualização com timestamp automático
4. **Delete**: Soft delete (inativação) e hard delete
5. **Search**: Busca por nome parcial
6. **Count**: Contagem com filtros
7. **Exists**: Verificação de existência

## Exemplo de Uso:

```sql
-- Inserir fabricante
INSERT INTO fabricantes (nome, descricao, nome_contato_principal, email_contato, telefone_contato)
VALUES ('Schwinn Fitness', 'Líder em equipamentos de spinning', 'João Silva', 'contato@schwinn.com', '(11) 1234-5678');

-- Buscar fabricantes ativos
SELECT * FROM fabricantes WHERE ativo = 1 ORDER BY nome;

-- Buscar por nome
SELECT * FROM fabricantes WHERE nome LIKE '%Schwinn%';

-- Inativar fabricante (soft delete)
UPDATE fabricantes SET ativo = 0 WHERE id = 1;

-- Contar fabricantes ativos
SELECT COUNT(*) FROM fabricantes WHERE ativo = 1;
```

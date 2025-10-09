CREATE DATABASE IF NOT EXISTS aula_02102025 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
SHOW CREATE DATABASE aula_02102025;
USE aula_02102025;

-- 1) Criação do Banco de Dados

CREATE TABLE IF NOT EXISTS clientes (
    id_cliente BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) UNIQUE,
    email VARCHAR(255) UNIQUE,
    data_nascimento DATE,
    senha VARCHAR(255) NOT NULL,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deletado_em DATETIME NULL
);

DESCRIBE clientes;

CREATE TABLE IF NOT EXISTS produtos (
    id_produto BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT NULL,
    estoque DECIMAL(10,3) NOT NULL DEFAULT 0,
    preco DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deletado_em DATETIME NULL
);

CREATE TABLE IF NOT EXISTS vendas (
    id_venda BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    cliente_id BIGINT UNSIGNED NOT NULL,
    data_venda DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deletado_em DATETIME NULL,
    -- nomeando a FK para facilitar alteração depois
    CONSTRAINT fk_vendas_clientes FOREIGN KEY (cliente_id) REFERENCES clientes (id_cliente)
);

CREATE TABLE IF NOT EXISTS venda_itens (
    venda_id BIGINT UNSIGNED NOT NULL,
    produto_id BIGINT UNSIGNED NOT NULL,
    quantidade DECIMAL(10,3) NOT NULL DEFAULT 1,
    preco_unitario DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (venda_id, produto_id),
    CONSTRAINT fk_vendaitens_vendas FOREIGN KEY (venda_id) REFERENCES vendas (id_venda),
    CONSTRAINT fk_vendaitens_produtos FOREIGN KEY (produto_id) REFERENCES produtos (id_produto)
);

-- 2) Modificações Estruturais

RENAME TABLE clientes TO usuarios;

-- Alterando nome da PK
ALTER TABLE usuarios
    CHANGE COLUMN id_cliente id_usuario BIGINT UNSIGNED NOT NULL AUTO_INCREMENT;

-- Dropando a FK antiga
ALTER TABLE vendas
    DROP FOREIGN KEY fk_vendas_clientes;
    
-- Add nova FK

ALTER TABLE vendas
    ADD CONSTRAINT fk_vendas_usuarios FOREIGN KEY (cliente_id) REFERENCES usuarios (id_usuario);

-- Shor estruturas atulizadas
DESCRIBE usuarios;
DESCRIBE vendas;

-- 3) Adição e Modificação de Campos

ALTER TABLE usuarios ADD COLUMN ativo TINYINT DEFAULT 1 AFTER deletado_em;
ALTER TABLE produtos ADD COLUMN ativo TINYINT DEFAULT 1 AFTER deletado_em;
ALTER TABLE vendas ADD COLUMN ativo TINYINT DEFAULT 1 AFTER deletado_em;
ALTER TABLE venda_itens ADD COLUMN ativo TINYINT DEFAULT 1 AFTER criado_em;

DESCRIBE usuarios;
DESCRIBE produtos;
DESCRIBE vendas;
DESCRIBE venda_itens;

ALTER TABLE usuarios MODIFY COLUMN ativo CHAR(1) DEFAULT '1';
ALTER TABLE produtos MODIFY COLUMN ativo CHAR(1) DEFAULT '1';
ALTER TABLE vendas MODIFY COLUMN ativo CHAR(1) DEFAULT '1';
ALTER TABLE venda_itens MODIFY COLUMN ativo CHAR(1) DEFAULT '1';

DESCRIBE usuarios;
DESCRIBE produtos;
DESCRIBE vendas;
DESCRIBE venda_itens;

-- 4) Gerenciamento de Acesso

CREATE USER IF NOT EXISTS 'altair'@'localhost' IDENTIFIED BY 'SenhaForte123!';
-- Conceder CRUD (SELECT, INSERT, UPDATE, DELETE) em todas as tabelas do BD
GRANT SELECT, INSERT, UPDATE, DELETE ON aula_02102025.* TO 'altair'@'localhost';

-- Também pode conceder uso básico do BD
GRANT USAGE ON *.* TO 'altair'@'localhost';

FLUSH PRIVILEGES; -- recarregando permissões dos usuários

-- Vou ser sincero um pouco precisei da ajuda do chat, mas com conciencia, principalmente nesse
-- finalzinho, perdão Ronan!

INSERT INTO usuarios (nome, cpf, email, data_nascimento, senha, ativo) VALUES
('Aluno Teste', '000.000.000-00', 'aluno@teste.com', '2000-01-01', 'senha123', '1');

INSERT INTO produtos (nome, descricao, estoque, preco, ativo) VALUES
('Produto A', 'Descrição do produto A', 10.000, 19.90, '1');

INSERT INTO vendas (cliente_id, total, ativo) VALUES
(1, 19.90, '1');

INSERT INTO venda_itens (venda_id, produto_id, quantidade, preco_unitario, ativo) VALUES
(1, 1, 1.000, 19.90, '1');
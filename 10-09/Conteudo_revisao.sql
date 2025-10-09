-- Apaga o BD para garantir que a estrutura será a de versão final
DROP DATABASE IF EXISTS loja_revisao;

CREATE DATABASE IF NOT EXISTS loja_revisao CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- EXTREMAMENTE IMPORTANTE! Tem que avisar qual BD vai utilizar daqui em diante no SQL
USE loja_revisao;

-- Tabela clientes
-- Só para de dar erro depois de finalizar o script com pelo menos 1 campo
CREATE TABLE IF NOT EXISTS clientes(
	id_cliente BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL UNIQUE,
    -- Além de obrigatório o E-mail DEVE SER ÚNICO
	email VARCHAR(255) NOT NULL UNIQUE,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(30),
    
    -- Demais campos do cliente...
    -- _____________________________________________
    -- Registros de LOG    
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    -- Somente o MySql possui o ON UPDATE
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- EM campos de DATA/HORA é importante confirmar que ele aceita NULL
    deletado_em DATETIME NULL
    -- _____________________________________________
    );
    
    CREATE TABLE IF NOT EXISTS produtos (
    id_produto BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    descricao TEXT,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    estoque DECIMAL(10, 3) DEFAULT CURRENT_TIMESTAMP,
    codigo_barras VARCHAR(50) unique,
    
    -- _____________________________________________
    -- Registros de LOG    
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    -- Somente o MySql possui o ON UPDATE
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- EM campos de DATA/HORA é importante confirmar que ele aceita NULL
    deletado_em DATETIME NULL
    -- _____________________________________________
    );
    
    CREATE TABLE IF NOT EXISTS vendas(
    id_venda BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    cliente_id BIGINT UNSIGNED NOT NULL,
    data_venda DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    forma_pagamento ENUM('dinheiro', 'crédito', 'débito', 'pix'),
    observacoes TEXT,
    desconto_total DECIMAL(10,2) NOT NULL,
    total_venda DECIMAL(10,2) NOT NULL,
    
    -- _____________________________________________
    -- Registros de LOG    
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    -- Somente o MySql possui o ON UPDATE
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- EM campos de DATA/HORA é importante confirmar que ele aceita NULL
    deletado_em DATETIME NULL,
    -- _____________________________________________
    FOREIGN KEY (cliente_id) REFERENCES clientes(id_cliente),
    CONSTRAINT fk_vendas_clientes FOREIGN KEY (cliente_id) REFERENCES clientes(id_cliente)
    );
    
    
    CREATE TABLE IF NOT EXISTS vendas_produtos(
    id_venda_produto BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    venda_id BIGINT UNSIGNED NOT NULL,
    produto_id BIGINT UNSIGNED NOT NULL,
    quantidade DECIMAL(10,3) NOT NULL,
    desconto DECIMAL(10,2) DEFAULT 0,
    
    -- _____________________________________________
    -- Registros de LOG    
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    -- Somente o MySql possui o ON UPDATE
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- EM campos de DATA/HORA é importante confirmar que ele aceita NULL
    deletado_em DATETIME NULL
    -- _____________________________________________
	);
    
    -- Modificações estruturais
    -- Altere o nome da tabela clientes para usuarios.
    ALTER TABLE clientes RENAME TO usuarios;
    
    -- Atualiza o nome de campo da chave primaria da tabela clientes para refletir o novo nome
    ALTER TABLE usuarios CHANGE COLUMN id_cliente id_usuario BIGINT UNSIGNED NOT NULL AUTO_INCREMENT;
    
    DESCRIBE loja_revisao.usuarios;
    
    -- Primeiro remove a chave estrangeira
    ALTER TABLE vendas DROP FOREIGN KEY fk_vendas_clientes;
    
    -- Altera a coluna
    ALTER TABLE vendas CHANGE COLUMN cliente_id usuario_id BIGINT UNSIGNED NOT NULL;
    
    -- Adicionando novamente o relacionamento
    ALTER TABLE vendas
    ADD CONSTRAINT FK_VENDAS_USUARIOS
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuario);
    
    -- Adição e modificação de campos
    -- Adiciona um campo chamado ativo em cada tabela, inicialmente do tipo TINYINT
    ALTER TABLE vendas ADD COLUMN ativo TINYINT NOT NULL DEFAULT 1;
    -- Adicionar os demais campos nas tabelas.
    
    -- Altera o tipo de campo ativo para CHAR(1) em todas as tabelas
    ALTER TABLE vendas MODIFY COLUMN ativo CHAR(1) NOT NULL DEFAULT 's';
    -- Alterar os demais campos na tabela
    
    
    -- Gerenciamento de acesso
    -- Cria um usuario no SGBD com o seu nome próprio
    CREATE USER IF NOT EXISTS 'diego'@'%' IDENTIFIED BY 'Senha_Super_Segura';
    -- Conceda a esse usuário permissões de CRUD(Create, Read, Update, Delete
    GRANT SELECT, INSERT, UPDATE, DELETE ON loja_revisao.*To 'diego'@'%';
    
    -- Aplica os privilégios
    FLUSH PRIVILEGES
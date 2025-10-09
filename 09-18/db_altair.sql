SHOW DATABASES;

-- Cria um banco de dados

-- CREATE DATABASE IF NOT EXISTS altair;

-- Deleta  um banco de dados

-- DROP DATABASE IF EXISTS dieguinho;

-- Cria um banco de dados completo!

CREATE DATABASE IF NOT EXISTS aula_180925 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Mostra o script de criação do banco completo, com o charset
	
SHOW CREATE DATABASE aula_180925;

-- Mostra um banco de dados para ser utilizad até que a conexão finalize
USE aula_180925;

-- Cria uma tabela que impede erro
CREATE TABLE IF NOT EXISTS usuarios(
	id_usuario BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) UNIQUE,
    email VARCHAR(255) UNIQUE,
    date_nascimento DATE,
    admin BOOLEAN DEFAULT FALSE,
    salario DECIMAL (10,2),
    cargo ENUM('Vendedor', 'Supervisor', 'Gerente'),
    senha VARCHAR(255) NOT NULL,
    -- CAMPOS PARA LOG / AUDITORIA
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deletado_em DATETIME NULL
);

-- Descreve a tabela mostrando seus dados de criação

DESCRIBE usuarios;
 
-- Adicionando a coluna gênero

ALTER TABLE usuarios

-- ENUM é por padrão NOT NULL e não aceita vazio

-- 							0			 1			 2			3

	ADD COLUMN genero ENUM('Masculino', 'Feminino', 'Outros', 'Prefiro não declarar') 

    AFTER date_nascimento;
 
ALTER TABLE usuarios

	DROP COLUMN genero;
 
-- SET - Não utilizamos porque ela é OUTRA TABELA N:M
-- SET permite NULL e a seleção de várias opções.

-- Troca o tipo do campo na tabela

ALTER TABLE  usuarios
	MODIFY COLUMN genero CHAR(1);
    
-- Trocar o nome de uma coluna
ALTER TABLE usuarios
    CHANGE COLUMN nome nome_completo VARCHAR(255) NOT NULL;
    
CREATE TABLE IF NOT EXISTS produtos(
	id_produto BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    quantidade DECIMAL(6,3) NOT NULL,
    validade DECIMAL(10,2) NOT NULL,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deletado_em DATETIME NULL
);

CREATE TABLE categorias(
	id_categoria BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255),
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deletado_em DATETIME NULL
);

CREATE TABLE IF NOT EXISTS produtos_categorias(

-- Dois registros iguais podem conter aqui

	produto_id BIGINT UNSIGNED NOT NULL,
	categoria_id BIGINT UNSIGNED NOT NULL,
    -- CAMPOS PARA LOGS
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deletado_em DATETIME NULL,
    
    -- cria chave primária composta
    PRIMARY KEY (produto_id, categoria_id),
	FOREIGN KEY (produto_id) REFERENCES produtos (id_produto)
);

-- Adicionar um relacionamento depois da tabela criada.
-- Informar o nome de BD no scripot e uma boa prátoca, mas pouco usada para comandos simples.

ALTER TABLE aula_180925.produtos_categorias
	-- Ao fazer ALTER TABLE é obrigatório informar o nome de Relacionamento
    ADD CONSTRAINT fk_produtos_categorias_categorias
    FOREIGN KEY (categoria_id) REFERENCES categorias (id_categoria);
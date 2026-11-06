show databases;

-- DDL: CRIAÇÃO DO ESQUEMA DO BANCO DE DADOS 

CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    Pnome VARCHAR(15) NOT NULL,
    NomeMeio VARCHAR(3),
    Sobrenome VARCHAR(20),
    endereco VARCHAR(255),
    data_nascimento DATE,
    tipo_cliente ENUM('PF', 'PJ') NOT NULL
);

CREATE TABLE Cliente_PF (
    idCliente INT PRIMARY KEY,
    CPF CHAR(11) NOT NULL UNIQUE,
    CONSTRAINT fk_pf_cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente) ON DELETE CASCADE
);

CREATE TABLE Cliente_PJ (
    idCliente INT PRIMARY KEY,
    CNPJ CHAR(14) NOT NULL UNIQUE,
    Razao_Social VARCHAR(45) NOT NULL,
    CONSTRAINT fk_pj_cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente) ON DELETE CASCADE
);

CREATE TABLE Forma_Pagamento (
    idPagamento INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT,
    tipo_pagamento ENUM('Cartao', 'Boleto', 'PIX', 'Transferencia') NOT NULL,
    detalhes VARCHAR(255),
    CONSTRAINT fk_pagamento_cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente) ON DELETE CASCADE
);

CREATE TABLE Produto (
    idProduto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL,
    categoria VARCHAR(45),
    valor FLOAT NOT NULL
);

CREATE TABLE Pedido (
    idPedido INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT,
    status_pedido ENUM('Processando', 'Confirmado', 'Enviado', 'Entregue') DEFAULT 'Processando',
    descricao VARCHAR(255),
    frete FLOAT DEFAULT 0,
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

CREATE TABLE Entrega (
    idEntrega INT AUTO_INCREMENT PRIMARY KEY,
    idPedido INT,
    status_entrega ENUM('Preparando', 'Em trânsito', 'Entregue') DEFAULT 'Preparando',
    codigo_rastreio VARCHAR(45) UNIQUE,
    CONSTRAINT fk_entrega_pedido FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido) ON DELETE CASCADE
);

CREATE TABLE Fornecedor (
    idFornecedor INT AUTO_INCREMENT PRIMARY KEY,
    razao_social VARCHAR(45) NOT NULL,
    CNPJ CHAR(14) NOT NULL UNIQUE
);

CREATE TABLE Terceiro_Vendedor (
    idVendedor INT AUTO_INCREMENT PRIMARY KEY,
    razao_social VARCHAR(45) NOT NULL,
    local VARCHAR(45),
    CNPJ CHAR(14) UNIQUE,
    CPF CHAR(11) UNIQUE
);

CREATE TABLE Estoque (
    idEstoque INT AUTO_INCREMENT PRIMARY KEY,
    local VARCHAR(45) NOT NULL
);

CREATE TABLE Produto_Estoque (
    idProduto INT,
    idEstoque INT,
    quantidade INT DEFAULT 0,
    PRIMARY KEY (idProduto, idEstoque),
    CONSTRAINT fk_pe_produto FOREIGN KEY (idProduto) REFERENCES Produto(idProduto),
    CONSTRAINT fk_pe_estoque FOREIGN KEY (idEstoque) REFERENCES Estoque(idEstoque)
);

CREATE TABLE Produto_Fornecedor (
    idProduto INT,
    idFornecedor INT,
    quantidade INT DEFAULT 1,
    PRIMARY KEY (idProduto, idFornecedor),
    CONSTRAINT fk_pf_produto FOREIGN KEY (idProduto) REFERENCES Produto(idProduto),
    CONSTRAINT fk_pf_fornecedor FOREIGN KEY (idFornecedor) REFERENCES Fornecedor(idFornecedor)
);

CREATE TABLE Produto_Vendedor (
    idProduto INT,
    idVendedor INT,
    quantidade INT DEFAULT 1,
    PRIMARY KEY (idProduto, idVendedor),
    CONSTRAINT fk_pv_produto FOREIGN KEY (idProduto) REFERENCES Produto(idProduto),
    CONSTRAINT fk_pv_vendedor FOREIGN KEY (idVendedor) REFERENCES Terceiro_Vendedor(idVendedor)
);

CREATE TABLE Item_Pedido (
    idProduto INT,
    idPedido INT,
    quantidade INT DEFAULT 1,
    status ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
    PRIMARY KEY (idProduto, idPedido),
    CONSTRAINT fk_ip_produto FOREIGN KEY (idProduto) REFERENCES Produto(idProduto),
    CONSTRAINT fk_ip_pedido FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido)
);

-- DML: INSERÇÃO DE DADOS PARA TESTES

INSERT INTO Cliente (Pnome, Sobrenome, endereco, tipo_cliente) VALUES 
('João', 'Silva', 'Rua A, 123 - SP', 'PF'),
('Empresa', 'Tech', 'Av B, 456 - RJ', 'PJ'),
('Maria', 'Souza', 'Rua C, 789 - MG', 'PF');

INSERT INTO Cliente_PF (idCliente, CPF) VALUES (1, '12345678901'), (3, '98765432100');
INSERT INTO Cliente_PJ (idCliente, CNPJ, Razao_Social) VALUES (2, '12345678000199', 'Tech Solutions Ltda');

INSERT INTO Forma_Pagamento (idCliente, tipo_pagamento, detalhes) VALUES 
(1, 'Cartao', 'Final 4567'), (1, 'PIX', 'Chave CPF'), (2, 'Boleto', 'Vencimento dia 10');

INSERT INTO Produto (nome, categoria, valor) VALUES 
('Notebook', 'Eletrônicos', 3500.00), ('Mouse', 'Eletrônicos', 150.00), ('Mesa', 'Móveis', 800.00);

INSERT INTO Pedido (idCliente, status_pedido, frete) VALUES (1, 'Confirmado', 50.00), (1, 'Entregue', 20.00), (2, 'Processando', 100.00);
INSERT INTO Item_Pedido (idProduto, idPedido, quantidade) VALUES (1, 1, 1), (2, 1, 2), (2, 2, 1), (3, 3, 4);
INSERT INTO Entrega (idPedido, status_entrega, codigo_rastreio) VALUES (1, 'Em trânsito', 'BR123456789'), (2, 'Entregue', 'BR987654321');

INSERT INTO Fornecedor (razao_social, CNPJ) VALUES ('ForneceTudo SA', '99888777000166'), ('TechDistribuidora', '55444333000122');
INSERT INTO Terceiro_Vendedor (razao_social, local, CNPJ) VALUES ('VendeTudo ME', 'SP', '11222333000144'), ('ForneceTudo SA', 'RJ', '99888777000166');

INSERT INTO Estoque (local) VALUES ('Depósito SP'), ('Depósito RJ');
INSERT INTO Produto_Estoque (idProduto, idEstoque, quantidade) VALUES (1, 1, 50), (2, 1, 200), (3, 2, 30);
INSERT INTO Produto_Fornecedor (idProduto, idFornecedor, quantidade) VALUES (1, 2, 100), (2, 1, 500);

-- DQL: CONSULTAS SQL (QUERIES DE DESAFIO)

SELECT concat(c.Pnome,' ', c.Sobrenome) as nome_cliente, COUNT(p.idPedido) AS numero_de_pedidos
FROM Cliente c
LEFT JOIN Pedido p ON c.idCliente = p.idCliente
GROUP BY c.idCliente
ORDER BY numero_de_pedidos DESC;

SELECT v.razao_social AS Nome_Empresa, v.CNPJ 
FROM Terceiro_Vendedor v
INNER JOIN Fornecedor f ON v.CNPJ = f.CNPJ;

SELECT f.razao_social AS Fornecedor, p.nome AS Produto, pf.quantidade
FROM Fornecedor f
INNER JOIN Produto_Fornecedor pf ON f.idFornecedor = pf.idFornecedor
INNER JOIN Produto p ON pf.idProduto = p.idProduto;

SELECT p.nome AS Produto, e.local AS Local_Estoque, pe.quantidade AS Qtd_Disponivel
FROM Produto p
INNER JOIN Produto_Estoque pe ON p.idProduto = pe.idProduto
INNER JOIN Estoque e ON pe.idEstoque = e.idEstoque
WHERE pe.quantidade > 50;

SELECT 
    p.idPedido, 
    c.Pnome AS Cliente, 
    SUM(ip.quantidade * prod.valor) AS Valor_Produtos, 
    p.frete AS Valor_Frete,
    (SUM(ip.quantidade * prod.valor) + p.frete) AS Valor_Total_Pedido
FROM Pedido p
INNER JOIN Cliente c ON p.idCliente = c.idCliente
INNER JOIN Item_Pedido ip ON p.idPedido = ip.idPedido
INNER JOIN Produto prod ON ip.idProduto = prod.idProduto
GROUP BY p.idPedido
HAVING Valor_Total_Pedido > 500
ORDER BY Valor_Total_Pedido DESC;

SELECT c.Pnome, ped.idPedido, ent.codigo_rastreio, ent.status_entrega
FROM Cliente c
INNER JOIN Pedido ped ON c.idCliente = ped.idCliente
INNER JOIN Entrega ent ON ped.idPedido = ent.idPedido
WHERE c.tipo_cliente = 'PF';
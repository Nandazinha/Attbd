DROP DATABASE biblioteca;

CREATE DATABASE biblioteca;

USE biblioteca;

CREATE TABLE usuario (
    cpf VARCHAR(11) NOT NULL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    telefone VARCHAR(15) NOT NULL
);

CREATE TABLE categoria(
    codigo_categoria INT NOT NULL PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL
);

CREATE TABLE livro(
    codigo_livro INT NOT NULL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    preco DECIMAL(10,2),
    codigo_categorico INT NOT NULL,
    autor VARCHAR(100) NOT NULL,
    FOREIGN KEY (codigo_categorico) REFERENCES categoria(codigo_categoria)
);

CREATE TABLE funcionario(
    cpf VARCHAR(11) NOT NULL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(100) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    funcao VARCHAR(50) NOT NULL
);

CREATE TABLE emprestimo(
    codigo_emprestimo INT NOT NULL PRIMARY KEY,
    cpf_usuario VARCHAR(11) NOT NULL,
    cpf_funcionario VARCHAR(11) NOT NULL,
    codigo_livro INT NOT NULL,
    data_emprestimo DATE NOT NULL,
    data_devo_prevista DATE NOT NULL,
    data_devolucao DATE,
    FOREIGN KEY (cpf_usuario) REFERENCES usuario(cpf),
    FOREIGN KEY (cpf_funcionario) REFERENCES funcionario(cpf),
    FOREIGN KEY (codigo_livro) REFERENCES livro(codigo_livro)
);

INSERT INTO usuario (cpf, nome, endereco, telefone) VALUES
('12345678901', 'Ana Silva', 'Rua das Flores, 123', '11999999999'),
('23456789012', 'Bruno Souza', 'Av. Brasil, 456', '21988888888'),
('34567890123', 'Carla Pereira', 'Praça Central, 789', '31977777777');

INSERT INTO categoria (codigo_categoria, descricao) VALUES
(1, 'Romance'),
(2, 'Ficção Científica'),
(3, 'Biografia');

INSERT INTO livro (codigo_livro, titulo, codigo_categorico, autor, preco) VALUES
(101, 'O Amor nos Tempos do Cólera', 1, 'Gabriel García Márquez', 39.90),
(102, 'Duna', 2, 'Frank Herbert', 49.90),
(103, 'Steve Jobs', 3, 'Walter Isaacson', 59.90);

INSERT INTO funcionario (cpf, nome, endereco, telefone, funcao) VALUES
('45678901234', 'Daniel Lima', 'Rua Verde, 321', '41966666666', 'Bibliotecário'),
('56789012345', 'Elisa Ramos', 'Av. Azul, 654', '51955555555', 'Atendente'),
('67890123456', 'Felipe Costa', 'Rua Amarela, 987', '61944444444', 'Gerente');

INSERT INTO emprestimo (codigo_emprestimo, cpf_usuario, cpf_funcionario, codigo_livro, data_emprestimo, data_devo_prevista, data_devolucao) VALUES
(1, '12345678901', '45678901234', 101, '2024-06-01', '2024-06-15', '2024-06-10'),
(2, '23456789012', '56789012345', 102, '2024-06-05', '2024-06-19', NULL),
(3, '34567890123', '67890123456', 103, '2024-06-07', '2024-06-21', '2024-06-20');


/* ----------------------------------
   Tabelas extras para atendimentos
---------------------------------- */

CREATE TABLE especialidade (
    id_especialidade INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nome_especialidade VARCHAR(100) NOT NULL
);

CREATE TABLE medico (
    id_medico INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nome_medico VARCHAR(100) NOT NULL,
    id_especialidade INT NOT NULL,
    FOREIGN KEY (id_especialidade) REFERENCES especialidade(id_especialidade)
);

CREATE TABLE paciente (
    id_paciente INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nome_paciente VARCHAR(100) NOT NULL
);

CREATE TABLE atendimento (
    id_atendimento INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_medico INT NOT NULL,
    id_paciente INT NOT NULL,
    data_atendimento DATETIME NOT NULL,
    FOREIGN KEY (id_medico) REFERENCES medico(id_medico),
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente)
);

-- Inserindo exemplos de dados
INSERT INTO especialidade (nome_especialidade) VALUES
('Cardiologia'),
('Pediatria'),
('Dermatologia');

INSERT INTO medico (nome_medico, id_especialidade) VALUES
('Dr. João Cardoso', 1),
('Dra. Marina Alves', 2),
('Dr. Paulo Lima', 3);

INSERT INTO paciente (nome_paciente) VALUES
('Lucas Santos'),
('Fernanda Oliveira'),
('Pedro Costa');

INSERT INTO atendimento (id_medico, id_paciente, data_atendimento) VALUES
(1, 1, '2024-07-01 10:00:00'),
(1, 2, '2024-07-03 14:00:00'),
(2, 3, '2024-07-05 09:30:00'),
(3, 1, '2024-07-06 11:00:00');


/* ----------------------------------
   Procedures originais + nova
---------------------------------- */

CREATE TABLE IF NOT EXISTS fornecedor (
    codigo_fornecedor INT NOT NULL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    contato VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS compra (
    codigo_compra INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    codigo_fornecedor INT NOT NULL,
    cpf_funcionario VARCHAR(11) NOT NULL,
    data_compra DATE NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (codigo_fornecedor) REFERENCES fornecedor(codigo_fornecedor),
    FOREIGN KEY (cpf_funcionario) REFERENCES funcionario(cpf)
);

INSERT INTO fornecedor (codigo_fornecedor, nome, contato) VALUES
(1, 'Editora Exemplo', 'contato@editoraexemplo.com'),
(2, 'Distribuidora Livros LTDA', 'vendas@distriblivros.com');

INSERT INTO compra (codigo_fornecedor, cpf_funcionario, data_compra, valor_total) VALUES
(1, '67890123456', '2024-05-10', 1200.00),
(1, '45678901234', '2024-06-12', 850.50),
(2, '56789012345', '2024-04-22', 430.75);

DELIMITER //

CREATE PROCEDURE Proc_UsuariosComEmprestimosAtrasados()
BEGIN
    SELECT DISTINCT
        u.cpf,
        u.nome,
        u.endereco,
        u.telefone,
        e.codigo_emprestimo,
        e.codigo_livro,
        e.data_emprestimo,
        e.data_devo_prevista
    FROM usuario u
    JOIN emprestimo e ON e.cpf_usuario = u.cpf
    WHERE e.data_devolucao IS NULL
      AND e.data_devo_prevista < CURDATE()
    ORDER BY e.data_devo_prevista;
END //

CREATE PROCEDURE Proc_ComprasPorFornecedor(IN p_codigo_fornecedor INT)
BEGIN
    SELECT
        c.codigo_compra,
        c.data_compra,
        c.valor_total,
        f.codigo_fornecedor,
        f.nome AS fornecedor_nome,
        f.contato AS fornecedor_contato,
        func.cpf AS funcionario_cpf,
        func.nome AS funcionario_nome,
        func.funcao AS funcionario_funcao
    FROM compra c
    JOIN fornecedor f ON c.codigo_fornecedor = f.codigo_fornecedor
    JOIN funcionario func ON c.cpf_funcionario = func.cpf
    WHERE f.codigo_fornecedor = p_codigo_fornecedor
    ORDER BY c.data_compra DESC;
END //

/* NOVA PROCEDURE SOLICITADA */
CREATE PROCEDURE Proc_AtendimentosPorEspecialidade(IN p_especialidade VARCHAR(100))
BEGIN
    SELECT
        esp.nome_especialidade AS Especialidade,
        med.nome_medico AS Medico,
        pac.nome_paciente AS Paciente,
        ate.data_atendimento AS Data_Atendimento
    FROM atendimento ate
    JOIN medico med ON ate.id_medico = med.id_medico
    JOIN paciente pac ON ate.id_paciente = pac.id_paciente
    JOIN especialidade esp ON med.id_especialidade = esp.id_especialidade
    WHERE esp.nome_especialidade = p_especialidade
    ORDER BY ate.data_atendimento;
END //

DELIMITER ;

CALL Proc_AtendimentosPorEspecialidade('Cardiologia');
-- CALL Proc_UsuariosComEmprestimosAtrasados();


/* ----------------------------------
   Atividade 04 – Sistema de Vendas Online
---------------------------------- */

/*
    Estrutura de Tabelas para o Sistema de Vendas Online
    - Cliente (id_cliente, nome, cpf, endereco, telefone)
    - Vendedor (id_vendedor, nome, cpf, telefone)
    - Produto (id_produto, nome_produto, preco, id_categoria)
    - Categoria_Produto (id_categoria, nome_categoria)
    - Pedido (id_pedido, id_cliente, id_vendedor, data_pedido, valor_total)
    - Item_Pedido (id_item, id_pedido, id_produto, quantidade, preco_unitario)
*/

-- Criação das Tabelas
CREATE TABLE IF NOT EXISTS Categoria_Produto (
    id_categoria INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nome_categoria VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Produto (
    id_produto INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nome_produto VARCHAR(150) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    id_categoria INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES Categoria_Produto(id_categoria)
);

CREATE TABLE IF NOT EXISTS Cliente (
    id_cliente INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    endereco VARCHAR(255),
    telefone VARCHAR(15)
);

CREATE TABLE IF NOT EXISTS Vendedor (
    id_vendedor INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    telefone VARCHAR(15)
);

CREATE TABLE IF NOT EXISTS Pedido (
    id_pedido INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_vendedor INT NOT NULL,
    data_pedido DATE NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor)
);

CREATE TABLE IF NOT EXISTS Item_Pedido (
    id_item INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

-- Inserção de Dados de Exemplo
INSERT INTO Categoria_Produto (nome_categoria) VALUES
('Eletrônicos'),
('Livros'),
('Vestuário');

INSERT INTO Produto (nome_produto, preco, id_categoria) VALUES
('Smartphone X', 1500.00, 1),
('Notebook Y', 3500.00, 1),
('A Revolução dos Bichos', 35.00, 2),
('Camiseta Básica', 50.00, 3),
('Calça Jeans', 120.00, 3);

INSERT INTO Cliente (nome, cpf, endereco, telefone) VALUES
('Mariana Costa', '11122233344', 'Rua A, 10', '991112233'),
('Roberto Silva', '55566677788', 'Av. B, 20', '994445566');

INSERT INTO Vendedor (nome, cpf, telefone) VALUES
('João Vendas', '99988877766', '987776655'),
('Maria Atendimento', '44433322211', '981110099');

INSERT INTO Pedido (id_cliente, id_vendedor, data_pedido, valor_total) VALUES
(1, 1, '2024-09-01', 1550.00), -- Smartphone X (1500) + Camiseta (50)
(2, 2, '2024-09-05', 3535.00), -- Notebook Y (3500) + Livro (35)
(1, 1, '2024-10-10', 170.00); -- Camiseta (50) + Calça Jeans (120)

INSERT INTO Item_Pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 1500.00),
(1, 4, 1, 50.00),
(2, 2, 1, 3500.00),
(2, 3, 1, 35.00),
(3, 4, 1, 50.00),
(3, 5, 1, 120.00);

DELIMITER //

/*
    Relatorio_Pedidos_Por_Periodo
    Objetivo: Retornar todos os pedidos feitos dentro de um intervalo de datas, com informações do cliente e do vendedor, para gerar relatórios de vendas por período.
*/
CREATE PROCEDURE Relatorio_Pedidos_Por_Periodo(
    IN data_inicio DATE,
    IN data_fim DATE
)
BEGIN
    SELECT
        p.id_pedido,
        p.data_pedido,
        p.valor_total,
        c.nome AS nome_cliente,
        c.cpf AS cpf_cliente,
        v.nome AS nome_vendedor,
        v.cpf AS cpf_vendedor
    FROM Pedido p
    JOIN Cliente c ON p.id_cliente = c.id_cliente
    JOIN Vendedor v ON p.id_vendedor = v.id_vendedor
    WHERE p.data_pedido BETWEEN data_inicio AND data_fim
    ORDER BY p.data_pedido;
END //

/*
    Relatorio_Produtos_Por_Categoria
    Objetivo: Listar os produtos de uma determinada categoria com seu preço e o nome da categoria.
*/
CREATE PROCEDURE Relatorio_Produtos_Por_Categoria(
    IN nome_cat VARCHAR(100)
)
BEGIN
    SELECT
        prod.nome_produto,
        prod.preco,
        cat.nome_categoria
    FROM Produto prod
    JOIN Categoria_Produto cat ON prod.id_categoria = cat.id_categoria
    WHERE cat.nome_categoria = nome_cat
    ORDER BY prod.nome_produto;
END //

/*
    Relatorio_Equipe_Projeto
    Objetivo: Retornar resumo de um pedido específico: vendedor, cliente, data e valor total — útil para visualizar detalhes de responsabilidade e valor do pedido.
*/
CREATE PROCEDURE Relatorio_Resumo_Pedido(
    IN id_ped INT
)
BEGIN
    SELECT
        p.id_pedido,
        p.data_pedido,
        p.valor_total,
        c.nome AS nome_cliente,
        v.nome AS nome_vendedor
    FROM Pedido p
    JOIN Cliente c ON p.id_cliente = c.id_cliente
    JOIN Vendedor v ON p.id_vendedor = v.id_vendedor
    WHERE p.id_pedido = id_ped;
END //

DELIMITER ;

-- Exemplos de Chamada para a Atividade 04
-- CALL Relatorio_Pedidos_Por_Periodo('2024-09-01', '2024-09-30');
-- CALL Relatorio_Produtos_Por_Categoria('Eletrônicos');
-- CALL Relatorio_Resumo_Pedido(2);
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
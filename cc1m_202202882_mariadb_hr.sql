CREATE USER 'raquel'@localhost identified by '202202882';

CREATE DATABASE uvv
                CHARACTER SET UTF8
                COLLATE UTF8_general_ci;
                
GRANT ALL ON uvv.* TO 'raquel'@localhost;

USE uvv;

CREATE TABLE cargos (
                id_cargo VARCHAR(10) NOT NULL,
                cargo VARCHAR(35) NOT NULL,
                salario_minimo DECIMAL(8,2),
                salario_maximo DECIMAL(8,2),
                PRIMARY KEY (id_cargo)
);

ALTER TABLE cargos MODIFY COLUMN cargo VARCHAR(35) COMMENT 'Nome do cargo de cada funcionário.';

ALTER TABLE cargos MODIFY COLUMN salario_minimo DECIMAL(8, 2) COMMENT 'Salário mínimo admitido ao funcionário de determinado cargo.';

ALTER TABLE cargos MODIFY COLUMN salario_maximo DECIMAL(8, 2) COMMENT 'Maior salário admitido a determinado funcionário.';


CREATE TABLE paises (
                id_pais CHAR(2) NOT NULL,
                nome VARCHAR(50) NOT NULL,
                PRIMARY KEY (id_pais)
);

ALTER TABLE paises COMMENT 'Tabela que informa nome, código de países. Essa tabela contém uma chave primária (id_pais_pk), uma chave estrangeira (id_pais_fk) e nome dos paises.';


CREATE TABLE regioes (
                id_regiao INT NOT NULL,
                nome VARCHAR(25) NOT NULL,
                id_pais CHAR(2) NOT NULL,
                PRIMARY KEY (id_regiao)
);

ALTER TABLE regioes COMMENT 'Tabela do tipo 1:N.
Contém o código de indentificação e nome de cada região cadastrada.';

ALTER TABLE regioes MODIFY COLUMN nome VARCHAR(25) COMMENT 'O nome das regiões estarão armazenadas nessa coluna.';


CREATE UNIQUE INDEX regioes_idx
 ON regioes
 ( nome );

CREATE TABLE localizacoes (
                id_localizacoes INT NOT NULL,
                endereco VARCHAR(50),
                cep VARCHAR(12),
                cidade VARCHAR(50),
                uf VARCHAR(25),
                id_regiao INT,
                id_pais CHAR(2) NOT NULL,
                PRIMARY KEY (id_localizacoes)
);

ALTER TABLE localizacoes COMMENT 'Tabela de localizações, contém os endereços de diversos escritórios e facilidades da empresa. Não armazena endereços de clientes.';

ALTER TABLE localizacoes MODIFY COLUMN uf VARCHAR(25) COMMENT 'ritório ou outra facilidade da empresa.';

ALTER TABLE localizacoes MODIFY COLUMN id_regiao INTEGER COMMENT 'Chave estrangeira referente a tabela regioes.';


CREATE TABLE departamentos (
                id_departamento INT NOT NULL,
                nome VARCHAR(10),
                id_localizacoes INT NOT NULL,
                PRIMARY KEY (id_departamento)
);

ALTER TABLE departamentos COMMENT 'Esta tabela reserva informações de identificação (id_departamento, nome, id_localização, id_gerente) dos departamentos da empresa.';

ALTER TABLE departamentos MODIFY COLUMN nome VARCHAR(10) COMMENT 'Propriedade contendo o nome do departamento da tabela.';

ALTER TABLE departamentos MODIFY COLUMN id_localizacoes INTEGER COMMENT 'Chave estrangeira para a tabela departamentos.';


CREATE TABLE empregados (
                id_empregado INT NOT NULL,
                nome VARCHAR(75) NOT NULL,
                email VARCHAR(35) NOT NULL,
                telefone VARCHAR(20),
                cpf CHAR(11) NOT NULL,
                data_contratacao DATE NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                salario DECIMAL(8,2),
                comissao DECIMAL(4,2),
                id_departamento INT,
                id_supervisor INT,
                PRIMARY KEY (id_empregado)
);

ALTER TABLE empregados COMMENT 'Tabela que armazena informações dos funcionários da empresa.';

ALTER TABLE empregados MODIFY COLUMN nome VARCHAR(75) COMMENT 'Nome completo do funcionário.';

ALTER TABLE empregados MODIFY COLUMN email VARCHAR(35) COMMENT 'ior ao @).';

ALTER TABLE empregados MODIFY COLUMN telefone VARCHAR(20) COMMENT 'stado.';

ALTER TABLE empregados MODIFY COLUMN cpf CHAR(11) COMMENT 'Cadastro de pessoa física do funcionário.';

ALTER TABLE empregados MODIFY COLUMN salario DECIMAL(8, 2) COMMENT 'Valor do salário mensal do funcionário.';


CREATE INDEX empregados_idx
 ON empregados
 ( id_supervisor );

CREATE UNIQUE INDEX empregados_idx1
 ON empregados
 ( email );

CREATE TABLE gerentes (
                id_empregado INT NOT NULL,
                id_departamento INT NOT NULL,
                PRIMARY KEY (id_empregado)
);

ALTER TABLE gerentes COMMENT 'Tabela de gerente com chave primária estrangeira para a tabela funcionarios.';

ALTER TABLE gerentes MODIFY COLUMN id_departamento INTEGER COMMENT 'Departamento designado ao gerente.';


CREATE TABLE historico_cargos (
                id_empregado INT NOT NULL,
                data_inicial DATE NOT NULL,
                data_final DATE NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                id_departamento INT NOT NULL,
                PRIMARY KEY (id_empregado, data_inicial)
);

ALTER TABLE historico_cargos COMMENT 'Essa tabela armazena o histórico de cargos do funcionário. Novas linhas serão adicionadas caso houver mudança de departamento dentro de um cargo ou vice-versa.';

ALTER TABLE historico_cargos MODIFY COLUMN id_empregado INTEGER COMMENT 'Referenciada na tabela histórico_cargo.';

ALTER TABLE historico_cargos MODIFY COLUMN id_cargo VARCHAR(10) COMMENT 'Chave estrangeira (tabela cargos).';


ALTER TABLE empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargo)
REFERENCES cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE historico_cargos ADD CONSTRAINT cargos_historico_cargos_fk
FOREIGN KEY (id_cargo)
REFERENCES cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE localizacoes ADD CONSTRAINT paises_localizacoes_fk
FOREIGN KEY (id_pais)
REFERENCES paises (id_pais)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE regioes ADD CONSTRAINT regioes_paises_fk
FOREIGN KEY (id_pais)
REFERENCES paises (id_pais)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE localizacoes ADD CONSTRAINT regioes_localizacoes_fk
FOREIGN KEY (id_regiao)
REFERENCES regioes (id_regiao)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE departamentos ADD CONSTRAINT localizacoes_departamentos_fk
FOREIGN KEY (id_localizacoes)
REFERENCES localizacoes (id_localizacoes)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE empregados ADD CONSTRAINT departamentos_empregados_fk
FOREIGN KEY (id_departamento)
REFERENCES departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE historico_cargos ADD CONSTRAINT departamentos_historico_cargos_fk
FOREIGN KEY (id_departamento)
REFERENCES departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE gerentes ADD CONSTRAINT gerentes_departamentos_fk
FOREIGN KEY (id_departamento)
REFERENCES departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE historico_cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY (id_empregado)
REFERENCES empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE gerentes ADD CONSTRAINT empregados_gerentes_fk
FOREIGN KEY (id_empregado)
REFERENCES empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

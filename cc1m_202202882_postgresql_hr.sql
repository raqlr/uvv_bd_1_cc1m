/*Código para criar usuário no postgresql*/

CREATE USER raquel WITH
  SUPERUSER
  CREATEDB
  CREATEROLE
  INHERIT
  REPLICATION
  BYPASSRLS
  ENCRYPTED PASSWORD '202202882'
;

/*Criando banco de dados*/

CREATE DATABASE uvv
  WITH OWNER = raquel
  TEMPLATE = template)
  ENCODING = 'UTF8'
  LC_COLLATE = 'pt_BR.UTF-8'
  LC_CTYPE = 'pt_BR.UTF-8'
  ALLOW_CONNECTIONS = true
;

/*Comando para logar na tabela uvv usando o usuário criado anteriormente*/

\c uvv raquel;

/*Criação do esquema hr e autorizando o usuário criado*/

CREATE SCHEMA IF NOT EXISTS hr AUTHORIZATION raquel;

/*Configurando o search path para hr*/

SET SEARCH_PATH TO hr, raquel, public;

/*Criação de tabelas, index e comentários*/

CREATE TABLE cargos (
                id_cargo VARCHAR(10) NOT NULL,
                cargo VARCHAR(35) NOT NULL,
                salario_minimo NUMERIC(8,2),
                salario_maximo NUMERIC(8,2),
                CONSTRAINT id_cargo_pk PRIMARY KEY (id_cargo)
);

COMMENT ON TABLE cargos IS 'Tabela que armazena informações sobre salário e código dos cargos na empresa.';
COMMENT ON COLUMN cargos.id_cargo IS 'Código de identificação do cargo exercido por determinado empregado. Chave estrangeira para a tabela empregados e historico_cargos.';
COMMENT ON COLUMN cargos.cargo IS 'Nome do cargo de cada funcionário.';
COMMENT ON COLUMN cargos.salario_minimo IS 'Salário mínimo admitido ao funcionário de determinado cargo.';
COMMENT ON COLUMN cargos.salario_maximo IS 'Maior salário admitido a determinado funcionário.';


CREATE TABLE regioes (
                id_regiao INTEGER NOT NULL,
                nome VARCHAR(25) NOT NULL,
                CONSTRAINT id_regiao_pk PRIMARY KEY (id_regiao)
);
COMMENT ON TABLE regioes IS 'Tabela do tipo 1:N. Contém o código de indentificação e nome de cada região cadastrada.';
COMMENT ON COLUMN regioes.id_regiao IS 'Chave primária da tabela regioes, tipo integer (numero não fracionário). Como toda chave primária, essa coluna não pode ser deixada com o valor nulo.';
COMMENT ON COLUMN regioes.nome IS 'O nome das regiões estarão armazenadas nessa coluna.';


CREATE UNIQUE INDEX regioes_idx
 ON regioes
 ( nome );

CREATE TABLE paises (
                id_pais CHAR(2) NOT NULL,
                nome VARCHAR(50) NOT NULL,
                id_regiao INTEGER NOT NULL,
                CONSTRAINT id_paises_pk PRIMARY KEY (id_pais)
);
COMMENT ON TABLE paises IS 'Tabela que informa nome, código de países. Essa tabela contém uma chave primária (id_pais_pk), uma chave estrangeira (id_pais_fk) e nome dos paises.';
COMMENT ON COLUMN paises.id_pais IS 'Chave primária da tabela países. Essa coluna tem a utilidade de armazenar o código de cada país onde há uma filial/escritório da empresa.';
COMMENT ON COLUMN paises.nome IS 'Nome do país onde se encontra filiais, escritórios, ou departamentos da empresa.';
COMMENT ON COLUMN paises.id_regiao IS 'Chave primária da tabela regioes, tipo integer (numero não fracionário). Como toda chave primária, essa coluna não pode ser deixada com o valor nulo.';


CREATE TABLE localizacoes (
                id_localizacoes INTEGER NOT NULL,
                endereco VARCHAR(50),
                cep VARCHAR(12) NOT NULL,
                cidade VARCHAR(50),
                uf VARCHAR(25),
                id_pais CHAR(2) NOT NULL,
                CONSTRAINT id_localizacao_pk PRIMARY KEY (id_localizacoes)
);
COMMENT ON TABLE localizacoes IS 'Tabela de localizações, contém os endereços de diversos escritórios e facilidades da empresa. Não armazena endereços de clientes.';
COMMENT ON COLUMN localizacoes.id_localizacoes IS 'Coluna que contém o código de identificação das localizações inseridas na tabela localizacoes. É uma chave primária e por conta disso, não pode ser nula. Chave estrangeira para a tabela departamentos.';
COMMENT ON COLUMN localizacoes.endereco IS 'Localização por endereço de uma filial, escritório, e/ou departamento da empresa.';
COMMENT ON COLUMN localizacoes.cep IS 'CEP do endereço/localização de um escritório ou facilidade empresarial.';
COMMENT ON COLUMN localizacoes.cidade IS 'Cidade onde está localizado o escritório ou outra filial da empresa.';
COMMENT ON COLUMN localizacoes.uf IS 'Estado (abreviado ou por extenso) onde está localizado o escritório ou outra facilidade da empresa.';
COMMENT ON COLUMN localizacoes.id_pais IS 'Chave estrangeira que referencia a tabela paises. Essa coluna tem a utilidade de armazenar o código de cada país onde há uma filial/escritório da empresa.';


CREATE UNIQUE INDEX localizacoes_idx
 ON localizacoes
 ( cep );

CREATE TABLE departamentos (
                id_departamento INTEGER NOT NULL,
                nome VARCHAR(20),
                id_localizacoes INTEGER NOT NULL,
                CONSTRAINT id_departamento_pk PRIMARY KEY (id_departamento)
);
COMMENT ON TABLE departamentos IS 'Esta tabela reserva informações de identificação (id_departamento, nome, id_localização, id_gerente) dos departamentos da empresa.';
COMMENT ON COLUMN departamentos.id_departamento IS 'Essa propriedade contém uma chave primária, na qual identifica o departamento cadastrado de acordo com o código de identificação.';
COMMENT ON COLUMN departamentos.nome IS 'Propriedade contendo o nome do departamento da tabela.';
COMMENT ON COLUMN departamentos.id_localizacoes IS 'Coluna que contém o código de identificação das localizações inseridas na tabela localizacoes. Chave estrangeira para a tabela departamentos.';


CREATE TABLE empregados (
                id_empregado INTEGER NOT NULL,
                nome VARCHAR(75) NOT NULL,
                email VARCHAR(35) NOT NULL,
                telefone VARCHAR(20),
                data_contratacao DATE NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                salario NUMERIC(8,2) NOT NULL,
                comissao NUMERIC(4,2),
                id_departamento INTEGER NOT NULL,
                id_supervisor INTEGER,
                CONSTRAINT id_empregados_pk PRIMARY KEY (id_empregado)
);
COMMENT ON TABLE empregados IS 'Tabela que armazena informações dos funcionários da empresa.';
COMMENT ON COLUMN empregados.id_empregado IS 'Propriedade com valor único na tabela. A chave primária vai garantir que este valor não seja repetido ou confundido com a identificação de outro funcionário.';
COMMENT ON COLUMN empregados.nome IS 'Nome completo do funcionário.';
COMMENT ON COLUMN empregados.email IS 'endereço de email do funcionário (apenas parte inicial anterior ao @).';
COMMENT ON COLUMN empregados.telefone IS 'Telefone do funcionário com espaço para o código do país e estado.';
COMMENT ON COLUMN empregados.cpf IS 'Cadastro de pessoa física do funcionário.';
COMMENT ON COLUMN empregados.data_contratacao IS 'Data de contratação do funcionário para o cargo atual.';
COMMENT ON COLUMN empregados.id_cargo IS 'Identificação do cargo atual do funcionário. Também é chave estrangeira para a tabela cargos.';
COMMENT ON COLUMN empregados.salario IS 'Valor do salário mensal do funcionário.';
COMMENT ON COLUMN empregados.comissao IS 'Porcentagem de comissão do funcionário no departamento de vendas.';
COMMENT ON COLUMN empregados.id_departamento IS 'Código de identificação do departamento onde o funcionário trabalha.';
COMMENT ON COLUMN empregados.id_supervisor IS 'Chave estrangeira para a tabela empregados (auto-relacionamento). Esta propriedade indica o supervisor direto do funcionário em determinado departamento.';


CREATE UNIQUE INDEX empregados_idx1
 ON empregados
 ( email );

CREATE TABLE gerentes (
                id_gerente INTEGER NOT NULL,
                id_departamento INTEGER NOT NULL,
                CONSTRAINT id_empregados_pk_fk PRIMARY KEY (id_gerente)
);
COMMENT ON TABLE gerentes IS 'Tabela de gerente com chave primária estrangeira para a tabela funcionarios.';
COMMENT ON COLUMN gerentes.id_gerente IS 'Propriedade com valor único na tabela. A chave primária vai garantir que este valor não seja repetido ou confundido com a identificação de outro funcionário.';
COMMENT ON COLUMN gerentes.id_departamento IS 'Essa propriedade contém uma chave primária, na qual identifica o departamento cadastrado de acordo com o código de identificação.';


CREATE TABLE historico_cargos (
                id_empregado INTEGER NOT NULL,
                data_inicial DATE NOT NULL,
                data_final DATE NOT NULL,
                id_cargo VARCHAR NOT NULL,
                id_departamento INTEGER NOT NULL,
                CONSTRAINT data_inicial_pk PRIMARY KEY (id_empregado, data_inicial)
);
COMMENT ON TABLE historico_cargos IS 'Essa tabela armazena o histórico de cargos do funcionário. Novas linhas serão adicionadas caso houver mudança de departamento dentro de um cargo ou vice-versa.';
COMMENT ON COLUMN historico_cargos.id_empregado IS 'Propriedade com valor único na tabela. A chave primária vai garantir que este valor não seja repetido ou confundido com a identificação de outro funcionário. Referenciada na tabela histórico_cargo.';
COMMENT ON COLUMN historico_cargos.data_inicial IS 'Indica a data de inicio do funcionário em determinado cargo. Essa propriedade deve apresentar valores menores que do que a propriedade data_final.';
COMMENT ON COLUMN historico_cargos.data_final IS 'Último dia de um funcionário em um determinado cargo. O valor inserido nesta propriedade deve ser maior do que a data inicial.';
COMMENT ON COLUMN historico_cargos.id_cargo IS 'Código de identificação do último cargo exercido pelo empregado. Chave estrangeira (tabela cargos).';
COMMENT ON COLUMN historico_cargos.id_departamento IS 'Código que identifica o departamento cadastrado de acordo com o código de identificação. Corresponde ao último departamento onde o empregado trabalhou.';

/*Criação de chave estrangeira nas tabelas*/

ALTER TABLE empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargo)
REFERENCES cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE historico_cargos ADD CONSTRAINT cargos_historico_cargos_fk
FOREIGN KEY (id_cargo)
REFERENCES cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE paises ADD CONSTRAINT paises_regioes_fk
FOREIGN KEY (id_regiao)
REFERENCES regioes (id_regiao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE localizacoes ADD CONSTRAINT paises_localizacoes_fk
FOREIGN KEY (id_pais)
REFERENCES paises (id_pais)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE departamentos ADD CONSTRAINT localizacoes_departamentos_fk
FOREIGN KEY (id_localizacoes)
REFERENCES localizacoes (id_localizacoes)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE empregados ADD CONSTRAINT departamentos_empregados_fk
FOREIGN KEY (id_departamento)
REFERENCES departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE historico_cargos ADD CONSTRAINT departamentos_historico_cargos_fk
FOREIGN KEY (id_departamento)
REFERENCES departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE gerentes ADD CONSTRAINT departamentos_gerentes_fk
FOREIGN KEY (id_departamento)
REFERENCES departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE historico_cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY (id_empregado)
REFERENCES empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_supervisor)
REFERENCES empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE gerentes ADD CONSTRAINT gerentes_empregados_fk
FOREIGN KEY (id_gerente)
REFERENCES empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


/*Implementação dos valores nas tabelas criadas anteriormente*/

/*Tais valores devem ser inseridos na ordem apresentada*/


/*Valores da tabela regioes*/

INSERT INTO hr.regioes (id_regiao, nome) VALUES (1, 'Europe');
INSERT INTO hr.regioes (id_regiao, nome) VALUES (2, 'Americas');
INSERT INTO hr.regioes (id_regiao, nome) VALUES (3, 'Asia');
INSERT INTO hr.regioes (id_regiao, nome) VALUES (4, 'Middle East and Africa');


/*Valores da tabela paises*/

INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('AR', 'Argentina', '2');
INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('AU', 'Australia', '3');
INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('BE', 'Belgium', '1');
INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('BR', 'Brazil', '2');
INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('CA', 'Canada', '2');
INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('CH', 'Switzerland', '1');
INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('CN', 'China', '3');
INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('DE', 'Germany', '1');
INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('DK', 'Denmark', '1');
INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('EG', 'Egypt', '4');
INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('FR', 'France', '1');
INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('IL', 'Israel', '4');
INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('IN', 'India', '3');
INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('IT', 'Italy', '1');
INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('JP', 'Japan', '3');
INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('KW', 'Kuwait', '4');
INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('ML', 'Malaysia', '3');
INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('MX', 'Mexico', '2');
INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('NG', 'Nigeria', '4');
INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('NL', 'Netherlands', '1');
INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('SG', 'Singapore', '3');
INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('UK', 'United Kingdom', '1');
INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('US', 'United States of America', '2');
INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('ZM', 'Zambia', '4');
INSERT INTO hr.paises (id_pais, nome, id_regiao) VALUES ('ZW', 'Zimbabwe', '4');


/*Valores da tabela localizacoes*/

INSERT INTO hr.localizacoes (id_localizacoes, endereco, cep, cidade, uf, id_pais) VALUES (1000, '1297 Via Cola di Rie', '00989', 'Roma', 'null', 'IT');
INSERT INTO hr.localizacoes (id_localizacoes, endereco, cep, cidade, uf, id_pais) VALUES (1100, '93091 Calle della Testa', '10934', 'Venice', 'null', 'IT');
INSERT INTO hr.localizacoes (id_localizacoes, endereco, cep, cidade, uf, id_pais) VALUES (1200, '2017 Shinjuku-ku', '1689', 'Tokyo', 'Tokyo Prefecture', 'JP');
INSERT INTO hr.localizacoes (id_localizacoes, endereco, cep, cidade, uf, id_pais) VALUES (1300, '9450 Kamiya-cho', '6823', 'Hiroshima', 'null', 'JP');
INSERT INTO hr.localizacoes (id_localizacoes, endereco, cep, cidade, uf, id_pais) VALUES (1400, '2014 Jabberwocky Rd', '26192', 'Southlake', 'Texas', 'US');
INSERT INTO hr.localizacoes (id_localizacoes, endereco, cep, cidade, uf, id_pais) VALUES (1500, '2011 Interiors Blvd', '99236', 'South San Francisco', 'California', 'US');
INSERT INTO hr.localizacoes (id_localizacoes, endereco, cep, cidade, uf, id_pais) VALUES (1600, '2007 Zagora St', '50090', 'South Brunswick', 'New Jersey', 'US');
INSERT INTO hr.localizacoes (id_localizacoes, endereco, cep, cidade, uf, id_pais) VALUES (1700, '2004 Charade Rd', '98199', 'Seattle', 'Washington', 'US');
INSERT INTO hr.localizacoes (id_localizacoes, endereco, cep, cidade, uf, id_pais) VALUES (1800, '147 Spadina Ave', 'M5V 2L7', 'Toronto', 'Ontario', 'CA');
INSERT INTO hr.localizacoes (id_localizacoes, endereco, cep, cidade, uf, id_pais) VALUES (1900, '6092 Boxwood St', 'YSW 9T2', 'Whitehorse', 'Yukon', 'CA');
INSERT INTO hr.localizacoes (id_localizacoes, endereco, cep, cidade, uf, id_pais) VALUES (2000, '40-5-12 Laogianggen', '190518', 'Beijing', 'null', 'CN');
INSERT INTO hr.localizacoes (id_localizacoes, endereco, cep, cidade, uf, id_pais) VALUES (2100, '1298 Vileparle (E)', '490231', 'Bombay', 'Maharashtra', 'IN');
INSERT INTO hr.localizacoes (id_localizacoes, endereco, cep, cidade, uf, id_pais) VALUES (2200, '12-98 Victoria Street', '2901', 'Sydney', 'New South Wales', 'AU');
INSERT INTO hr.localizacoes (id_localizacoes, endereco, cep, cidade, uf, id_pais) VALUES (2300, '198 Clementi North', '540198', 'Singapore', 'null', 'SG');
INSERT INTO hr.localizacoes (id_localizacoes, endereco, cep, cidade, uf, id_pais) VALUES (2400, '8204 Arthur St', 'null', 'London', 'null', 'UK');
INSERT INTO hr.localizacoes (id_localizacoes, endereco, cep, cidade, uf, id_pais) VALUES (2500, 'Magdalen Centre, The Oxford Science Park', 'OX9 9ZB', 'Oxford', 'Oxford', 'UK');
INSERT INTO hr.localizacoes (id_localizacoes, endereco, cep, cidade, uf, id_pais) VALUES (2600, '9702 Chester Road', '09629850293', 'Stretford', 'Manchester', 'UK');
INSERT INTO hr.localizacoes (id_localizacoes, endereco, cep, cidade, uf, id_pais) VALUES (2700, 'Schwanthalerstr. 7031', '80925', 'Munich', 'Bavaria', 'DE');
INSERT INTO hr.localizacoes (id_localizacoes, endereco, cep, cidade, uf, id_pais) VALUES (2800, 'Rua Frei Caneca 1360 ', '01307-002', 'Sao Paulo', 'Sao Paulo', 'BR');
INSERT INTO hr.localizacoes (id_localizacoes, endereco, cep, cidade, uf, id_pais) VALUES (2900, '20 Rue des Corps-Saints', '1730', 'Geneva', 'Geneve', 'CH');
INSERT INTO hr.localizacoes (id_localizacoes, endereco, cep, cidade, uf, id_pais) VALUES (3000, 'Murtenstrasse 921', '3095', 'Bern', 'BE', 'CH');
INSERT INTO hr.localizacoes (id_localizacoes, endereco, cep, cidade, uf, id_pais) VALUES (3100, 'Pieter Breughelstraat 837', '3029SK', 'Utrecht', 'Utrecht', 'NL');
INSERT INTO hr.localizacoes (id_localizacoes, endereco, cep, cidade, uf, id_pais) VALUES (3200, 'Mariano Escobedo 9991', '11932', 'Mexico City', 'Distrito Federal,', 'MX');


/*Valores da tabela departamentos*/

INSERT INTO hr.departamentos (id_departamento, nome, id_localizacoes) VALUES (10, 'Administration', 1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacoes) VALUES (20, 'Marketing', 1800);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacoes) VALUES (30, 'Purchasing', 1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacoes) VALUES (40, 'Human Resources', 2400);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacoes) VALUES (50, 'Shipping', 1500);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacoes) VALUES (60, 'IT', 1400);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacoes) VALUES (70, 'Public Relations', 2700);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacoes) VALUES (80, 'Sales', 2500);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacoes) VALUES (90, 'Executive', 1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacoes) VALUES (100, 'Finance', 1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacoes) VALUES (110, 'Accounting', 1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacoes) VALUES (120, 'Treasury', 1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacoes) VALUES (130, 'Corporate Tax', 1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacoes) VALUES (140, 'Control And Credit', 1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacoes) VALUES (150, 'Shareholder Services', 1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacoes) VALUES (160, 'Benefits', 1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacoes) VALUES (170, 'Manufacturing', 1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacoes) VALUES (180, 'Construction', 1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacoes) VALUES (190, 'Contracting', 1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacoes) VALUES (200, 'Operations', 1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacoes) VALUES (210, 'IT Support', 1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacoes) VALUES (220, 'NOC', 1700);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacoes) VALUES (230, 'IT Helpdesk', 1700);


/*Valores da tabela cargos*/

INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ('AD_PRES', 'President', 20080, 40000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ('AD_VP', 'Administration Vice President', 15000, 30000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ('AD_ASST', 'Administration Assistant', 3000, 6000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ('FI_MGR', 'Finance Manager', 8200, 16000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ('FI_ACCOUNT', 'Accountant', 4200, 9000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ('AC_MGR', 'Accounting Manager', 8200, 16000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ('AC_ACCOUNT', 'Public Accountant', 4200, 9000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ('SA_MAN', 'Sales Manager', 10000, 20080);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ('SA_REP', 'Sales Representative', 6000, 12008);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ('PU_MAN', 'Purchasing Manager', 8000, 15000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ('PU_CLERK', 'Purchasing Clerk', 2500, 5500);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ('ST_MAN', 'Stock Manager', 5500, 8500);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ('ST_CLERK', 'Stock Clerk', 2008, 5000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ('SH_CLERK', 'Shipping Clerk', 2500, 5500);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ('IT_PROG', 'Programmer', 4000, 10000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ('MK_MAN', 'Marketing Manager', 9000, 15000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ('MK_REP', 'Marketing Representative', 4000, 9000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ('HR_REP', 'Human Resources Representative', 4000, 9000);
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES ('PR_REP', 'Public Relations Representative', 4500, 10500);


/*Valores da tabela empregados*/

INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (100, 'Steven King', 'SKING', '515.123.4567', TO_DATE('2003-06-17', 'yyyy-mm-dd'), 'AD_PRES', 24000, null, 90, 100);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (101, 'Neena Kochhar', 'NKOCHHAR', '515.123.4568', TO_DATE('2005-09-21', 'yyyy-mm-dd'), 'AD_VP', 17000, null, 90, 101);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (102, 'Lex De Haan', 'LDEHAAN', '515.123.4569', TO_DATE('2001-01-13', 'yyyy-mm-dd'), 'AD_VP', 17000, null, 90, 102);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (103, 'Alexander Hunold', 'AHUNOLD', '590.423.4567', TO_DATE('2006-01-03', 'yyyy-mm-dd'), 'IT_PROG', 9000, null, 60, 103);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (104, 'Bruce Ernst', 'BERNST', '590.423.4568', TO_DATE('2007-05-21', 'yyyy-mm-dd'), 'IT_PROG', 6000, null, 60, 104);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (105, 'David Austin', 'DAUSTIN', '590.423.4569', TO_DATE('2005-06-25', 'yyyy-mm-dd'), 'IT_PROG', 4800, null, 60, 105);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (106, 'Valli Pataballa', 'VPATABAL', '590.423.4560', TO_DATE('2006-02-05', 'yyyy-mm-dd'), 'IT_PROG', 4800, null, 60, 106);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (107, 'Diana Lorentz', 'DLORENTZ', '590.423.5567', TO_DATE('2007-02-07', 'yyyy-mm-dd'), 'IT_PROG', 4200, null, 60, 107);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (108, 'Nancy Greenberg', 'NGREENBE', '515.124.4569', TO_DATE('2002-08-17', 'yyyy-mm-dd'), 'FI_MGR', 12008, null, 100, 108);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (109, 'Daniel Faviet', 'DFAVIET', '515.124.4169', TO_DATE('2002-08-16', 'yyyy-mm-dd'), 'FI_ACCOUNT', 9000, null, 100, 109);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (110, 'John Chen', 'JCHEN', '515.124.4269', TO_DATE('2005-09-28', 'yyyy-mm-dd'), 'FI_ACCOUNT', 8200, null, 100, 110);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (111, 'Ismael Sciarra', 'ISCIARRA', '515.124.4369', TO_DATE('2005-09-30', 'yyyy-mm-dd'), 'FI_ACCOUNT', 7700, null, 100, 111);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (112, 'Jose Manuel Urman', 'JMURMAN', '515.124.4469', TO_DATE('2006-03-07', 'yyyy-mm-dd'), 'FI_ACCOUNT', 7800, null, 100, 112);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (113, 'Luis Popp', 'LPOPP', '515.124.4567', TO_DATE('2007-12-07', 'yyyy-mm-dd'), 'FI_ACCOUNT', 6900, null, 100, 113);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (114, 'Den Raphaely', 'DRAPHEAL', '515.127.4561', TO_DATE('2002-12-07', 'yyyy-mm-dd'), 'PU_MAN', 11000, null, 30, 114);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (115, 'Alexander Khoo', 'AKHOO', '515.127.4562', TO_DATE('2003-05-18', 'yyyy-mm-dd'), 'PU_CLERK', 3100, null, 30, 115);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (116, 'Shelli Baida', 'SBAIDA', '515.127.4563', TO_DATE('2005-12-24', 'yyyy-mm-dd'), 'PU_CLERK', 2900, null, 30, 116);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (117, 'Sigal Tobias', 'STOBIAS', '515.127.4564', TO_DATE('2005-07-24', 'yyyy-mm-dd'), 'PU_CLERK', 2800, null, 30, 117);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (118, 'Guy Himuro', 'GHIMURO', '515.127.4565', TO_DATE('2006-11-15', 'yyyy-mm-dd'), 'PU_CLERK', 2600, null, 30, 118);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (119, 'Karen Colmenares', 'KCOLMENA', '515.127.4566', TO_DATE('2007-08-10', 'yyyy-mm-dd'), 'PU_CLERK', 2500, null, 30, 119);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (120, 'Matthew Weiss', 'MWEISS', '650.123.1234', TO_DATE('2004-07-18', 'yyyy-mm-dd'), 'ST_MAN', 8000, null, 50, 120);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (121, 'Adam Fripp', 'AFRIPP', '650.123.2234', TO_DATE('2005-04-10', 'yyyy-mm-dd'), 'ST_MAN', 8200, null, 50, 121);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (122, 'Payam Kaufling', 'PKAUFLIN', '650.123.3234', TO_DATE('2003-05-01', 'yyyy-mm-dd'), 'ST_MAN', 7900, null, 50, 122);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (123, 'Shanta Vollman', 'SVOLLMAN', '650.123.4234', TO_DATE('2005-10-10', 'yyyy-mm-dd'), 'ST_MAN', 6500, null, 50, 123);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (124, 'Kevin Mourgos', 'KMOURGOS', '650.123.5234', TO_DATE('2007-11-16', 'yyyy-mm-dd'), 'ST_MAN', 5800, null, 50, 124);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (125, 'Julia Nayer', 'JNAYER', '650.124.1214', TO_DATE('2005-07-16', 'yyyy-mm-dd'), 'ST_CLERK', 3200, null, 50, 125);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (126, 'Irene Mikkilineni', 'IMIKKILI', '650.124.1224', TO_DATE('2006-09-28', 'yyyy-mm-dd'), 'ST_CLERK', 2700, null, 50, 126);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (127, 'James Landry', 'JLANDRY', '650.124.1334', TO_DATE('2007-01-14', 'yyyy-mm-dd'), 'ST_CLERK', 2400, null, 50, 127);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (128, 'Steven Markle', 'SMARKLE', '650.124.1434', TO_DATE('2008-03-08', 'yyyy-mm-dd'), 'ST_CLERK', 2200, null, 50, 128);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (129, 'Laura Bissot', 'LBISSOT', '650.124.5234', TO_DATE('2005-08-20', 'yyyy-mm-dd'), 'ST_CLERK', 3300, null, 50, 129);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (130, 'Mozhe Atkinson', 'MATKINSO', '650.124.6234', TO_DATE('2005-10-30', 'yyyy-mm-dd'), 'ST_CLERK', 2800, null, 50, 130);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (131, 'James Marlow', 'JAMRLOW', '650.124.7234', TO_DATE('2005-02-16', 'yyyy-mm-dd'), 'ST_CLERK', 2500, null, 50, 131);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (132, 'TJ Olson', 'TJOLSON', '650.124.8234', TO_DATE('2007-04-10', 'yyyy-mm-dd'), 'ST_CLERK', 2100, null, 50, 132);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (133, 'Jason Mallin', 'JMALLIN', '650.127.1934', TO_DATE('2004-06-14', 'yyyy-mm-dd'), 'ST_CLERK', 3300, null, 50, 133);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (134, 'Michael Rogers', 'MROGERS', '650.127.1834', TO_DATE('2006-08-26', 'yyyy-mm-dd'), 'ST_CLERK', 2900, null, 50, 134);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (135, 'Ki Gee', 'KGEE', '650.127.1734', TO_DATE('2007-12-12', 'yyyy-mm-dd'), 'ST_CLERK', 2400, null, 50, 135);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (136, 'Hazel Philtanker', 'HPHILTAN', '650.127.1634', TO_DATE('2008-02-06', 'yyyy-mm-dd'), 'ST_CLERK', 2200, null, 50, 136);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (137, 'Renske Ladwig', 'RLADWIG', '650.121.1234', TO_DATE('2003-07-14', 'yyyy-mm-dd'), 'ST_CLERK', 3600, null, 50, 137);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (138, 'Stephen Stiles', 'SSTILES', '650.121.2034', TO_DATE('2005-10-26', 'yyyy-mm-dd'), 'ST_CLERK', 3200, null, 50, 138);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (139, 'John Seo', 'JSEO', '650.121.2019', TO_DATE('2006-02-12', 'yyyy-mm-dd'), 'ST_CLERK', 2700, null, 50, 139);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (140, 'Joshua Patel', 'JPATEL', '650.121.1834', TO_DATE('2006-04-06', 'yyyy-mm-dd'), 'ST_CLERK', 2500, null, 50, 140);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (141, 'Trenna Rajs', 'TRAJS', '650.121.8009', TO_DATE('2003-10-17', 'yyyy-mm-dd'), 'ST_CLERK', 3500, null, 50, 141);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (142, 'Curtis Davies', 'CDAVIES', '650.121.2994', TO_DATE('2005-01-29', 'yyyy-mm-dd'), 'ST_CLERK', 3100, null, 50, 142);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (143, 'Randall Matos', 'RMATOS', '650.121.2874', TO_DATE('2006-03-15', 'yyyy-mm-dd'), 'ST_CLERK', 2600, null, 50, 143);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (144, 'Peter Vargas', 'PVARGAS', '650.121.2004', TO_DATE('2006-07-09', 'yyyy-mm-dd'), 'ST_CLERK', 2500, null, 50, 144);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (145, 'John Russell', 'JRUSSEL', '011.44.1344.429268', TO_DATE('2004-10-01', 'yyyy-mm-dd'), 'SA_MAN', 14000, .4, 80, 145);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (146, 'Karen Partners', 'KPARTNER', '011.44.1344.467268', TO_DATE('2005-01-05', 'yyyy-mm-dd'), 'SA_MAN', 13500, .3, 80, 146);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (147, 'Alberto Errazuriz', 'AERRAZUR', '011.44.1344.429278', TO_DATE('2005-03-10', 'yyyy-mm-dd'), 'SA_MAN', 12000, .3, 80, 147);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (148, 'Gerald Cambrault', 'GCAMBRAU', '011.44.1344.619268', TO_DATE('2007-10-15', 'yyyy-mm-dd'), 'SA_MAN', 11000, .3, 80, 148);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (149, 'Eleni Zlotkey', 'EZLOTKEY', '011.44.1344.429018', TO_DATE('2008-01-29', 'yyyy-mm-dd'), 'SA_MAN', 10500, .2, 80, 149);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (150, 'Peter Tucker', 'PTUCKER', '011.44.1344.129268', TO_DATE('2005-01-30', 'yyyy-mm-dd'), 'SA_REP', 10000, .3, 80, 150);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (151, 'David Bernstein', 'DBERNSTE', '011.44.1344.345268', TO_DATE('2005-03-24', 'yyyy-mm-dd'), 'SA_REP', 9500, .25, 80, 151);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (152, 'Peter Hall', 'PHALL', '011.44.1344.478968', TO_DATE('2005-08-20', 'yyyy-mm-dd'), 'SA_REP', 9000, .25, 80, 152);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (153, 'Christopher Olsen', 'COLSEN', '011.44.1344.498718', TO_DATE('2006-03-30', 'yyyy-mm-dd'), 'SA_REP', 8000, .2, 80, 153);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (154, 'Nanette Cambrault', 'NCAMBRAU', '011.44.1344.987668', TO_DATE('2006-12-09', 'yyyy-mm-dd'), 'SA_REP', 7500, .2, 80, 154);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (155, 'Oliver Tuvault', 'OTUVAULT', '011.44.1344.486508', TO_DATE('2007-11-23', 'yyyy-mm-dd'), 'SA_REP', 7000, .15, 80, 155);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (156, 'Janette King', 'JKING', '011.44.1345.429268', TO_DATE('2004-01-30', 'yyyy-mm-dd'), 'SA_REP', 10000, .35, 80, 156);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (157, 'Patrick Sully', 'PSULLY', '011.44.1345.929268', TO_DATE('2004-03-04', 'yyyy-mm-dd'), 'SA_REP', 9500, .35, 80, 157);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (158, 'Allan McEwen', 'AMCEWEN', '011.44.1345.829268', TO_DATE('2004-08-01', 'yyyy-mm-dd'), 'SA_REP', 9000, .35, 80, 158);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (159, 'Lindsey Smith', 'LSMITH', '011.44.1345.729268', TO_DATE('2005-03-10', 'yyyy-mm-dd'), 'SA_REP', 8000, .3, 80, 159);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (160, 'Louise Doran', 'LDORAN', '011.44.1345.629268', TO_DATE('2005-12-15', 'yyyy-mm-dd'), 'SA_REP', 7500, .3, 80, 160);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (161, 'Sarath Sewall', 'SSEWALL', '011.44.1345.529268', TO_DATE('2006-11-03', 'yyyy-mm-dd'), 'SA_REP', 7000, .25, 80, 161);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (162, 'Clara Vishney', 'CVISHNEY', '011.44.1346.129268', TO_DATE('2005-11-11', 'yyyy-mm-dd'), 'SA_REP', 10500, .25, 80, 162);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (163, 'Danielle Greene', 'DGREENE', '011.44.1346.229268', TO_DATE('2007-03-19', 'yyyy-mm-dd'), 'SA_REP', 9500, .15, 80, 163);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (164, 'Mattea Marvins', 'MMARVINS', '011.44.1346.329268', TO_DATE('2008-01-24', 'yyyy-mm-dd'), 'SA_REP', 7200, .1, 80, 164);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (165, 'David Lee', 'DLEE', '011.44.1346.529268', TO_DATE('2008-02-23', 'yyyy-mm-dd'), 'SA_REP', 6800, .1, 80, 165);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (166, 'Sundar Ande', 'SANDE', '011.44.1346.629268', TO_DATE('2008-03-24', 'yyyy-mm-dd'), 'SA_REP', 6400, .1, 80, 166);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (167, 'Amit Banda', 'ABANDA', '011.44.1346.729268', TO_DATE('2008-04-21', 'yyyy-mm-dd'), 'SA_REP', 6200, .1, 80, 167);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (168, 'Lisa Ozer', 'LOZER', '011.44.1343.929268', TO_DATE('2005-03-11', 'yyyy-mm-dd'), 'SA_REP', 11500, .25, 80, 168);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (169, 'Harrison Bloom', 'HBLOOM', '011.44.1343.829268', TO_DATE('2006-03-23', 'yyyy-mm-dd'), 'SA_REP', 10000, .2, 80, 169);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (170, 'Tayler Fox', 'TFOX', '011.44.1343.729268', TO_DATE('2006-01-24', 'yyyy-mm-dd'), 'SA_REP', 9600, .2, 80, 170);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (171, 'William Smith', 'WSMITH', '011.44.1343.629268', TO_DATE('2007-02-23', 'yyyy-mm-dd'), 'SA_REP', 7400, .15, 80, 171);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (172, 'Elizabeth Bates', 'EBATES', '011.44.1343.529268', TO_DATE('2007-03-24', 'yyyy-mm-dd'), 'SA_REP', 7300, .15, 80, 172);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (173, 'Sundita Kumar', 'SKUMAR', '011.44.1343.329268', TO_DATE('2008-04-21', 'yyyy-mm-dd'), 'SA_REP', 6100, .1, 80, 173);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (174, 'Ellen Abel', 'EABEL', '011.44.1644.429267', TO_DATE('2004-05-11', 'yyyy-mm-dd'), 'SA_REP', 11000, .3, 80, 174);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (175, 'Alyssa Hutton', 'AHUTTON', '011.44.1644.429266', TO_DATE('2005-03-19', 'yyyy-mm-dd'), 'SA_REP', 8800, .25, 80, 175);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (176, 'Jonathon Taylor', 'JTAYLOR', '011.44.1644.429265', TO_DATE('2006-03-24', 'yyyy-mm-dd'), 'SA_REP', 8600, .2, 80, 176);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (177, 'Jack Livingston', 'JLIVINGS', '011.44.1644.429264', TO_DATE('2006-04-23', 'yyyy-mm-dd'), 'SA_REP', 8400, .2, 80, 177);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (178, 'Kimberely Grant', 'KGRANT', '011.44.1644.429263', TO_DATE('2007-05-24', 'yyyy-mm-dd'), 'SA_REP', 7000, .15, null, 178);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (179, 'Charles Johnson', 'CJOHNSON', '011.44.1644.429262', TO_DATE('2008-01-04', 'yyyy-mm-dd'), 'SA_REP', 6200, .1, 80, 179);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (180, 'Winston Taylor', 'WTAYLOR', '650.507.9876', TO_DATE('2006-01-24', 'yyyy-mm-dd'), 'SH_CLERK', 3200, null, 50, 180);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (181, 'Jean Fleaur', 'JFLEAUR', '650.507.9877', TO_DATE('2006-02-23', 'yyyy-mm-dd'), 'SH_CLERK', 3100, null, 50, 181);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (182, 'Martha Sullivan', 'MSULLIVA', '650.507.9878', TO_DATE('2007-06-21', 'yyyy-mm-dd'), 'SH_CLERK', 2500, null, 50, 182);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (183, 'Girard Geoni', 'GGEONI', '650.507.9879', TO_DATE('2008-02-03', 'yyyy-mm-dd'), 'SH_CLERK', 2800, null, 50, 183);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (184, 'Nandita Sarchand', 'NSARCHAN', '650.509.1876', TO_DATE('2004-01-27', 'yyyy-mm-dd'), 'SH_CLERK', 4200, null, 50, 184);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (185, 'Alexis Bull', 'ABULL', '650.509.2876', TO_DATE('2005-02-20', 'yyyy-mm-dd'), 'SH_CLERK', 4100, null, 50, 185);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (186, 'Julia Dellinger', 'JDELLING', '650.509.3876', TO_DATE('2006-06-24', 'yyyy-mm-dd'), 'SH_CLERK', 3400, null, 50, 186);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (187, 'Anthony Cabrio', 'ACABRIO', '650.509.4876', TO_DATE('2007-02-07', 'yyyy-mm-dd'), 'SH_CLERK', 3000, null, 50, 187);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (188, 'Kelly Chung', 'KCHUNG', '650.505.1876', TO_DATE('2005-06-14', 'yyyy-mm-dd'), 'SH_CLERK', 3800, null, 50, 188);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (189, 'Jennifer Dilly', 'JDILLY', '650.505.2876', TO_DATE('2005-08-13', 'yyyy-mm-dd'), 'SH_CLERK', 3600, null, 50, 189);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (190, 'Timothy Gates', 'TGATES', '650.505.3876', TO_DATE('2006-07-11', 'yyyy-mm-dd'), 'SH_CLERK', 2900, null, 50, 190);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (191, 'Randall Perkins', 'RPERKINS', '650.505.4876', TO_DATE('2007-12-19', 'yyyy-mm-dd'), 'SH_CLERK', 2500, null, 50, 191);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (192, 'Sarah Bell', 'SBELL', '650.501.1876', TO_DATE('2004-02-04', 'yyyy-mm-dd'), 'SH_CLERK', 4000, null, 50, 192);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (193, 'Britney Everett', 'BEVERETT', '650.501.2876', TO_DATE('2005-03-03', 'yyyy-mm-dd'), 'SH_CLERK', 3900, null, 50, 193);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (194, 'Samuel McCain', 'SMCCAIN', '650.501.3876', TO_DATE('2006-07-01', 'yyyy-mm-dd'), 'SH_CLERK', 3200, null, 50, 194);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (195, 'Vance Jones', 'VJONES', '650.501.4876', TO_DATE('2007-03-17', 'yyyy-mm-dd'), 'SH_CLERK', 2800, null, 50, 195);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (196, 'Alana Walsh', 'AWALSH', '650.507.9811', TO_DATE('2006-04-24', 'yyyy-mm-dd'), 'SH_CLERK', 3100, null, 50, 196);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (197, 'Kevin Feeney', 'KFEENEY', '650.507.9822', TO_DATE('2006-05-23', 'yyyy-mm-dd'), 'SH_CLERK', 3000, null, 50, 197);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (198, 'Donald OConnell', 'DOCONNEL', '650.507.9833', TO_DATE('2007-06-21', 'yyyy-mm-dd'), 'SH_CLERK', 2600, null, 50, 198);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (199, 'Douglas Grant', 'DGRANT', '650.507.9844', TO_DATE('2008-01-13', 'yyyy-mm-dd'), 'SH_CLERK', 2600, null, 50, 199);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (200, 'Jennifer Whalen', 'JWHALEN', '515.123.4444', TO_DATE('2003-09-17', 'yyyy-mm-dd'), 'AD_ASST', 4400, null, 10, 200);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (201, 'Michael Hartstein', 'MHARTSTE', '515.123.5555', TO_DATE('2004-02-17', 'yyyy-mm-dd'), 'MK_MAN', 13000, null, 20, 201);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (202, 'Pat Fay', 'PFAY', '603.123.6666', TO_DATE('2005-08-17', 'yyyy-mm-dd'), 'MK_REP', 6000, null, 20, 202);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (203, 'Susan Mavris', 'SMAVRIS', '515.123.7777', TO_DATE('2002-06-07', 'yyyy-mm-dd'), 'HR_REP', 6500, null, 40, 203);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (204, 'Hermann Baer', 'HBAER', '515.123.8888', TO_DATE('2002-06-07', 'yyyy-mm-dd'), 'PR_REP', 10000, null, 70, 204);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (205, 'Shelley Higgins', 'SHIGGINS', '515.123.8080', TO_DATE('2002-06-07', 'yyyy-mm-dd'), 'AC_MGR', 12008, null, 110, 205);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_departamento, id_supervisor) VALUES (206, 'William Gietz', 'WGIETZ', '515.123.8181', TO_DATE('2002-06-07', 'yyyy-mm-dd'), 'AC_ACCOUNT', 8300, null, 110, 206);


/*Valores da tabela gerentes*/

INSERT INTO hr.gerentes (id_gerente, id_departamento) VALUES ('108','100');
INSERT INTO hr.gerentes (id_gerente, id_departamento) VALUES ('114','30');
INSERT INTO hr.gerentes (id_gerente, id_departamento) VALUES ('120','50');
INSERT INTO hr.gerentes (id_gerente, id_departamento) VALUES ('121','50');
INSERT INTO hr.gerentes (id_gerente, id_departamento) VALUES ('122','50');
INSERT INTO hr.gerentes (id_gerente, id_departamento) VALUES ('123','50');
INSERT INTO hr.gerentes (id_gerente, id_departamento) VALUES ('124','50');
INSERT INTO hr.gerentes (id_gerente, id_departamento) VALUES ('201','20');
INSERT INTO hr.gerentes (id_gerente, id_departamento) VALUES ('205','110');


/*Valores da tabela gerentes*/

INSERT INTO historico_cargos (id_empregado, data_inicial, data_final, id_cargo, id_departamento) VALUES (200, '1995-09-17', '2001-06-17', 'AD_ASST', 90);
INSERT INTO historico_cargos (id_empregado, data_inicial, data_final, id_cargo, id_departamento) VALUES (101, '1997-09-21', '2001-10-27', 'AC_ACCOUNT', 110);
INSERT INTO historico_cargos (id_empregado, data_inicial, data_final, id_cargo, id_departamento) VALUES (102, '2001-01-13', '2006-07-24', 'IT_PROG', 60);
INSERT INTO historico_cargos (id_empregado, data_inicial, data_final, id_cargo, id_departamento) VALUES (101, '2001-10-28', '2005-03-15', 'AC_MGR', 110);
INSERT INTO historico_cargos (id_empregado, data_inicial, data_final, id_cargo, id_departamento) VALUES (200, '2002-07-01', '2006-12-31', 'AC_ACCOUNT', 90);
INSERT INTO historico_cargos (id_empregado, data_inicial, data_final, id_cargo, id_departamento) VALUES (201, '2004-02-17', '2007-12-19', 'MK_REP', 20);
INSERT INTO historico_cargos (id_empregado, data_inicial, data_final, id_cargo, id_departamento) VALUES (114, '2006-03-24', '2007-12-31', 'ST_CLERK', 50);
INSERT INTO historico_cargos (id_empregado, data_inicial, data_final, id_cargo, id_departamento) VALUES (176, '2006-03-24', '2006-12-31', 'SA_REP', 80);
INSERT INTO historico_cargos (id_empregado, data_inicial, data_final, id_cargo, id_departamento) VALUES (176, '2007-01-01', '2007-12-31', 'SA_MAN', 80);
INSERT INTO historico_cargos (id_empregado, data_inicial, data_final, id_cargo, id_departamento) VALUES (122, '2007-01-01', '2007-12-31', 'ST_CLERK', 50);






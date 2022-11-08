CREATE USER raquel WITH
  SUPERUSER
  CREATEDB
  CREATEROLE
  INHERIT
  REPLICATION
  BYPASSRLS
  ENCRYPTED PASSWORD '202202882'
;

\c uvv raquel;

CREATE SCHEMA IF NOT EXISTS hr AUTHORIZATION raquel;

SET SEARCH_PATH TO hr, raquel, public;
  
CREATE DATABASE uvv
  WITH OWNER = raquel
  TEMPLATE = template)
  ENCODING = 'UTF8'
  LC_COLLATE = 'pt_BR.UTF-8'
  LC_CTYPE = 'pt_BR.UTF-8'
  ALLOW_CONNECTIONS = true
;

CREATE TABLE cargos (
                id_cargo VARCHAR(10) NOT NULL,
                cargo VARCHAR(35) NOT NULL,
                salario_minimo NUMERIC(8,2),
                salario_maximo NUMERIC(8,2),
                CONSTRAINT id_cargo_pk PRIMARY KEY (id_cargo)
);

COMMENT ON TABLE cargos IS 'Tabela que armazena informações sobre salário e código dos cargos na empresa.';
COMMENT ON COLUMN cargos.id_cargo IS 'Código de identificação do cargo exercido por determinado empregado.
Chave estrangeira para a tabela empregados e historico_cargos.';
COMMENT ON COLUMN cargos.cargo IS 'Nome do cargo de cada funcionário.';
COMMENT ON COLUMN cargos.salario_minimo IS 'Salário mínimo admitido ao funcionário de determinado cargo.';
COMMENT ON COLUMN cargos.salario_maximo IS 'Maior salário admitido a determinado funcionário.';


CREATE TABLE regioes (
                id_regiao INTEGER NOT NULL,
                nome VARCHAR(25) NOT NULL,
                CONSTRAINT id_regiao_pk PRIMARY KEY (id_regiao)
);
COMMENT ON TABLE regioes IS 'Tabela do tipo 1:N.
Contém o código de indentificação e nome de cada região cadastrada.';
COMMENT ON COLUMN regioes.id_regiao IS 'Chave primária da tabela regioes, tipo integer (numero não fracionário).
Como toda chave primária, essa coluna não pode ser deixada com o valor nulo.';
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
COMMENT ON COLUMN paises.id_pais IS 'Chave primária da tabela países. 
Essa coluna tem a utilidade de armazenar o código de cada país onde há uma filial/escritório da empresa.';
COMMENT ON COLUMN paises.nome IS 'Nome do país onde se encontra filiais, escritórios, ou departamentos da empresa.';
COMMENT ON COLUMN paises.id_regiao IS 'Chave primária da tabela regioes, tipo integer (numero não fracionário).
Como toda chave primária, essa coluna não pode ser deixada com o valor nulo.';


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
COMMENT ON COLUMN localizacoes.id_localizacoes IS 'Coluna que contém o código de identificação das localizações inseridas na tabela localizacoes. É uma chave primária e por conta disso, não pode ser nula.
Chave estrangeira para a tabela departamentos.';
COMMENT ON COLUMN localizacoes.endereco IS 'Localização por endereço de uma filial, escritório, e/ou departamento da empresa.';
COMMENT ON COLUMN localizacoes.cep IS 'CEP do endereço/localização de um escritório ou facilidade empresarial.';
COMMENT ON COLUMN localizacoes.cidade IS 'Cidade onde está localizado o escritório ou outra filial da empresa.';
COMMENT ON COLUMN localizacoes.uf IS 'Estado (abreviado ou por extenso) onde está localizado o escritório ou outra facilidade da empresa.';
COMMENT ON COLUMN localizacoes.id_pais IS 'Chave estrangeira que referencia a tabela paises. 
Essa coluna tem a utilidade de armazenar o código de cada país onde há uma filial/escritório da empresa.';


CREATE UNIQUE INDEX localizacoes_idx
 ON localizacoes
 ( cep );

CREATE TABLE departamentos (
                id_departamento INTEGER NOT NULL,
                nome VARCHAR(10),
                id_localizacoes INTEGER NOT NULL,
                CONSTRAINT id_departamento_pk PRIMARY KEY (id_departamento)
);
COMMENT ON TABLE departamentos IS 'Esta tabela reserva informações de identificação (id_departamento, nome, id_localização, id_gerente) dos departamentos da empresa.';
COMMENT ON COLUMN departamentos.id_departamento IS 'Essa propriedade contém uma chave primária, na qual identifica o departamento cadastrado de acordo com o código de identificação.';
COMMENT ON COLUMN departamentos.nome IS 'Propriedade contendo o nome do departamento da tabela.';
COMMENT ON COLUMN departamentos.id_localizacoes IS 'Coluna que contém o código de identificação das localizações inseridas na tabela localizacoes. 
Chave estrangeira para a tabela departamentos.';


CREATE TABLE empregados (
                id_empregado INTEGER NOT NULL,
                nome VARCHAR(75) NOT NULL,
                email VARCHAR(35) NOT NULL,
                telefone VARCHAR(20),
                cpf CHAR(11) NOT NULL,
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
COMMENT ON COLUMN historico_cargos.id_empregado IS 'Propriedade com valor único na tabela. A chave primária vai garantir que este valor não seja repetido ou confundido com a identificação de outro funcionário.
Referenciada na tabela histórico_cargo.';
COMMENT ON COLUMN historico_cargos.data_inicial IS 'Indica a data de inicio do funcionário em determinado cargo. Essa propriedade deve apresentar valores menores que do que a propriedade data_final.';
COMMENT ON COLUMN historico_cargos.data_final IS 'Último dia de um funcionário em um determinado cargo. 
O valor inserido nesta propriedade deve ser maior do que a data inicial.';
COMMENT ON COLUMN historico_cargos.id_cargo IS 'Código de identificação do último cargo exercido pelo empregado.
Chave estrangeira (tabela cargos).';
COMMENT ON COLUMN historico_cargos.id_departamento IS 'Código que identifica o departamento cadastrado de acordo com o código de identificação.
Corresponde ao último departamento onde o empregado trabalhou.';


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

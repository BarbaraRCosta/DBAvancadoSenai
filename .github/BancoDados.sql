CREATE DATABASE Streaming;

create table assinaturas(
                            id_assinatura int(11) auto_increment PRIMARY KEY NOT null,
                            id_usuario int (11) not null,
                            id_canal int (11) not null,
                            data_inicio date,
                            data_termino date,
                            valor_inscricao int,
                            saldo_bits int(11)not null)
                        
                            alter table assinaturas
                            add primary key (id_assinatura)
                            FOREIGN KEY (id_usuario) REFERENCES usuario (PersonID)
                            (id_usuario, id_canal,id_carteira
                                       );


CREATE TABLE pagamento(
                            id_pag int(11) PRIMARY KEY not null,
                            id_usuario int (11) not null,
                            tipo_pagamento varchar(255),
                            bits int(11)not null,
                            inscricao int (11)not null,
                            valor int(11)not null)
                            ;
                        
                            alter table pagamento
                            add primary key (pagamento);
                            
                            ALTER TABLE pagamento
                            ADD CONSTRAINT fk_usuario_pagamento FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario);


create table usuarios(
                        id_usu�rio int(11)not null,
                        usuario_nome varchar(50) unique not null,
                        email varchar(255) unique not null,
                        senha varchar(255)not null,
                        PerfilImagemURL varchar(255),
                        descricacao text,
                        data_criacao datetime default current_timestamp);
                        
                        alter table usuarios
                        add PRIMARY KEY (id_usuario);


create table carteira_bits(

                          id_carteira int(11)auto_increment,
                          id_usuario int not null,
                          saldo int(11));
                      
                          alter table carteira_bits
                          add primary key (id_carteira);
                          ALTER TABLE carteira_bits
                          ADD CONSTRAINT fk_usuario_carteira_bits FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario);


create table canal(
                            id_canal int(11)not null,
                           id_usuario int(11) not null, 
                           Nome_canal varchar(255), 
                           categoria varchar(50), 
                           descricao varchar(255),
                           data_criacao datetime default current_timestamp,
                           id_seguidores int not null, 
                           programacao varchar(255),
                           id_video not null, clipes int(11)); 
                           
                           ADD PRIMARY KEY(id_canal);
                           ALTER TABLE canal
        					ADD CONSTRAINT fk_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario);
        
        					ALTER TABLE canal
        					ADD CONSTRAINT fk_seguidores FOREIGN KEY (id_seguidores) REFERENCES seguidores(id_seguidores);
        
        					ALTER TABLE canal
        					ADD CONSTRAINT fk_video FOREIGN KEY (id_video) REFERENCES transmissao(id_video);

create table comunidades(
                            id_comunidade int(11)AUTO_INCREMENT,
                            id_canal int not null, 
                            nome_comunidade varchar(255),
                            descri��o text,
                            id_seguidores int not null);
                        
                        alter table comunidades 
                        add primary key (comunidades);
                        
                        ALTER TABLE comunidades
                        ADD CONSTRAINT fk_seguidores_comunidades FOREIGN KEY (id_seguidores) REFERENCES tabela_seguidores(id_seguidores);


create table seguidores(

                        id_seguidores int (11) auto_increment,
                        id_usuario int not null, 
                        id_canal int not null
                       );	
                    alter table seguidores
                    add primary key (seguidores);
                       
                       ALTER TABLE seguidores
                    ADD CONSTRAINT fk_usuario_seguidores FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario);
                    
                    ALTER TABLE seguidores
                    ADD CONSTRAINT fk_canal_seguidores FOREIGN KEY (id_canal) REFERENCES canal(id_canal);

create table transmissoes(

                    id_video int(11)not null,
                    id_canal int (11)not null, 
                    titulo varchar(100), descricao text, 
                    dura��o int, 
                    data date, 
                    hora datetime,
                    expectadores int);
                
                alter table transmissoes
                add primary key (id_video);
                    
                    ALTER TABLE transmissoes
                ADD CONSTRAINT fk_canal_transmissoes FOREIGN KEY (id_canal) REFERENCES canal(id_canal);

create table comentarios(

                  id_comentario int(11) auto_increment, 
                  id_usuario int not null, 
                  id_video int not null,
                  comentario text);
                  
                  
                  alter table comentarios
                  ADD PRIMARY KEY (id_comentario);
                  
                  ALTER TABLE comentarios
              ADD CONSTRAINT fk_usuario_comentarios FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario);
              
              ALTER TABLE comentarios
              ADD CONSTRAINT fk_video_comentarios FOREIGN KEY (id_video) REFERENCES transmissoes(id_video);




CREATE TABLE AD(

                id_ad int(11)auto_increment,
                id_canal int not null,
                patrocinador varchar(255),
                quantidade_ad int(11)not null,
                tempo_de_tela datetime );
                
                alter table AD
                ADD PRIMARY KEY (id_ad);
                
                ALTER TABLE AD
            ADD CONSTRAINT fk_canal_ad FOREIGN KEY (id_canal) REFERENCES canal(id_canal);

================================================================    
    VIEW

Create View Trending as
select titulo as Video
from transmissoes where expectadores > 1000
================================================================
TRIGGER

CREATE TRIGGER trigger_desconto
AFTER INSERT ON assinaturas
FOR EACH ROW
BEGIN
    DECLARE novo_saldo_bits INT;
    SET novo_saldo_bits = NEW.saldo_bits - 2;
    
    UPDATE assinaturas
    SET saldo_bits = novo_saldo_bits
    WHERE id_assinatura = NEW.id_assinatura;
=================================================================


=================================================================
CREATE VIEW view_subquery_coluna AS
SELECT
    u.id_usuario,
    u.nome,
    (SELECT COUNT(*) FROM assinaturas a WHERE a.id_usuario = u.id_usuario) AS total_assinaturas
FROM
    usuario u;
==================================================================
CREATE VIEW view_subquery_filtro AS
SELECT
    u.id_usuario,
    u.usuario_nome
FROM
    usuario u
WHERE
    EXISTS (
        SELECT 1
        FROM assinaturas a
        WHERE a.id_usuario = u.id_usuario
        AND a.data_termino >= CURDATE()
    );
-- Desafio DIO
USE shop;

-- Primeiro desafio
CREATE TRIGGER salvando_contas_deletadas BEFORE DELETE ON shop.cliente FOR EACH ROW
	delimiter $$
	CREATE PROCEDURE contas_deletadas(id INT, nome VARCHAR(100), status ENUM('PJ', 'PF'))
		BEGIN
			INSERT INTO clientes_deletados VALUES (id, nome, status);
        END $$
        delimiter ;
	CALL contas_deletadas (OLD.id_cliente, OLD.nome, OLD.status);

-- Segundo desafio
-- O erro 1442 pode ser causado pelo trigger estar modificando a tabela mais de uma vez
-- Para resolver o problema, use apenas o SET e não a cláusula UPDATE dentro do TRIGGER
delimiter $$
CREATE TRIGGER garantindo_que_nao_hajam_produtos_com_preco_nulo BEFORE INSERT ON shop.produto FOR EACH ROW
	BEGIN
		IF NEW.valor = 0.0 THEN
			SET NEW.valor = 100.0;
		END IF;
    END $$
    delimiter ;
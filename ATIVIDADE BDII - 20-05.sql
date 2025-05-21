-- 1º Relatório: Lista dos empregados admitidos entre 2019-01-01 e 2022-03-31... conforme atividade;

select upper(emp.nome) "Nome Empregado",
       emp.cpf "CPF Empregado",
       date_format(emp.dataAdm, '%d/%m/%Y') "Data de Admissão",
       concat("R$ ", format(emp.salario, 2, 'de_DE')) "Salário",
       dep.nome "Departamento",
       tel.numero "Número de Telefone"
from empregado emp
	inner join departamento dep on emp.Departamento_idDepartamento = dep.idDepartamento
		left join telefone tel on emp.cpf = tel.Empregado_cpf
			where emp.dataAdm between '2019-01-01' and '2022-03-31'
				order by emp.dataAdm desc;


-- 2º Relatório: Lista dos empregados que ganham menos que a média salarial dos funcionários do Petshop... conforme atividade;

select upper(emp.nome) "Nome Empregado",
       emp.cpf "CPF Empregado",
       date_format(emp.dataAdm, '%d/%m/%Y') "Data de Admissão",
       concat("R$ ", format(emp.salario, 2, 'de_DE')) "Salário",
       dep.nome "Departamento",
       tel.numero "Número de Telefone"
from empregado emp
	inner join departamento dep on emp.Departamento_idDepartamento = dep.idDepartamento
		left join telefone tel on emp.cpf = tel.Empregado_cpf
			where emp.salario <= (select avg(salario) from empregado)
				order by emp.nome;
            
-- 3º Relatório: Lista dos departamentos com a quantidade de empregados total por cada departamento... conforme atividade;

select dep.nome "Departamento",
       count(emp.cpf) "Quantidade de Empregados",
       concat("R$ ", format(avg(emp.salario), 2, 'de_DE')) "Média Salarial",
       concat("R$ ", format(avg(emp.comissao), 2, 'de_DE')) "Média Comissão"
from empregado emp
	inner join departamento dep on emp.Departamento_idDepartamento = dep.idDepartamento
		group by dep.idDepartamento, dep.nome
			order by dep.nome;
                
-- 4º Relatório: Lista dos empregados com a quantidade total de vendas já realiza por cada Empregado... conforme atividade;           

select upper(emp.nome) "Nome Empregado",
       emp.cpf "CPF Empregado",
       replace(replace(emp.sexo, 'F', "Feminino"), 'M', "Masculino") "Sexo",
       concat("R$ ", format(emp.salario, 2, 'de_DE')) "Salário",
       count(ven.idVenda) "Quantidade de Vendas",
       concat("R$ ", format(sum(ven.valor), 2, 'de_DE')) "Total Valor Vendido",
       concat("R$ ", format(sum(ven.comissao), 2, 'de_DE')) "Total Comissão das Vendas"
from empregado emp
	inner join venda ven on emp.cpf = ven.Empregado_cpf
		group by emp.cpf, emp.nome, emp.sexo, emp.salario
			order by count(ven.idVenda) desc;
            
-- 5º Relatório: Lista dos empregados que prestaram Serviço na venda computando a quantidade total de vendas realizadas com serviço por cada Empregado... conforme atividade;
 
select upper(emp.nome) "Nome Empregado",
       emp.cpf "CPF Empregado",
       replace(replace(emp.sexo, 'F', "Feminino"), 'M', "Masculino") "Sexo",
       concat("R$ ", format(emp.salario, 2, 'de_DE')) "Salário",
       count(ItServ.quantidade) "Quantidade Vendas com Serviço",
       concat("R$ ", format(sum(ItServ.valor), 2, 'de_DE')) "Total Valor Vendido com Serviço",
       concat("R$ ", format(sum(ven.comissao), 2, 'de_DE')) "Total Comissão das Vendas com Serviço"
from empregado emp 
	inner join venda ven on ven.Empregado_cpf = emp.cpf
		inner join itensservico ItServ on ItServ.Venda_idVenda = ven.idVenda
			group by emp.cpf, emp.nome
				order by count(ven.idVenda) desc;
    
-- 6º Relatório: Lista dos serviços já realizados por um Pet... conforme atividade;

select pet.nome "Nome do Pet",
       date_format(ven.data, '%d/%m/%Y') "Data do Serviço",
       srv.nome "Nome do Serviço",
       ItServ.quantidade "Quantidade",
       concat("R$ ", format(ItServ.valor, 2, 'de_DE')) "Valor",
       emp.nome "Empregado que realizou o Serviço"
from itensservico ItServ
	inner join pet pet on idPET = PET_idPET
		inner join servico srv on idServico = Servico_idServico
			inner join empregado emp on cpf = Empregado_cpf
				inner join venda ven on idVenda = Venda_idVenda
					order by ven.data desc;
                
-- 7º Relatório: Lista das vendas já realizados para um Cliente... conforme atividade;  

select date_format(ven.data, '%d/%m/%Y') "Data da Venda",
       concat("R$ ", format(ven.valor, 2, 'de_DE')) "Valor",
       concat("R$ ", format(ven.desconto, 2, 'de_DE')) "Desconto",
       concat("R$ ", format(ven.valor - ven.desconto, 2, 'de_DE')) "Valor Final",
       emp.nome "Empregado que realizou a venda"
from venda ven
	inner join empregado emp on emp.cpf = ven.Empregado_cpf
		inner join cliente cli on cli.cpf = ven.Cliente_cpf
			order by ven.data desc;
            
-- 8º Relatório: Lista dos 10 serviços mais vendidos... conforme atividade;

select srv.nome "Nome do Serviço",
       sum(ItServ.quantidade) "Quantidade Vendas",
       concat("R$ ", format(sum(ItServ.valor), 2, 'de_DE')) "Total Valor Vendido"
from itensservico ItServ
	inner join servico srv on srv.idServico = ItServ.Servico_idServico
		group by srv.nome
			order by `Quantidade Vendas` desc
				limit 10;


-- 9º Relatório: Lista das formas de pagamentos mais utilizadas nas Vendas... conforme atividade;

select fpc.tipo "Tipo Forma Pagamento",
       count(ItCom.quantidade) "Quantidade Vendas",
       sum(fpc.valorPago) "Total Valor Vendido"
from compras cop
inner join formapagcompra fpc on fpc.Compras_idCompra = idCompra
inner join itenscompra ItCom on ItCom.Compras_idCompra = idCompra
group by fpc.tipo
order by `Quantidade Vendas` desc;
    
-- 10º Relatório: Balaço das Vendas, informando a soma dos valores vendidos por dia... conforme atividade;;
    
select date_format(data, '%d/%m/%Y') "Data Venda",
       count(idVenda) "Quantidade de Vendas",
       sum(valor) "Valor Total Venda"
from venda
group by data
order by data desc;
            
-- 11º Relatório: Lista dos Produtos, informando qual Fornecedor de cada produto... conforme atividade;

select prt.nome "Nome Produto",
       concat("R$ ", format(prt.valorVenda, 2, 'de_DE')) "Valor Produto",
       "_" "Categoria do Produto - Não tem",
       forn.nome "Nome Fornecedor",
       forn.email "Email Fornecedor",
       tel.numero "Telefone Fornecedor"
from produtos prt
	inner join itenscompra ic on Produtos_idProduto = idProduto
		inner join compras c on c.idCompra = ic.Compras_idCompra
			inner join fornecedor forn on c.Fornecedor_cpf_cnpj = forn.cpf_cnpj
				left join telefone tel on forn.cpf_cnpj = tel.Fornecedor_cpf_cnpj
					order by prt.nome;

-- 12º Relatório: Lista dos Produtos mais vendidos... conforme atividade;

select prt.nome "Nome Produto",
       sum(ivp.quantidade) "Quantidade (Total) Vendas",
       concat("R$ ", format(sum(ivp.valor), 2, 'de_DE')) "Valor Total Recebido pela Venda do Produto"
from produtos prt
	inner join itensvendaprod ivp on prt.idProduto = ivp.Produto_idProduto
		group by prt.idProduto, prt.nome
			order by `Quantidade (Total) Vendas` desc;
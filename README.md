# Projeto Lógico de Banco de Dados - E-commerce

## Descrição do Projeto
Este repositório contém a modelagem lógica e o script SQL de um banco de dados para um cenário de E-commerce. O projeto foi desenvolvido como parte de um desafio de modelagem, partindo de um esquema EER básico e aplicando refinamentos para aproximar o modelo de um cenário real.

## Refinamentos Aplicados
Com base no modelo inicial, as seguintes regras de negócio foram implementadas no mapeamento lógico:
1. **Cliente PJ e PF:** A entidade `Cliente` foi especializada. Uma conta de cliente armazena os dados básicos e possui um relacionamento obrigatório com `Cliente_PF` (Pessoa Física, com CPF) ou `Cliente_PJ` (Pessoa Jurídica, com CNPJ), garantindo que não haja duplicidade ou mistura de dados.
2. **Múltiplas Formas de Pagamento:** Foi criada a entidade `Forma_Pagamento` (1:N com `Cliente`), permitindo que um mesmo cliente cadastre e utilize cartões, PIX ou boletos de forma independente.
3. **Gestão de Entrega:** Adicionada a entidade `Entrega` vinculada ao `Pedido`, contendo atributos de `status_entrega` e `codigo_rastreio` para acompanhamento logístico.

## Consultas (Queries) Implementadas
O script de testes incluído neste repositório responde às seguintes perguntas de negócio utilizando cláusulas complexas (JOINs, GROUP BY, HAVING, atributos derivados, etc.):
* Quantos pedidos foram feitos por cada cliente?
* Algum vendedor terceirizado também é fornecedor do e-commerce?
* Qual a relação completa de produtos, fornecedores e níveis de estoque?
* Qual o valor total de cada pedido (cálculo de atributo derivado multiplicando quantidade pelo preço)?

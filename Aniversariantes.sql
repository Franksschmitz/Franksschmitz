select
	x.codigo,
	x.nome,
	x.cpf,
	'(' || x.codarea || ')' as CDA,
	x.telefone,
	'(' || x.codareacel || ')' as CDACEL,
	x.celular,
	x.tag,
        x.cadastro,
	x.aniversario
from (  select 
			a.id_entidade as CODIGO,
			a.ds_entidade as NOME, 
			a.ds_cpfcnpj as CPF,
			c.ds_codarea as CODAREA,
			c.ds_fone as TELEFONE,
			c.ds_codareacel as CODAREACEL,
			c.ds_celular as CELULAR,
			b.nr_tag as TAG, 
                        cast(a.dt_cadastro as date) as CADASTRO,
			 CAST(LPAD(CAST(extract(day from a.dt_nascfund) AS VARCHAR(2)), 2, '0') || '/' || LPAD(CAST(extract(month from a.dt_nascfund) AS VARCHAR(2)), 2, '0') || '/' || extract(year from current_date) AS DATE) as ANIVERSARIO
		from entidade a
		left join rfid b on (a.id_entidade = b.id_entidade)
		left join entidade_contato c on (a.id_entidade = c.id_entidade)
			where a.ch_pessoa = 'F'
			and a.ch_ativo = 'T'
			and a.ch_excluido is null 
			and a.dt_nascfund is not null

		{if param_GrupoEntidade} and a.id_grupoentidade in (:GrupoEntidade) {endif}
		{if param_entidade} and a.id_entidade in (:Entidade) {endif}
		{if param_cadastro_ini} and a.dt_cadastro between :cadastro_ini and :ate {endif}

	) x
	
	{if param_emissao_ini} where x.aniversario between :emissao_ini and :emissao_fim {endif}

	{if param_ordem_Entidade} order by x.nome {endif}
	{if param_ordem_Data} order by x.aniversario {endif}
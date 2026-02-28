cols_filter = set(df_filter.columns)
cols_teste  = set(df_teste.columns)

colunas_em_comum = sorted(cols_filter & cols_teste)
somente_filter = sorted(cols_filter - cols_teste)
somente_teste = sorted(cols_teste - cols_filter)

print(f"📊 Colunas em comum ({len(colunas_em_comum)}):")
print(colunas_em_comum)

print(f"\n❌ Só no df_filter ({len(somente_filter)}):")
print(somente_filter)

print(f"\n⚠️ Só no df_teste ({len(somente_teste)}):")
print(somente_teste)

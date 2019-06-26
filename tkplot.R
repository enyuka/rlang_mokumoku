library(RMeCab)
# バイグラム分割している
m = NgramDF("/Users/nishiguchi/dev/rlang_mokumoku/sample_texts/dokuhaku.txt", type = 1, pos = c("名詞", "形容詞", "動詞"))
library(dplyr)
# 出現頻度でフィルターをかけて、m.df変数に入れる（dfはDataFrame)
m.df = m %>% filter(Freq > 1)

#library(igraph)
#m.g = graph.data.frame(m.df)
#E(m.g)$weight = m.df[,3]
#tkplot(m.g, vertex.label = V(m.g)$name, edge.label = E(m.g)$weight, vertex.size = 23, vertex.color ="SkyBlue")
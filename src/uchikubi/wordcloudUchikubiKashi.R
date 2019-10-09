# devtools::install_github("bmschmidt/wordVectors")
library(RMeCab)
library(wordcloud)
library(dplyr)

# 文字化け対策
par(family = "HiraKakuProN-W3")

# 分かち書き
rmecab_result = docDF(uchikubi_kashi_df, col = 2, type = 1)
# 数や非自立などの単語を除外し、data.frameに代入
wordcloud_source = rmecab_result %>% filter(POS1 %in% c("名詞"), POS2 != "数", POS2 != "サ変接続", POS2 != "非自立", TERM != ")", TERM != "(")

# kashi_freqは出現数の列を切り出し、sumしたdata.frame
kashi_freq = apply(wordcloud_source[, 4:ncol(wordcloud_source)], 1, sum)
wordcloud_source = data.frame(wordcloud_source, kashi_freq)
wordcloud(
  wordcloud_source$TERM,
  wordcloud_source$kashi_freq,
  min.freq = 5,
  random.order = FALSE,
  scale = c(6, .5),
  colors = brewer.pal(8, "Dark2")
)
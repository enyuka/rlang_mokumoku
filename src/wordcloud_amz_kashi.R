# devtools::install_github("bmschmidt/wordVectors")
library(RMeCab)
library(wordcloud)
library(dplyr)
# 文字化け対策
par(family = "HiraKakuProN-W3")
# 分かち書き
rmecab_result = docDF(url_df, col = 2, type = 1)
# 数や非自立などの単語を除外し、data.frameに代入
wordcloud_source = rmecab_result %>% filter(POS1 %in% c("名詞"), POS2 != "数", POS2 != "サ変接続", POS2 != "非自立", TERM != ")", TERM != "(")
# kashi_freqは上のrmecab_resultから出現数の部分のみを切り出したdata.frame(多分下のやつ・・・)。これに対して、行単位でsumを出している
# kashi_freq = wordcloud_source[, 4:120]
countdf = apply(kashi_freq, 1, sum)
# 歌詞と出現数をマージしたdata.frame。piyoは名前がいいの思いつかなかったので、なんかあとでリファクタリングする
piyo = data.frame(wordcloud_source, countdf)
wordcloud(piyo$TERM, piyo$countdf, min.freq = 5, scale = c(6,1), colors = brewer.pal(8,"Dark2"))
gc()
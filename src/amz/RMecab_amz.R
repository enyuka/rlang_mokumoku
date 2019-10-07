## 分かち書き処理の用意
library(RMeCab)
library(dplyr)
library(purrr)
library(wordVectors)

## 一時ファイルを用意
# 下記サイトを参照にコピペで挙動確認していた。
# https://qiita.com/rmecab/items/c165a67a2f02e76e8390
# 来週やることとして、url_dfっていう変数から歌詞を全部取り出して、1つのテキスト化。その後、それをRMecabして、word2vecに訓練させれば動きそう（多分）

## piyo$TERM
#   tf <- tempfile()
# RMeCabText(kenji) %>% map(function(x)
#   ifelse( (x[[2]] %in% c("名詞", "形容詞", "動詞"))  &&
#             (!x[[3]] %in% c("数", "非自立", "代名詞","接尾") ) && (x[[8]] != "*"),
#           x[[8]],  ""))  %>%  paste(" ", collapse = "") %>%
#   write(file = tf, append = TRUE)

## 生成されたファイルを確認するには
# file.show(tf)
getwd("~/dev/rlang_mokumoku/src/amz/")
file_name = "amz_all_kashi.txt"
all_kashi = ""
for (i in 1:(url_df$kashi %>% length())) {
  all_kashi = paste(all_kashi, url_df$kashi[i], sep = " ")
}
write.table(all_kashi, file_name, col.names = F, row.names = F)

rmecab_result_text = ""
rmecab_result = RMeCabText(file_name)
for (i in 1:(rmecab_result %>% length())) {
  tmp_rmecab_result = rmecab_result[[i]]
  if (tmp_rmecab_result[2] %in% c("名詞", "動詞", "形容詞") && tmp_rmecab_result[3] != "記号" && tmp_rmecab_result[3] != "非自立") {
    rmecab_result_text = paste(rmecab_result_text, as.character(tmp_rmecab_result[1]), sep = " ")
  }
}
write(rmecab_result_text, file = "rmecab_text_amz_list.bin", append = TRUE)

model_amz = train_word2vec("rmecab_text_amz_list.bin", vectors = 1000, window = 4, threads = 2)
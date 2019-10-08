library(RMeCab)
library(dplyr)
library(purrr)
library(wordVectors)

setwd("~/dev/rlang_mokumoku/src/amz/")
file_name = "amz_all_kashi.txt"
all_kashi = ""

for (i in 1:(kashi_df$kashi %>% length())) {
  all_kashi = paste(all_kashi, kashi_df$kashi[i], sep = " ")
}
write.table(all_kashi, file_name, col.names = FALSE, row.names = FALSE)

rmecab_result_text = ""
rmecab_result = RMeCabText(file_name)
for (i in 1:(rmecab_result %>% length())) {
  tmp_rmecab_result = rmecab_result[[i]]
  if (tmp_rmecab_result[2] %in% c("名詞", "動詞", "形容詞") && tmp_rmecab_result[3] != "記号" && tmp_rmecab_result[3] != "非自立") {
    rmecab_result_text = paste(rmecab_result_text, as.character(tmp_rmecab_result[1]), sep = " ")
  }
}
write(rmecab_result_text, file = "rmecab_text_amz_list.bin", append = FALSE)

model_amz = train_word2vec("rmecab_text_amz_list.bin", vectors = 1000, window = 4, threads = 2)
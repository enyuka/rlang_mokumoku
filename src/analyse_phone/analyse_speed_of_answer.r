library(tidyverse)
library(ggplot2)

setwd("~/dev/rlang_mokumoku/src/analyse_phone/data/")
dirs = list.dirs(".")

df = NULL

# 2にしてるのはdirsで取得するとカレントディレクトリ(.)も取得されるため、それをスキップしている
for (i in 2:length(dirs)) {
  dir_name = dirs[i]
  # ディレクトリ名が./0701_0702という形式で取得されるため
  date = substr(dir_name, 3, 6)
  
  files = list.files(dir_name, full.names = FALSE)
  for (j in 1:length(files)) {
    filename = files[j]
    # 指定したcsvからデータ読み込み。平均対応時間（単位：秒）を取得
    x = read_csv(paste(dir_name, "/", filename, sep = ""), col_names = FALSE)
    colnames(x) = c("conference_sid", "sec")
    
    # ファイル名が+8150xxxxyyyy.csv形式のためわかりやすい番号形式に置換
    phonenumber = sub("\\+81", "0", str_sub(filename, end = -5))
    df = rbind(df, c(date, as.numeric(round(mean(x$sec))) , phonenumber))
  }
}
colnames(df) = c("date", "sec", "phonenumber")

# rbindしてもなぜかcharacterのVectorになるので、data.frameにキャストする
df = as.data.frame(df)
# data.frameキャストすると、なぜかsecがfactorになるので、numericにキャストする
df$sec = as.numeric(as.character(df$sec))

ggplot(data=as.data.frame(df), aes(x=date, y=sec, color=phonenumber)) +
  geom_tile(aes(fill = phonenumber)) +
  geom_text(aes(label = sec), color = "white")
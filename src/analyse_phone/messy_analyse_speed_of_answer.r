library(tidyverse)
library(ggplot2)
library(hash)

setwd("/Users/nishiguchi/dev/analyse_speed_of_answer/")
dirs = list.dirs(".")
results = hash()
filenames = list()
mean_secs = list()

# data.frameを設定するが、初回空のdata.frameにbindするとエラーが出るため、一旦NULLを設定しておく
# 参照： http://webbeginner.hatenablog.com/entry/2015/02/06/132256
df = NULL

for (i in 2:length(dirs)) {
  # 2にしてるのはdirsで取得するとカレントディレクトリ(.)も取得されるため、それをスキップしている
  files = list.files(dirs[i], full.names = FALSE)
  for (j in 1:length(files)) {
    # 考え方を変えて、列のベクトルを先に作り、都度必要なだけNAを追加して行数を合わせていく。最後、cbindでゴリゴリくっつけていく
    filename = files[j]
    if (!has.key(filename, results)) {
      # なぜかNAを入れないと、取得に失敗するため、とりあえずNAを入れておく
      results[filename] = c(NA)
    }
    
    # 指定したcsvからデータ読み込み。平均対応時間（単位：秒）を取得
    x = read_csv(paste(dirs[i], "/", files[j], sep = ""), col_names = FALSE)
    colnames(x) = c("conference_sid", "sec")
    filename_vector = results[[filename]]
    # 1を引いているのは、カレントディレクトリを除外しているため、本来のディレクトリ数とずれているのを調整している
    filename_vector[i - 1] = mean(x$sec)
    results[filename] = filename_vector
  }
}

keys = keys(results)
for (i in 1:length(keys)) {
  key = keys[i]
  df = cbind(df, results[[key]])
}
# cbindで渡す列名に変数を設定できないので、後から設定している
colnames(df) = keys

ggplot(df, aes(x,y))

# TODO 取得した平均値をggplot2のgeom_tileでなんないい感じにヒートマップで出す
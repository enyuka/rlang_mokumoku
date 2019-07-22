library(rvest)
library(stringr)

rm(url_df)
for (i in 1:length(urls)) {
  if (grepl("/song", urls[i])) {
    # 歌詞のページ
    html_i = read_html(paste("https://www.uta-net.com/", urls[i], sep = ""))
    # 歌詞のDOMを取得
    kashi_area = html_nodes(html_i, "#kashi_area")
    kashi_i = kashi_area %>% html_text()
    
    # 歌の発売日DOMを取得
    hatsubaibi_area = html_nodes(html_i, "#view_amazon")
    hatsubaibi_i = hatsubaibi_area %>% html_text()
    hatsubaibi = str_extract(hatsubaibi_i, pattern = "\\d{4}-\\d{2}-\\d{2}")
    hatsubaibi_split = str_split(hatsubaibi, pattern = "-")
    
    # 歌のタイトル
    title_i = texts[i]
    if (title_i == '夏の日、残像') {
      # TODO どちらかというと、作詞者列が秋田ひろむじゃなかったらnextのほうが意味合い的に正しい
      # この曲はアジカンカバー曲なので除外
      next;
    }
    
    url_df_i = data.frame(title = title_i, kashi = kashi_i, hatsubaibi_year = hatsubaibi_split[[1]][1], hatsubaibi_month = hatsubaibi_split[[1]][2], hatsubaibi_day = hatsubaibi_split[[1]][3])
    if (i == 1) {
      url_df = url_df_i
    } else {
      url_df = rbind(url_df, url_df_i)
    }
    # 良心
    Sys.sleep(1)
  }
}
library(rvest)
library(stringr)

amz_kashi_url = "https://www.uta-net.com/search/?Keyword=amazarashi"
url_trs =
  read_html(amz_kashi_url, encoding = "UTF-8") %>%
  html_nodes("tbody > tr")
url_df = NULL

for (i in 1:length(url_trs)) {
  tr = url_trs[i]
  songwriter = html_nodes(tr, ".td3") %>% html_text()
  if (!grepl("秋田ひろむ", songwriter)) {
    # 秋田さん以外の曲は飛ばす
    next
  }
  title_node = html_nodes(tr, ".td1")
  title_text = title_node %>% html_text()
  song_url = html_node(title_node, "a") %>% html_attr("href")
  target_url = paste("https://www.uta-net.com", song_url, sep = "")
  
  # 歌詞のページ
  kashi_html = read_html(target_url)
  
  # 歌詞を取得
  kashi_text = html_nodes(kashi_html, "#kashi_area") %>% html_text()
  
  # 歌の発売日DOMを取得
  hatsubaibi_split =
    html_nodes(kashi_html, "#view_amazon") %>%
    html_text() %>%
    str_extract(pattern = "\\d{4}-\\d{2}-\\d{2}") %>%
    str_split(pattern = "-")
  
  url_df_i = data.frame(
    title = title_text,
    kashi = kashi_text,
    hatsubaibi_year = hatsubaibi_split[[1]][1],
    hatsubaibi_month = hatsubaibi_split[[1]][2],
    hatsubaibi_day = hatsubaibi_split[[1]][3]
  )
  url_df = rbind(url_df, url_df_i)
  
  # 良心
  Sys.sleep(1)
}
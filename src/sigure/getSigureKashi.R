library(rvest)
library(stringr)

amz_kashi_url = "https://www.uta-net.com/search/?Keyword=凛として時雨"
trs =
  read_html(amz_kashi_url, encoding = "UTF-8") %>%
  html_nodes("tbody > tr")
sigure_kashi_df = NULL

for (i in 1:length(trs)) {
  tr = trs[i]
  # 曲名取得
  title_node = html_nodes(tr, ".td1")
  title_text = title_node %>% html_text()
  
  # html_node"s"じゃなくて、html_nodeなのは該当のtd配下に王冠アイコンがあって、
  # 歌詞とは別のリンクが埋め込まれているから、1つ目だけを取得
  song_url = html_node(title_node, "a") %>% html_attr("href")
  target_url = paste("https://www.uta-net.com", song_url, sep = "")
  
  # 歌詞のページ
  kashi_html = read_html(target_url)
  
  # 歌詞を取得
  kashi_text = html_nodes(kashi_html, "#kashi_area") %>% html_text()
  
  # 曲の発売日を取得し、年、月、日で分割しておく
  hatsubaibi_split =
    html_nodes(kashi_html, "#view_amazon") %>%
    html_text() %>%
    str_extract(pattern = "\\d{4}-\\d{2}-\\d{2}") %>%
    str_split(pattern = "-")
  
  temp_df = data.frame(
    title = title_text,
    kashi = kashi_text,
    hatsubaibi_year = hatsubaibi_split[[1]][1],
    hatsubaibi_month = hatsubaibi_split[[1]][2],
    hatsubaibi_day = hatsubaibi_split[[1]][3]
  )
  sigure_kashi_df = rbind(sigure_kashi_df, temp_df)
  
  # 良心
  Sys.sleep(1)
}
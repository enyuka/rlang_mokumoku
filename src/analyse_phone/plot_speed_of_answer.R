ggplot(data=as.data.frame(df), aes(x=date, y=sec, color=phonenumber)) +
  geom_tile(aes(fill = phonenumber)) +
  geom_text(aes(label = sec), color = "white")
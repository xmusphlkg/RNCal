observeEvent(input$input_rawdata,{
     file <- input$input_rawdata
     DF <- read.xlsx(file$datapath)
     names(DF)[1] <- '发病日期'
     DF$发病日期 <- convertToDate(DF$发病日期)
     if(ncol(DF) == 1){
          DF$分类 <- 'A'
     } else {
          names(DF)[2] <- '分类'
     }
     output$data_raw <- renderRHandsontable({
          rhandsontable(DF, language = 'zh-CN') %>% 
               hot_context_menu(allowColEdit = FALSE, allowRowEdit = TRUE)
     })
})

observeEvent(input$input_transdata,{
     file <- input$input_transdata
     DF <- read.xlsx(file$datapath)
     names(DF)[1:2] <- c('发病日期', '数量')
     DF$发病日期 <- convertToDate(DF$发病日期)
     DF$数量 <- as.numeric(DF$数量)
     if(ncol(DF) == 2){
          DF$分类 <- 'A'
     } else {
          names(DF)[3] <- '分类'
     }
     output$data_input <- renderRHandsontable({
          rhandsontable(DF, language = 'zh-CN') %>% 
               hot_context_menu(allowColEdit = FALSE, allowRowEdit = TRUE)
     })
})

output$data_raw <- renderRHandsontable({
     DF <- data.frame(
          发病日期 = sample(seq(from = Sys.Date()-10, by = "days", length.out = 5), 10, replace = T),
          分类 = sample(x = c('A', 'B'), 10 , replace = T)
     )
     rhandsontable(DF, language = 'zh-CN') %>% 
          hot_context_menu(allowColEdit = FALSE, allowRowEdit = TRUE)
})

output$data_input <- renderRHandsontable({
     DF <- data.frame(
          发病日期 = seq(from = Sys.Date()-20, by = "days", length.out = 15),
          数量 = sample(x = 1:10, size = 15, replace = TRUE),
          分类 = sample(x = c('A', 'B'), 15 , replace = T)
     )
     rhandsontable(DF, language = 'zh-CN') %>% 
          hot_context_menu(allowColEdit = FALSE, allowRowEdit = TRUE)
})

observeEvent(input$trans_raw,{
     DF <- hot_to_r(input$data_raw)
     names(DF) <- c('onset', 'type')
     datafile <- DF %>% 
          group_by(onset, type) %>% 
          drop_na() %>% 
          summarise(
               X = n()
          ) %>% 
          ungroup()
     values$df_global <- datafile %>% 
          complete(onset = seq.Date(from = min(onset, na.rm = T), 
                                    to = max(onset, na.rm = T), 
                                    by = 'day'),
                   type = unique(type),
                   fill = list(X = 0))
     
     output$data_input <- renderRHandsontable({
          DF <- datafile[, c('onset', 'X', 'type')]
          names(DF) <- c('发病日期', '数量', '分类')
          rhandsontable(DF, language = 'zh-CN') %>% 
               hot_context_menu(allowColEdit = FALSE, allowRowEdit = TRUE)
     })
})

observeEvent(input$trans_input,{
     DF <- hot_to_r(input$data_input)
     ## date modify
     names(DF) = c('t', 'X', 'type')
     df <- DF %>% 
          arrange(t) %>% 
          drop_na() %>% 
          filter(t >= min(DF[DF$X > 0,1], na.rm = T)) %>% 
          complete(t = seq.Date(from = min(t, na.rm = T), 
                                to = max(t, na.rm = T), 
                                by = 'day'),
                   type = unique(type),
                   fill = list(X = 0))
     values$df_global <- df
     
     datafile <- df[rep(row.names(df), df$X), 1:2] %>% 
          rename(c('onset' = 't')) %>% 
          mutate(type = as.factor(type))
     values$df_plot <- datafile
     ## define date_breaks
     if(as.numeric(max(datafile$onset) - min(datafile$onset)) < 30){
          date_breaks<- '3 days'
          date_add <- 2
     } else if (as.numeric(max(datafile$onset) - min(datafile$onset)) < 90 ) {
          date_breaks<- 'weeks'
          date_add <- 3
     } else if (as.numeric(max(datafile$onset) - min(datafile$onset)) < 180) {
          date_breaks<- '2 weeks'
          date_add <- 7
     } else if (as.numeric(max(datafile$onset) - min(datafile$onset)) < 365) {
          date_breaks<- 'months'
          date_add <- 10
     } else {
          date_breaks<- '2 months'
          date_add <- 30
     }
     
     values$date_breaks <- date_breaks
     # print(values$date_breaks)
     
     ## y axis round
     integer_breaks <- function(n = 5, ...) {
          fxn <- function(x) {
               breaks <- floor(pretty(x, n, ...))
               names(breaks) <- attr(breaks, "labels")
               breaks
          }
          return(fxn)
     }
     
     fig <- ggplot(data = datafile) +          # set data
          geom_histogram(                      # add histogram
               mapping = aes(
                    x = onset,
                    group = type,
                    fill = type),     # map date column to x-axis
               binwidth = 1,
               color = 'white')+                     # cases binned by 1 day
          scale_x_date(
               expand = c(0, 0),
               limits = c(min(df$t)-3, max(df$t)+date_add),
               date_breaks = date_breaks,
               labels = function(x) if_else(is.na(lag(x)) | !year(lag(x)) == year(x),
                                            paste0(month(x),'/' , day(x), "\n", year(x)),
                                            paste0(month(x), '/' , day(x)))
          )+
          scale_fill_brewer(palette = "Paired")+ 
          scale_y_continuous(
               expand = expansion(mult = c(0, 0.1)),
               breaks = integer_breaks()
          )+
          theme_set()+
          labs(
               x = 'Onset date',
               y = 'Cases'
          )
     if (length(unique(datafile$type)) == 1){
          fig <- fig + guides(fill = 'none') 
     }
     
     figs$fig_epicurve <- fig
     
     output$data_preview <- renderPlot({
          fig
     })
})

observeEvent(input$Epicurve_download,{
     if (!is.null(values$df_plot)){
          showModal(
               modalDialog(
                    fluidRow(
                         column(
                              width = 12,
                              align = "center",
                              downloadButton(
                                   "download_epicurve_png",
                                   "下载流行曲线(png)",
                                   icon = icon("file-image"),
                                   class = 'butt'
                              )
                         )
                    ),
                    br(),
                    fluidRow(
                         column(
                              width = 12,
                              align = "center",
                              downloadButton(
                                   "download_epicurve_tiff",
                                   "下载流行曲线(tiff)",
                                   icon = icon("file-image"),
                                   class = 'butt'
                              )
                         )
                    ),
                    br(),
                    fluidRow(
                         column(
                              width = 12,
                              align = "center",
                              downloadButton(
                                   "download_epicurve_pdf",
                                   "下载流行曲线(PDF)",
                                   icon = icon("file-pdf"),
                                   class = 'butt'
                              )
                         )
                    ),
                    br(),
                    fluidRow(
                         column(
                              width = 12,
                              align = "center",
                              downloadButton(
                                   "download_epicurve_csv",
                                   "下载绘图数据(csv)",
                                   icon = icon("file-excel"),
                                   class = 'butt'
                              )
                         )
                    ),
                    title = "下载",
                    size = "s",
                    footer = list(
                         modalButton("取消")
                    )
               )
          )
          
          output$download_epicurve_csv <- downloadHandler(
               filename = function(){
                    paste0("Epicurve", Sys.Date(), ".csv")
               },
               content = function(file) {
                    write.csv(values$df_plot, file, row.names = FALSE)
               }
          )
          
          output$download_epicurve_png <- downloadHandler(
               filename = function(){
                    paste0("Epicurve", Sys.Date(), ".png")
               },
               content = function(file) {
                    ggsave(file, plot = figs$fig_epicurve, device = 'png')
               }
          )
          
          output$download_epicurve_tiff <- downloadHandler(
               filename = function(){
                    paste0("Epicurve", Sys.Date(), ".tiff")
               },
               content = function(file) {
                    ggsave(file, plot = figs$fig_epicurve, device = 'tiff')
               }
          )
          
          output$download_epicurve_pdf <- downloadHandler(
               filename = function(){
                    paste0("Epicurve", Sys.Date(), ".pdf")
               },
               content = function(file) {
                    pdf(file)
                    print(figs$fig_epicurve)
                    dev.off()
               }
          )
          
     } else {
          shinyalert("提交失败", '没找到数据, 请点击“数据预览”按钮并出现流行曲线后再试~', 
                     timer = 5000 , 
                     type = "error",
                     size = 'xs')
     }
})
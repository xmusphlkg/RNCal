


# R0 ----------------------------------------------------------------------

output$R0_gt_data_detail_2 <- renderRHandsontable({
  DF <- data.frame(
    "传染者发病时间" = rep(0, length(H1N1.serial.interval)),
    "感染者发病时间" = H1N1.serial.interval
  )
  rhandsontable(DF, language = "zh-CN") |> 
    hot_context_menu(allowColEdit = FALSE, allowRowEdit = TRUE) |> 
    hot_cols(colWidths = 130, format = "0")
})

output$R0_gt_data_gt_empirical_2 <- renderRHandsontable({
  DF <- data.frame("分布概率" = c(0, 0.25, 0.2, 0.15, 0.1, 0.09, 0.05, 0.01))
  rhandsontable(DF, language = "zh-CN") |> 
    hot_context_menu(allowColEdit = FALSE, allowRowEdit = TRUE) |> 
    hot_cols(colWidths = 130, format = "0")
})

output$R0_gt_data_si_2 <- renderRHandsontable({
  DF <- as.data.frame(table(H1N1.serial.interval))
  names(DF) <- c("Serial interval", "Freq")
  rhandsontable(DF, language = "zh-CN") |> 
    hot_context_menu(allowColEdit = FALSE, allowRowEdit = TRUE)
})

observeEvent(input$R0_gt_data_confirmed_2, {
  tryCatch(
    {
      # 封装数据处理逻辑
      processInputData1 <- function(inputType) {
        switch(inputType,
               "SI" = {
                 df <- hot_to_r(input$R0_gt_data_si_2)
                 df <- df[rep(row.names(df), df$Freq), 1]
                 suppressMessages(suppressWarnings(est.GT(serial.interval = as.numeric(df))))
               },
               "detail" = {
                 df <- hot_to_r(input$R0_gt_data_detail_2)
                 suppressMessages(suppressWarnings(
                   est.GT(
                     infector.onset.dates = df$传染者发病时间,
                     infectee.onset.dates = df$感染者发病时间
                   )
                 ))
               },
               "GT" = {
                 df <- switch(input$R0_gt_data_gt_type_3,
                              "empirical" = as.numeric(
                                hot_to_r(input$R0_gt_data_gt_empirical_2)[, 1]
                              ),
                              "gamma" = c(
                                input$R0_gt_data_gt_gamma_shape_1,
                                input$R0_gt_data_gt_gamma_scale_1
                              ),
                              "weibull" = c(
                                input$R0_gt_data_gt_weibull_shape_1,
                                input$R0_gt_data_gt_weibull_scale_1
                              ),
                              "lognormal" = c(
                                input$R0_gt_data_gt_lognormal_meanlog_1,
                                input$R0_gt_data_gt_lognormal_sdlog_1
                              ),
                              stop("未知的GT类型", call. = FALSE)
                 )
                 if (length(df) == 0) stop("关键参数缺失！", call. = FALSE)
                 suppressMessages(suppressWarnings(
                   generation.time(
                     type = input$R0_gt_data_gt_type_3,
                     val = as.numeric(df)
                   )
                 ))
               },
               stop("未知的输入类型", call. = FALSE)
        )
      }
      
      # 处理数据
      df_gt <- processInputData1(input$R0_gt_input_type_2)
      
      # 更新UI
      values$R0_gt <- df_gt
      output$R0_gt_data_2 <- renderPrint(print(df_gt))
    },
    error = function(e) {
      # 错误处理
      shinyalert(
        "提交失败",
        paste("原因：", e$message),
        timer = 5000,
        type = "error",
        size = "xs"
      )
    }
  )
})

observeEvent(input$R0_Rt_confirmed, {
  tryCatch(
    {
      # 输入验证
      begin <- input$R0_Rt_est_begin
      end <- input$R0_Rt_est_end
      validate(
        need(!is.na(begin) & !is.na(end), "开始和(或)结束时间点缺失！")
      )
      
      # 确保values$R0_gt已经计算
      if (is.null(values$R0_gt)) {
        stop("代际尚未设置", call. = FALSE)
      }
      
      # 数据处理
      df <- values$df_plot |> 
        group_by(onset) |> 
        summarise(X = n())
      
      if (nrow(df) < end) {
        stop("结束时间点过长！", call. = FALSE)
      } else {
        df_value <- df$X
        names(df_value) <- df$onset
      }
      # browser()
      
      # 封装估计Rt的逻辑
      estimateRt <- function(estimationFunction, data, gt, begin, end, ...) {
        switch(estimationFunction,
               "TD" = {
                 df_Rt <- est.R0.TD(data, gt, begin = begin, end = end, ...)
                 # 更新UI
                 output$R0_est_Rt <- renderPrint(print(df_Rt))
                 datafile <- data.frame(
                   date = as.Date(names(df_Rt$R)),
                   Rt = df_Rt$R,
                   Rt_lower = df_Rt$conf.int$lower,
                   Rt_upper = df_Rt$conf.int$upper
                 )
                 datafile
               },
               "SB" = {
                 df_Rt <- est.R0.SB(data, gt, begin = start, end = stop, ...)
                 # 更新UI
                 output$R0_est_Rt <- renderPrint(print(df_Rt))
                 datafile <- data.frame(
                   date = as.Date(rownames(df_Rt$conf.int)),
                   Rt = df_Rt$R,
                   Rt_lower = df_Rt$conf.int$CI.lower.,
                   Rt_upper = df_Rt$conf.int$CI.upper.
                 )
                 datafile
               },
               stop("未知的估计函数", call. = FALSE)
        )
      }
      
      # 计算Rt
      gt <- values$R0_gt
      df_Rt <- estimateRt(input$R0_Rt_est_function, df_value, gt, begin, end)
      
      # 生成figure
      # browser()
      date_breaks <- values$date_breaks
      fig <- ggplot(data = df_Rt, mapping = aes(x = date)) +
        geom_ribbon(
          mapping = aes(
            ymin = Rt_lower,
            ymax = Rt_upper,
            fill = "red"
          ),
          alpha = 0.3,
          show.legend = F
        ) +
        geom_line(
          mapping = aes(y = Rt, color = "red"),
          size = 1,
          show.legend = F
        ) +
        geom_line(
          mapping = aes(y = 1),
          color = "black",
          size = 1,
          linetype = "dashed",
          show.legend = F
        ) +
        # geom_text(mapping = aes(x = max(date)+1, y = 1, label = 'R[t]==1.0'), parse=T)+
        annotate(
          "text",
          x = max(df_Rt$date),
          y = 1,
          size = 12 / .pt,
          label = expression(R[t] == 1),
          hjust = 0,
          fontface = "bold"
        ) +
        scale_x_date(
          expand = c(0, 0),
          date_labels = "%m/%d",
          date_breaks = date_breaks
        ) +
        scale_y_continuous(expand = c(0, 0)) +
        labs(x = "", y = expression(R[t])) +
        theme_set() +
        # theme(plot.margin=unit(c(1,3,1,1),'lines'))+
        coord_cartesian(clip = "off")
      
      figs$fig_Rt <- fig
      
      output$fig_R0_Rt <- renderPlot({
        fig
      })
      
      # 生成计算代码
      code_to_display <- paste0(
        "# 还在修改中", "\n\n",
        "# 设置代际时间\n",
        "type <-", input$R0_gt_input_type_2, "\n",
        "val <- ", deparse(values$R0_gt), "\n",
        "df_gt <- generation.time(type = type, val = val, step = step)\n\n",
        "# 设置病例数据\n",
        "df_value <- read.csv('test.csv', header = T)\n",
        "# 设置开始和结束时间\n",
        "begin <- ", deparse(begin), "\n",
        "end <- ", deparse(end), "\n\n",
        "# 估计R0\n",
        "df_R0 <- est.R0.", input$R0_Rt_est_function, "(df_value, df_gt, begin = begin, end = end)"
      )
      
      # 更新计算代码
      updateAceEditor(
        session,
        "code_editor_rt",
        value = code_to_display,
      )
    },
    error = function(e) {
      # 错误处理
      shinyalert(
        "提交失败",
        paste("原因：", e$message),
        timer = 5000,
        type = "error",
        size = "xs"
      )
    }
  )
})

# EpiEstim ----------------------------------------------------------------

values$R0_gt <- NULL

output$non_parametric_si_data <- renderRHandsontable({
  DF <- data.frame(
    天数 = 1:12,
    频数 = sample(1:5, size = 12, replace = T)
  )
  rhandsontable(DF, language = "zh-CN") |> 
    hot_context_menu(allowColEdit = FALSE, allowRowEdit = TRUE)
})

observeEvent(input$epiestim_parametric_si_data, {
  switch(input$epiestim_parametric_si_data,
         "Delta_广东" = {
           updateNumericInput(
             inputId = "epiestim_parametric_si_std",
             label = "代间距(SI)标准差",
             value = 3.4
           )
           updateNumericInput(
             inputId = "epiestim_parametric_si_mean",
             label = "代间距(SI)均数",
             value = 2.3
           )
         },
         "Delta_湖南" = {
           updateNumericInput(
             inputId = "epiestim_parametric_si_std",
             label = "代间距(SI)标准差",
             value = 5.7
           )
           updateNumericInput(
             inputId = "epiestim_parametric_si_mean",
             label = "代间距(SI)均数",
             value = 4.45
           )
         },
         "Omicron_BA1_珠海" = {
           updateNumericInput(
             inputId = "epiestim_parametric_si_std",
             label = "代间距(SI)标准差",
             value = 2.06
           )
           updateNumericInput(
             inputId = "epiestim_parametric_si_mean",
             label = "代间距(SI)均数",
             value = 3
           )
         },
         "Omicron_BA2_厦门" = {
           updateNumericInput(
             inputId = "epiestim_parametric_si_std",
             label = "代间距(SI)标准差",
             value = 1.26
           )
           updateNumericInput(
             inputId = "epiestim_parametric_si_mean",
             label = "代间距(SI)均数",
             value = 2.24
           )
         }
  )
})

observeEvent(input$rt_epiestim_gt_confirmed, {
  tryCatch({
    # 输入验证
    start_date <- as.numeric(input$epiestim_first)
    space_date <- as.numeric(input$epiestim_width)
    validate(
      need(!is.na(start_date) & !is.na(space_date), "开始和(或)时间间隔缺失！")
    )
    
    datafile <- values$df_global |> 
      group_by(t) |> 
      summarise(X = sum(X), .groups = "drop")
    names(datafile) <- c("dates", "I")
    date_st <- min(datafile$dates)
    start_dates <- seq(start_date, nrow(datafile) - space_date)
    end_dates <- start_dates + space_date
    # 确保日期序列是有效的
    if (length(start_dates) == 0 || any(start_dates <= 0) || any(end_dates > nrow(datafile))) {
      stop("日期序列无效。")
    }
    
    # 封装数据处理逻辑
    processInputData3 <- function(inputType) {
      switch(inputType,
             "non_parametric_si" = {
               si_distr <- hot_to_r(input$non_parametric_si_data)
               names(si_distr) <- c("n", "freq")
               si_distr <- si_distr |>
                 complete(
                   n = seq(min(n), max(n)),
                   fill = list(freq = 0)
                 ) |>
                 mutate(freq = freq / sum(freq))
               
               make_config(list(
                 si_distr = c(0, as.numeric(si_distr$freq)),
                 t_start = start_dates,
                 t_end = end_dates
               ))          
             },
             "parametric_si" = {
               mean_si <- input$epiestim_parametric_si_mean
               std_si <- input$epiestim_parametric_si_std
               # 输入验证
               validate(
                 need(!is.na(mean_si) & !is.na(std_si), "代间距(SI)参数缺失！")
               )
               
               make_config(list(
                 mean_si = mean_si,
                 std_si = std_si,
                 t_start = start_dates,
                 t_end = end_dates
               ))
             },
             'uncertain_si' ={
               mean_si <- input$epiestim_uncertain_si_mean_si
               std_mean_si <- input$epiestim_uncertain_si_std_mean_si
               min_mean_si <- input$epiestim_uncertain_si_min_mean_si
               max_mean_si <- input$epiestim_uncertain_si_max_mean_si
               std_si <- input$epiestim_uncertain_si_std_si
               std_std_si <- input$epiestim_uncertain_si_std_std_si
               min_std_si <- input$epiestim_uncertain_si_min_std_si
               max_std_si <- input$epiestim_uncertain_si_max_std_si
               n1 <- input$epiestim_uncertain_si_n1
               n2 <- input$epiestim_uncertain_si_n2
               
               # 输入验证
               validate(
                 need(
                   !is.na(mean_si) & !is.na(std_mean_si) & !is.na(min_mean_si) &
                     !is.na(max_mean_si) & !is.na(std_si) & !is.na(std_std_si) &
                     !is.na(min_std_si) & !is.na(max_std_si) & !is.na(n1) &
                     !is.na(n2),
                   "代间距(SI)参数缺失！"
                 )
               )
               make_config(
                 list(
                   t_start = start_dates,
                   t_end = end_dates,
                   mean_si = mean_si,
                   std_mean_si = std_mean_si,
                   min_mean_si = min_mean_si,
                   max_mean_si = max_mean_si,
                   std_si = std_si,
                   std_std_si = std_std_si,
                   min_std_si = min_std_si,
                   max_std_si = max_std_si,
                   n1 = n1,
                   n2 = n2
                 )
               )
             },
             stop("未知的输入类型", call. = FALSE)
      )
    }
    
    # 处理数据
    config <- processInputData3(input$epiestim_method)
    
    # 更新UI
    values$epiestim_config <- config
    output$epiestim_gt_data_1 <- renderPrint(print(config))
  },
  error = function(e) {
    # 错误处理
    shinyalert(
      "提交失败",
      paste("原因：", e$message),
      timer = 5000,
      type = "error",
      size = "xs"
    )
  }
  )
})

observeEvent(input$rt_epiestim_confirmed, {
  tryCatch({
    # 输入验证
    start_date <- as.numeric(input$epiestim_first)
    space_date <- as.numeric(input$epiestim_width)
    validate(
      need(!is.na(start_date) & !is.na(space_date), "开始和(或)时间间隔缺失！")
    )
    
    # 配置验证
    config_lit <- values$epiestim_config
    if(is.null(config_lit)) {
      stop("EpiEstim 配置缺失！")
    }
    datafile <- values$df_global |> 
      group_by(t) |> 
      summarise(X = sum(X), .groups = "drop")
    names(datafile) <- c("dates", "I")
    date_st <- min(datafile$dates)
    start_dates <- seq(start_date, nrow(datafile) - space_date)
    end_dates <- start_dates + space_date
    epiestim_res_lit <- estimate_R(
      incid = datafile,
      method = input$epiestim_method,
      config = config_lit
    )
    outcome <- epiestim_res_lit$R
    outcome$date <- (outcome$t_start + outcome$t_end) / 2 + date_st
    outcome$t_start <- date_st + outcome$t_start
    outcome$t_end <- date_st + outcome$t_end
    
    date_breaks <- values$date_breaks
    
    fig <- ggplot(data = outcome, mapping = aes(x = date)) +
      geom_ribbon(
        mapping = aes(
          ymin = `Quantile.0.025(R)`,
          ymax = `Quantile.0.975(R)`,
          fill = "red"
        ),
        alpha = 0.3,
        show.legend = F
      ) +
      geom_line(
        mapping = aes(y = `Median(R)`, color = "red"),
        linewidth = 1,
        show.legend = F
      ) +
      geom_line(
        mapping = aes(y = 1),
        color = "black",
        linewidth = 1,
        linetype = "dashed",
        show.legend = F
      ) +
      # geom_text(mapping = aes(x = max(date)+1, y = 1, label = 'R[t]==1.0'), parse=T)+
      annotate(
        "text",
        x = max(outcome$date),
        y = 1,
        size = 12 / .pt,
        label = expression(R[t] == 1),
        hjust = 0,
        fontface = "bold"
      ) +
      scale_x_date(
        expand = c(0, 0),
        date_labels = "%m/%d",
        date_breaks = date_breaks
      ) +
      scale_y_continuous(
        expand = expansion(mult = c(0, 0.1)),
        limits = c(0, NA)
      ) +
      labs(x = "", y = expression(R[t])) +
      theme_set() +
      # theme(plot.margin=unit(c(1,3,1,1),'lines'))+
      coord_cartesian(clip = "off")
    
    figs$fig_Rt <- fig
    values$df_Rt <- outcome
    output$fig_EpiEstim_Rt <- renderPlot({
      fig
    })
    
    
    # 更新计算代码
    code_to_display <- paste0(
      "# 还在修改中", "\n\n",
      "# 配置文件\n",
      "config_lit <-make_config(method = ", input$epiestim_method, "...)\n\n",
      "# 设置病例数据\n",
      "df_value <- read.csv('test.csv', header = T)\n",
      "# 估计Rt\n",
      "df_Rt <- estimate_R(df_value, ", input$epiestim_method, ", config = config_lit)"
    )
    
    # 更新计算代码
    updateAceEditor(
      session,
      "code_editor_rt_epiestim",
      value = code_to_display,
    )
  },
  error = function(e) {
    # 错误处理
    shinyalert(
      "提交失败",
      paste("原因：", e$message),
      timer = 5000,
      type = "error",
      size = "xs"
    )
  }
  )
})

# download button ---------------------------------------------------------

observeEvent(input$Rt_download, {
  if (!is.null(values$df_plot)) {
    showModal(
      modalDialog(
        fluidRow(column(
          width = 12,
          align = "center",
          downloadButton(
            "download_Rt_png",
            "下载结果(png)",
            icon = icon("file-image"),
            class = "butt"
          )
        )),
        br(),
        fluidRow(column(
          width = 12,
          align = "center",
          downloadButton(
            "download_Rt_tiff",
            "下载结果(tiff)",
            icon = icon("file-image"),
            class = "butt"
          )
        )),
        br(),
        fluidRow(column(
          width = 12,
          align = "center",
          downloadButton(
            "download_Rt_pdf",
            "下载结果(PDF)",
            icon = icon("file-pdf"),
            class = "butt"
          )
        )),
        br(),
        fluidRow(column(
          width = 12,
          align = "center",
          downloadButton(
            "download_Rt_csv",
            "下载数据(csv)",
            icon = icon("file-excel"),
            class = "butt"
          )
        )),
        title = "下载",
        size = "s",
        footer = list(modalButton("取消"))
      )
    )
    
    output$download_Rt_csv <- downloadHandler(
      filename = function() {
        paste0("Outcome", Sys.Date(), ".csv")
      },
      content = function(file) {
        write.csv(values$df_Rt, file, row.names = FALSE)
      }
    )
    
    output$download_Rt_png <- downloadHandler(
      filename = function() {
        paste0("Outcome", Sys.Date(), ".png")
      },
      content = function(file) {
        figs$fig_Rt
        ggsave(file, height = 7, width = 12)
      }
    )
    
    output$download_Rt_tiff <- downloadHandler(
      filename = function() {
        paste0("Outcome", Sys.Date(), ".tiff")
      },
      content = function(file) {
        figs$fig_Rt
        ggsave(file, height = 7, width = 12)
      }
    )
    
    output$download_Rt_pdf <- downloadHandler(
      filename = "outcome.pdf",
      content = function(file) {
        pdf(file)
        print(figs$fig_Rt)
        dev.off()
      }
    )
  } else {
    showModal(modalDialog(
      fluidRow(column(
        width = 12,
        align = "center",
        h3("没找到数据, 请点击“数据预览”按钮并出现流行曲线后再试~")
      )),
      title = "Error",
      size = "s",
      footer = list(modalButton("确定"))
    ))
  }
})
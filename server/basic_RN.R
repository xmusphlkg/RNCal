

# earlyR ------------------------------------------------------------------

## ui setting -----------

observeEvent(input$earlyR_si_data, {
  if (input$earlyR_si_data != "NULL") {
    value <- input$earlyR_si_data
    value <- as.numeric(str_split(value, "-")[[1]])
    updateNumericInput(
      session = session,
      inputId = "earlyR_si_mean",
      label = "代间距(SI)均数",
      value = value[2]
    )
    updateNumericInput(
      session = session,
      inputId = "earlyR_si_std",
      label = "代间距(SI)标准差",
      value = value[1]
    )
  }
})

## estimate R0 -----------

observeEvent(input$earlyR_si_confirmed, {
  if (is.null(values$df_global)) {
    shinyalert(
      "提交失败",
      "原因：未找到原始数据，请在数据输入
                           界面点击'转换'或者'绘图'后重试！",
      timer = 5000,
      type = "error",
      size = "xs"
    )
  } else if (is.na(input$earlyR_si_mean)) {
    shinyalert(
      "提交失败",
      "原因：关键参数缺失！",
      timer = 5000,
      type = "error",
      size = "xs"
    )
  } else if (is.na(input$earlyR_si_std)) {
    shinyalert(
      "提交失败",
      "原因：关键参数缺失！",
      timer = 5000,
      type = "error",
      size = "xs"
    )
  } else {
    datafile <- values$df_plot
    si_mean <- input$earlyR_si_mean
    si_sd <- input$earlyR_si_std
    outcome <- get_R(incidence(datafile$onset),
      si_mean = si_mean,
      si_sd = si_sd
    )
    fig <- plot(outcome) + theme_set()
    figs$fig_earlyR_R0 <- fig

    output$fig_earlyR_R0 <- renderPlot({
      fig
    })

    # 生成计算代码
    code_to_display <- paste0(
      "# 安装包\n",
      "# install.packages('earlyR')\n",
      "library(earlyR)\n\n",
      "# 设置代际时间\n",
      "si_mean <- ", deparse(si_mean), "\n",
      "si_sd <- ", deparse(si_sd), "\n\n",
      "# 设置病例数据\n",
      "val <- incidence(as.Date(", deparse1(as.character(datafile$onset)), "))\n\n",
      "# 估计R0\n",
      "outcome <- get_R(val, si_mean = si_mean, si_sd = si_sd)\n",
      "plot(outcome)"
    )
    # 更新计算代码
    updateAceEditor(
      session,
      "code_editor",
      value = code_to_display,
    )
  }
})


# R0 ----------------------------------------------------------------------

observeEvent(input$R0_gt_data, {
  if (input$R0_gt_data != "NULL") {
    value <- input$R0_gt_data
    value <- as.numeric(str_split(value, "-")[[1]])

    updateNumericInput(
      session = session,
      inputId = "R0_gt_mean",
      label = "代间距(GT)均数",
      value = value[2]
    )
    updateNumericInput(
      session = session,
      inputId = "R0_gt_std",
      label = "代间距(GT)标准差",
      value = value[1]
    )
  }
})

output$R0_gt_data_detail_1 <- renderRHandsontable({
  DF <- data.frame(
    "传染者发病时间" = rep(0, length(H1N1.serial.interval)),
    "感染者发病时间" = H1N1.serial.interval
  )
  rhandsontable(DF, language = "zh-CN") %>%
    hot_context_menu(allowColEdit = FALSE, allowRowEdit = TRUE) %>%
    hot_cols(colWidths = 130, format = "0")
})

output$R0_gt_data_gt_empirical_1 <- renderRHandsontable({
  DF <- data.frame("分布概率" = c(0, 0.25, 0.2, 0.15, 0.1, 0.09, 0.05, 0.01))
  rhandsontable(DF, language = "zh-CN") %>%
    hot_context_menu(allowColEdit = FALSE, allowRowEdit = TRUE) %>%
    hot_cols(colWidths = 130, format = "0")
})

output$R0_gt_data_si_1 <- renderRHandsontable({
  DF <- as.data.frame(table(H1N1.serial.interval))
  names(DF) <- c("Serial interval", "Freq")
  rhandsontable(DF, language = "zh-CN") %>%
    hot_context_menu(allowColEdit = FALSE, allowRowEdit = TRUE) %>%
    hot_cols(colWidths = 130, format = "0")
})

observeEvent(input$R0_gt_data_confirmed_1, {
  tryCatch(
    {
      # 封装数据处理逻辑
      processInputData <- function(inputType) {
        switch(inputType,
          "SI" = {
            df <- hot_to_r(input$R0_gt_data_si_1)
            df <- df[rep(row.names(df), df$Freq), 1]
            suppressMessages(suppressWarnings(est.GT(serial.interval = as.numeric(df))))
          },
          "detail" = {
            df <- hot_to_r(input$R0_gt_data_detail_1)
            suppressMessages(suppressWarnings(
              est.GT(
                infector.onset.dates = df$传染者发病时间,
                infectee.onset.dates = df$感染者发病时间
              )
            ))
          },
          "GT" = {
            df <- switch(input$R0_gt_data_gt_type_1,
              "empirical" = as.numeric(hot_to_r(input$R0_gt_data_gt_empirical_1)[, 1]),
              "gamma" = c(input$R0_gt_data_gt_gamma_shape, input$R0_gt_data_gt_gamma_scale),
              "weibull" = c(input$R0_gt_data_gt_weibull_shape, input$R0_gt_data_gt_weibull_scale),
              "lognormal" = c(input$R0_gt_data_gt_lognormal_meanlog, input$R0_gt_data_gt_lognormal_sdlog),
              stop("未知的GT类型", call. = FALSE)
            )
            if (length(df) == 0) stop("关键参数缺失！", call. = FALSE)
            suppressMessages(suppressWarnings(
              generation.time(
                type = input$R0_gt_data_gt_type_1,
                val = as.numeric(df)
              )
            ))
          },
          stop("未知的输入类型", call. = FALSE)
        )
      }

      # 处理数据
      df_gt <- processInputData(input$R0_gt_input_type_1)

      # 更新UI
      values$R0_gt <- df_gt
      output$R0_gt_data_1 <- renderPrint(print(df_gt))
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

# est.R0 ------------------------------------------------------------------

observeEvent(input$R0_R0_confirmed, {
  tryCatch(
    {
      # 输入验证
      begin <- input$R0_est_begin
      end <- input$R0_est_end
      if (is.na(begin) | is.na(end)) {
        stop("开始和(或)结束时间点缺失！", call. = FALSE)
      }

      # 确保values$R0_gt已经计算
      if (is.null(values$R0_gt)) {
        stop("代际尚未设置", call. = FALSE)
      }

      # 数据处理
      df <- values$df_plot %>%
        group_by(onset) %>%
        summarise(X = n())
      # browser()

      if (nrow(df) < end) {
        stop("结束时间点过长！", call. = FALSE)
      }

      # 封装估计R0的逻辑
      estimateR0 <- function(estimationFunction, data, gt, start, stop, ...) {
        switch(estimationFunction,
          "EG" = est.R0.EG(data, gt, begin = start, end = stop, ...),
          "ML" = est.R0.ML(data, gt, begin = start, end = stop, range = c(0.01, 50), ...),
          stop("未知的估计函数", call. = FALSE)
        )
      }

      # 计算R0
      df_value <- df$X
      names(df_value) <- df$onset
      df_gt <- values$R0_gt
      df_R0 <- estimateR0(input$R0_est_function, df_value, df_gt, begin, end)

      # 更新UI
      output$R0_est_R0 <- renderPrint(print(df_R0))
      output$fig_R0_R0 <- renderPlot({
        plot(df_R0)
      })

      # 生成计算代码
      code_val <- switch(input$R0_gt_input_type_1,
        "SI" = {
          df <- hot_to_r(input$R0_gt_data_si_1)
          df <- df[rep(row.names(df), df$Freq), 1]
          paste0("est.GT(serial.interval = ", deparse(as.numeric(df)), ")")
        },
        "detail" = {
          df <- hot_to_r(input$R0_gt_data_detail_1)
          paste0("est.GT(infector.onset.dates = ", deparse(df$传染者发病时间), ", infectee.onset.dates = ", deparse(df$感染者发病时间), ")")
        },
        "GT" = {
          df <- switch(input$R0_gt_data_gt_type_1,
            "empirical" = as.numeric(
              hot_to_r(input$R0_gt_data_gt_empirical_1)[, 1]
            ),
            "gamma" = c(
              input$R0_gt_data_gt_gamma_shape,
              input$R0_gt_data_gt_gamma_scale
            ),
            "weibull" = c(
              input$R0_gt_data_gt_weibull_shape,
              input$R0_gt_data_gt_weibull_scale
            ),
            "lognormal" = c(
              input$R0_gt_data_gt_lognormal_meanlog,
              input$R0_gt_data_gt_lognormal_sdlog
            ),
            stop("未知的GT类型", call. = FALSE)
          )
          paste0("generation.time(type = '", input$R0_gt_data_gt_type_1, "', val = ", deparse(df), ")")
        },
        stop("未知的输入类型", call. = FALSE)
      )

      code_to_display <- paste0(
        "# 安装R0包\n",
        "# install.packages('R0')\n",
        "library(R0)\n\n",
        "# 设置代际时间\n",
        "df_gt <- ", code_val, "\n\n",
        "# 设置病例数据\n",
        "df_value <- read.csv('test.csv', header = T)\n",
        "names(df_value) = c('t', 'X')\n",
        "df_value <- df_value |>
        complete(t = seq.Date(min(t), max(t), by = 'day'),
        fill = list(X = 0))",
        "# 设置开始和结束时间\n",
        "begin <- ", deparse(begin), "\n",
        "end <- ", deparse(end), "\n\n",
        "# 估计R0\n",
        "df_R0 <- est.R0.", input$R0_est_function, "(df_value, df_gt, begin = begin, end = end)"
      )

      # 更新计算代码
      updateAceEditor(
        session,
        "code_editor",
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
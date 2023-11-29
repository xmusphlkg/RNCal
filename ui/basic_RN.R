basic_RN <- tabPanelBody(
  value = "Basic_RN",
  box(
    title = "参数设置",
    status = "warning",
    width = 4,
    # Step 1: Setting method ------------------------------------------------
    box(
      title = "Step 1: 选择估计方法",
      status = "success",
      width = 12,
      column(
        width = 6,
        pickerInput(
          inputId = "select_packages_R0",
          label = "选择估计方法 (Packages)",
          choices = c("EarlyR", "R0"),
          selected = "R0",
          options = list(style = "btn-danger")
        )
      ),
      div(column(
        width = 6,
        align = "center",
        actionBttn(
          inputId = "Tab_Rt",
          label = "转到Rt计算",
          style = "float",
          icon = icon("toggle-off"),
          color = "success"
        )
      ),
      style = "top: 25px;position: relative;"
      )
    ),
    # Step 2: Setting data --------------------------------------------------
    ## earlyR ----------------------------------------------------------------
    conditionalPanel(
      condition = "input.select_packages_R0 == 'EarlyR'",
      fluidRow(
        box(
          width = 12,
          status = "success",
          title = "Step 2: 设置参数",
          column(
            width = 6,
            selectInput(
              inputId = "earlyR_si_data",
              label = "默认数据(COVID-19)",
              choices = c(
                "Delta_广东" = "3.4-2.3",
                "Delta_01" = "4.4-3.3",
                "Delta_02" = "5.4-4.3",
                "Delta_03" = "3.4-2.3",
                "Delta_04" = "3.4-2.3"
              ),
              selected = "Delta_广东",
              width = "100%"
            ),
            numericInput(
              inputId = "earlyR_max_R",
              label = "再生数最大值(可选)",
              width = "100%",
              value = NA
            )
          ),
          column(
            width = 6,
            numericInput(
              inputId = "earlyR_si_mean",
              label = "症状代际(SI)均数",
              width = "100%",
              value = 2.3
            ),
            numericInput(
              inputId = "earlyR_si_std",
              label = "症状代际(SI)标准差",
              width = "100%",
              value = 3.4
            )
          ),
          column(
            width = 12,
            align = "center",
            actionBttn(
              inputId = "earlyR_si_confirmed",
              label = "估计再生数",
              color = "danger",
              style = "float"
            )
          )
        )
      )
    ),
    ## R0 --------------------------------------------------------------------
    conditionalPanel(
      condition = "input.select_packages_R0 == 'R0'",
      fluidRow(
        box(
          width = 12,
          title = "Step 2: 设置参数",
          status = "danger",
          column(
            width = 6,
            numericInput(
              inputId = "R0_est_begin",
              label = "开始时间",
              value = 1,
              min = 1,
              width = "100%"
            )
          ),
          column(
            width = 6,
            numericInput(
              inputId = "R0_est_end",
              label = "结束时间",
              value = 7,
              min = 3,
              width = "100%"
            )
          ),
          column(
            width = 6,
            pickerInput(
              inputId = "R0_est_function",
              label = "方法选择",
              choices = c(
                "exponential growth rate" = "EG",
                "maximum likelihood" = "ML"
              ),
              selected = "maximum likelihood"
            )
          ),
          column(
            width = 6,
            pickerInput(
              inputId = "R0_gt_input_type_1",
              label = "选择数据类型",
              choices = c(
                "症状代际(Serial Interval)" = "SI",
                "详细数据(Detail)" = "detail",
                "感染代际(Generation Time)" = "GT"
              ),
              selected = "GT"
            )
          )
        ),
        box(
          title = "Step 3: 设置代际",
          status = "danger",
          width = 12,
          conditionalPanel(
            condition = 'input.R0_gt_input_type_1 == "SI"',
            column(
              width = 12,
              rHandsontableOutput("R0_gt_data_si_1", height = "250px"),
              tags$br()
            )
          ),
          conditionalPanel(
            condition = 'input.R0_gt_input_type_1 == "detail"',
            column(
              width = 12,
              rHandsontableOutput("R0_gt_data_detail_1", height = "250px"),
              tags$br()
            )
          ),
          conditionalPanel(
            condition = 'input.R0_gt_input_type_1 == "GT"',
            column(
              width = 12,
              pickerInput(
                inputId = "R0_gt_data_gt_type_1",
                label = "GT分布",
                choices = c("empirical", "gamma", "weibull", "lognormal"),
                selected = "gamma"
              ),
              ## setting parameters input of empirical
              conditionalPanel(
                condition = 'input.R0_gt_data_gt_type_1 == "empirical"',
                column(
                  width = 12,
                  numericInput(
                    inputId = "R0_gt_data_gt_empirical_sep",
                    label = "分割点",
                    value = 1,
                    min = 0.5,
                    width = "100%"
                  ),
                  rHandsontableOutput(
                    "R0_gt_data_gt_empirical_1",
                    height = "250px"
                  ),
                  tags$br(),
                  tags$span("注：此处默认数据为随机生成，不具备任何参考价值。")
                )
              ),
              ## setting parameters input of gamma
              conditionalPanel(
                condition = 'input.R0_gt_data_gt_type_1 == "gamma"',
                column(
                  width = 6,
                  numericInput(
                    inputId = "R0_gt_data_gt_gamma_shape",
                    label = "形状参数",
                    value = 2.45,
                    min = 0.5,
                    width = "100%"
                  )
                ),
                column(
                  width = 6,
                  numericInput(
                    inputId = "R0_gt_data_gt_gamma_scale",
                    label = "尺度参数",
                    value = 1.38,
                    min = 0.5,
                    width = "100%"
                  )
                )
              ),
              ## setting parameters input of weibull
              conditionalPanel(
                condition = 'input.R0_gt_data_gt_type_1 == "weibull"',
                column(
                  width = 6,
                  numericInput(
                    inputId = "R0_gt_data_gt_weibull_shape",
                    label = "形状参数",
                    value = 2,
                    min = 0.5,
                    width = "100%"
                  )
                ),
                column(
                  width = 6,
                  numericInput(
                    inputId = "R0_gt_data_gt_weibull_scale",
                    label = "尺度参数",
                    value = 2,
                    min = 0.5,
                    width = "100%"
                  )
                ),
                column(
                  width = 12,
                  tags$span("注：此处默认数据为随机生成，不具备任何参考价值。")
                )
              ),
              ## setting parameters input of lognormal
              conditionalPanel(
                condition = 'input.R0_gt_data_gt_type_1 == "lognormal"',
                column(
                  width = 6,
                  numericInput(
                    inputId = "R0_gt_data_gt_lognormal_meanlog",
                    label = "均数的对数",
                    value = 2,
                    min = 0.5,
                    width = "100%"
                  )
                ),
                column(
                  width = 6,
                  numericInput(
                    inputId = "R0_gt_data_gt_lognormal_sdlog",
                    label = "标准差的对数",
                    value = 2,
                    min = 0.5,
                    width = "100%"
                  )
                ),
                column(
                  width = 12,
                  tags$span("注：此处默认数据为随机生成，不具备任何参考价值。")
                )
              )
            )
          ),
          tags$br(),
          column(
            width = 12,
            actionButton(
              inputId = "R0_gt_data_confirmed_1",
              label = "生成代际分布",
              width = "100%",
              style = "float",
              color = "danger"
            )
          )
        ),
        box(
          title = "Step 4: 估计R0",
          status = "danger",
          width = 12,
          verbatimTextOutput("R0_gt_data_1", placeholder = T),
          column(
            width = 12,
            actionButton(
              inputId = "R0_R0_confirmed",
              label = "估计R0",
              icon = icon("toggle-off"),
              width = "100%",
            )
          )
        )
      )
    )
  ),
  box(
    title = "结果",
    status = "warning",
    width = 8,
    conditionalPanel(
      condition = "input.select_packages_R0 == 'EarlyR'",
      plotOutput("fig_earlyR_R0")
    ),
    conditionalPanel(
      condition = "input.select_packages_R0 == 'R0'",
      verbatimTextOutput("R0_est_R0", placeholder = T),
      plotOutput("fig_R0_R0", height = "600px")
    ),
    box(
      title = "Code",
      width = 12,
      status = "danger",
      aceEditor(
        "code_editor",
        mode = "r",
        theme = "github",
        readOnly = TRUE,
        height = "300px",
      )
    )
  )
)
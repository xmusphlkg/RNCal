real_RN <- tabPanelBody(
  value = "Real_RN",
  tags$head(
    tags$style(".butt{background-color:#E95420; color: white; width: 100%}"),
    tags$style("#epiestim_gt_data_1 {max-height: 150px;overflow-y: auto;}")
  ),
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
          inputId = "select_packages",
          label = "选择估计方法 (Packages)",
          # choices = c('EpiEstim', 'R0', 'EpiNow2'),
          choices = c("EpiEstim", "R0"),
          selected = "EpiEstim",
          options = list(style = "btn-danger")
        )
      ),
      div(column(
        width = 6,
        align = "center",
        actionBttn(
          inputId = "Tab_R0",
          label = "转到R0计算",
          style = "float",
          icon = icon("toggle-off"),
          color = "success"
        )
      ),
      style = "top: 25px;position: relative;"
      )
    ),
    # Step 2: Setting data --------------------------------------------------
    ## EpiEstim --------------------------------------------------------------
    conditionalPanel(
      condition = "input.select_packages == 'EpiEstim'",
      box(
        title = "Step 2: 设置参数",
        status = "danger",
        width = 12,
        column(
          width = 6,
          pickerInput(
            inputId = "epiestim_first",
            label = "从第几天开始计算？",
            choices = 2:30,
            selected = 3
          )
        ),
        column(
          width = 6,
          pickerInput(
            inputId = "epiestim_width",
            label = "计算间距(天)",
            choices = 4:30,
            selected = 7
          ),
        ),
        column(
          width = 6,
          pickerInput(
            inputId = "epiestim_method",
            label = "方法设置",
            choices = c(
              "non_parametric_si", "parametric_si", "uncertain_si"
              # "si_from_data", "si_from_sample"
            ),
            selected = "parametric_si"
          )
        )
      ),
      box(
        title = "Step 3: 设置代际",
        status = "danger",
        width = 12,
        conditionalPanel(
          condition = 'input.epiestim_method == "parametric_si"',
          column(
            width = 6,
            pickerInput(
              inputId = "epiestim_parametric_si_data",
              label = "模板数据",
              choices = c(
                "Delta_广东",
                "Delta_湖南",
                "Omicron_BA1_珠海",
                "Omicron_BA2_厦门"
              ),
              selected = "Omicron_BA2_厦门"
            )
          ),
          column(
            width = 6,
            numericInput(
              inputId = "epiestim_parametric_si_mean",
              label = "代间距(SI)均数",
              width = "100%",
              value = 2.24
            )
          ),
          column(
            width = 6,
            numericInput(
              inputId = "epiestim_parametric_si_std",
              label = "代间距(SI)标准差",
              width = "100%",
              value = 1.26
            )
          )
        ),
        conditionalPanel(
          condition = 'input.epiestim_method == "non_parametric_si"',
          column(
            width = 12,
            rHandsontableOutput("non_parametric_si_data", height = "250px"),
            tags$br(),
            tags$span("注：此处默认数据为随机生成，不具备任何参考价值。")
          )
        ),
        conditionalPanel(
          condition = 'input.epiestim_method == "uncertain_si"',
          column(
            width = 6,
            numericInput(
              inputId = "epiestim_uncertain_si_mean_si",
              label = "代间距(SI)均数",
              width = "100%",
              value = 2.6
            ),
            numericInput(
              inputId = "epiestim_uncertain_si_min_mean_si",
              label = "代间距(SI)均数最小值",
              width = "100%",
              value = 1
            ),
            numericInput(
              inputId = "epiestim_uncertain_si_max_mean_si",
              label = "代间距(SI)均数最大值",
              width = "100%",
              value = 4.2
            ),
            numericInput(
              inputId = "epiestim_uncertain_si_std_mean_si",
              label = "代间距(SI)均数标准差",
              width = "100%",
              value = 1
            ),
            numericInput(
              inputId = "epiestim_uncertain_si_n1",
              label = "n1",
              width = "100%",
              value = 100
            )
          ),
          column(
            width = 6,
            numericInput(
              inputId = "epiestim_uncertain_si_std_si",
              label = "代间距(SI)标准差",
              width = "100%",
              value = 1.5
            ),
            numericInput(
              inputId = "epiestim_uncertain_si_std_std_si",
              label = "代间距(SI)标准差的标准差",
              width = "100%",
              value = 0.5
            ),
            numericInput(
              inputId = "epiestim_uncertain_si_min_std_si",
              label = "代间距(SI)标准差最小值",
              width = "100%",
              value = 0.5
            ),
            numericInput(
              inputId = "epiestim_uncertain_si_max_std_si",
              label = "代间距(SI)标准差最大值",
              width = "100%",
              value = 2.5
            ),
            numericInput(
              inputId = "epiestim_uncertain_si_n2",
              label = "n2",
              width = "100%",
              value = 100
            )
          ),
          column(
            width = 12,
            tags$span("注：此处默认数据为随机生成，不具备任何参考价值。")
          )
        ),
        tags$br(),
        column(
          width = 12,
          actionButton(
            inputId = "rt_epiestim_gt_confirmed",
            label = "生成代际分布",
            width = "100%"
          )
        )
      ),
      box(
        title = "Step 4: 估计Rt",
        status = "danger",
        width = 12,
        verbatimTextOutput("epiestim_gt_data_1", placeholder = T),
        column(
          width = 12,
          actionButton(
            inputId = "rt_epiestim_confirmed",
            label = "估计Rt",
            icon = icon("toggle-off"),
            width = "100%",
          )
        )
      )
    ),
    ## R0 --------------------------------------------------------------------
    conditionalPanel(
      condition = "input.select_packages == 'R0'",
      box(
        title = "Step 2: 设置参数",
        status = "danger",
        width = 12,
        column(
          width = 6,
          numericInput(
            inputId = "R0_Rt_est_begin",
            label = "开始时间",
            value = 1,
            min = 1,
            width = "100%"
          )
        ),
        column(
          width = 6,
          numericInput(
            inputId = "R0_Rt_est_end",
            label = "结束时间",
            value = 7,
            min = 3,
            width = "100%"
          )
        ),
        column(
          width = 6,
          pickerInput(
            inputId = "R0_Rt_est_function",
            label = "方法选择",
            choices = c(
              "Wallinga & Teunis" = "TD",
              "Bayesian approach" = "SB"
            ),
            selected = "Wallinga & Teunis"
          )
        ),
        column(
          width = 6,
          pickerInput(
            inputId = "R0_gt_input_type_2",
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
          condition = 'input.R0_gt_input_type_2 == "SI"',
          column(
            width = 12,
            rHandsontableOutput("R0_gt_data_si_2", height = "250px"),
            tags$br()
          )
        ),
        conditionalPanel(
          condition = 'input.R0_gt_input_type_2 == "detail"',
          column(
            width = 12,
            rHandsontableOutput("R0_gt_data_detail_2", height = "250px"),
            tags$br()
          )
        ),
        conditionalPanel(
          condition = 'input.R0_gt_input_type_2 == "GT"',
          column(
            width = 12,
            pickerInput(
              inputId = "R0_gt_data_gt_type_3",
              label = "GT分布",
              choices = c("empirical", "gamma", "weibull", "lognormal"),
              selected = "gamma"
            ),
            ## setting parameters input of empirical
            conditionalPanel(
              condition = 'input.R0_gt_data_gt_type_3 == "empirical"',
              column(
                width = 12,
                numericInput(
                  inputId = "R0_gt_data_gt_empirical_2",
                  label = "分割点",
                  value = 1,
                  min = 0.5,
                  width = "100%"
                ),
                rHandsontableOutput(
                  "R0_gt_data_gt_empirical_2",
                  height = "250px"
                )
              ),
              column(
                width = 12,
                tags$span("注：此处默认数据为随机生成，不具备任何参考价值。")
              )
            ),
            ## setting parameters input of gamma
            conditionalPanel(
              condition = 'input.R0_gt_data_gt_type_3 == "gamma"',
              column(
                width = 6,
                numericInput(
                  inputId = "R0_gt_data_gt_gamma_shape_1",
                  label = "形状参数",
                  value = 2.45,
                  min = 0.5,
                  width = "100%"
                )
              ),
              column(
                width = 6,
                numericInput(
                  inputId = "R0_gt_data_gt_gamma_scale_1",
                  label = "尺度参数",
                  value = 1.38,
                  min = 0.5,
                  width = "100%"
                )
              )
            ),
            ## setting parameters input of weibull
            conditionalPanel(
              condition = 'input.R0_gt_data_gt_type_3 == "weibull"',
              column(
                width = 6,
                numericInput(
                  inputId = "R0_gt_data_gt_weibull_shape_1",
                  label = "形状参数",
                  value = 2,
                  min = 0.5,
                  width = "100%"
                )
              ),
              column(
                width = 6,
                numericInput(
                  inputId = "R0_gt_data_gt_weibull_scale_1",
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
              condition = 'input.R0_gt_data_gt_type_3 == "lognormal"',
              column(
                width = 6,
                numericInput(
                  inputId = "R0_gt_data_gt_lognormal_meanlog_1",
                  label = "均数的对数",
                  value = 2,
                  min = 0.5,
                  width = "100%"
                )
              ),
              column(
                width = 6,
                numericInput(
                  inputId = "R0_gt_data_gt_lognormal_sdlog_1",
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
            inputId = "R0_gt_data_confirmed_2",
            label = "生成代际分布",
            width = "100%",
            style = "float",
            color = "danger"
          )
        )
      ),
      box(
        title = "Step 4: 估计Rt",
        status = "danger",
        width = 12,
        verbatimTextOutput("R0_gt_data_2", placeholder = T),
        column(
          width = 12,
          actionButton(
            inputId = "R0_Rt_confirmed",
            label = "估计Rt",
            icon = icon("toggle-off"),
            width = "100%",
          )
        )
      )
    )
  ),
  box(
    title = "结果",
    width = 8,
    status = "danger",
    conditionalPanel(
      condition = "input.select_packages == 'EpiEstim'",
      column(
        width = 12,
        plotOutput("fig_EpiEstim_Rt")
      ),
      column(
        width = 12,
        align = "right",
        actionBttn(
          inputId = "Rt_download",
          label = "结果下载",
          size = "sm",
          color = "warning",
          icon = icon("download"),
        ),
        tags$hr()
      ),
      box(
        title = "Code",
        width = 12,
        status = "danger",
        aceEditor(
          "code_editor_rt_epiestim",
          mode = "r",
          theme = "github",
          readOnly = TRUE,
          height = "300px",
        )
      )
    ),
    conditionalPanel(
      condition = "input.select_packages == 'R0'",
      column(
        width = 12,
        verbatimTextOutput("R0_est_Rt", placeholder = T),
        plotOutput("fig_R0_Rt")
      ),
      column(
        width = 12,
        align = "right",
        actionBttn(
          inputId = "Rt_download",
          label = "结果下载",
          size = "sm",
          color = "warning",
          icon = icon("download"),
        ),
        tags$hr()
      ),
      box(
        title = "Code",
        width = 12,
        status = "danger",
        aceEditor(
          "code_editor_rt",
          mode = "r",
          theme = "github",
          readOnly = TRUE,
          height = "300px",
        )
      )
    )
  )
)
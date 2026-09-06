# =============================================================================
# INTERACTIVE PROBABILITY DISTRIBUTIONS LABORATORY
# =============================================================================
#
# An interactive Shiny application for exploring probability distributions.
#
# Supported distributions:
#   Continuous:
#     - Normal
#     - Student's t
#     - Chi-Square
#     - Exponential
#     - Gamma
#     - Beta
#
#   Discrete:
#     - Binomial
#     - Poisson
#     - Geometric
#     - Hypergeometric
#     - Negative Binomial
#
# Features:
#   - Bilingual interface (Spanish / English)
#   - Interactive parameters
#   - Probability interval calculations
#   - Domain validation
#   - Educational adjustment messages for discrete inputs
#   - PDF / PMF / CDF visualization
#   - Distribution statistics
#   - Mathematical equations
#   - Technical definitions
#   - Quantile tables for continuous distributions
#   - Probability tables for discrete distributions
#
# =============================================================================


# =============================================================================
# PACKAGES
# =============================================================================

library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)


# =============================================================================
# INTERNATIONALIZATION
# =============================================================================

i18n <- list(

  es = list(

    # Application
    title = "Laboratorio Interactivo de Distribuciones de Probabilidad",
    family = "Familia:",
    continuous = "Continua",
    discrete = "Discreta",
    model = "Modelo:",
    lang = "Idioma",

    # Parameters
    params = "Parámetros del Modelo",

    # Statistics
    stats = "Estadísticos",
    mean = "Media (μ)",
    variance = "Varianza (σ²)",
    std = "Desviación Estándar (σ)",
    median = "Mediana",
    mode = "Moda",
    skewness = "Asimetría (Skewness)",
    kurtosis = "Curtosis (Exceso)",

    # Probability calculator
    prob_calc = "Cálculo de Probabilidades",
    lower_bound = "Límite inferior (a):",
    upper_bound = "Límite superior (b):",
    prob_result = "Probabilidad calculada",

    # Tabs
    pdf_tab = "Función de Densidad de Probabilidad",
    pmf_tab = "Función de Masa de Probabilidad",
    cdf_tab = "Función de Distribución Acumulada",
    quantile_tab = "Tabla de Cuantiles",
    probability_tab = "Tabla de Probabilidades",

    # Axes
    x_axis = "Valor (x)",
    y_pdf = "Densidad f(x)",
    y_pmf = "Probabilidad P(X = x)",
    y_cdf = "Probabilidad acumulada F(x)",

    # Tables
    probability = "Probabilidad acumulada",
    quantile = "Cuantil",

    # Equations
    eq_symbolic = "Forma general:",
    eq_numeric = "Evaluada:",
    support_label = "Dominio:",
    variable_label = "Variable aleatoria:",
    parameter_note = "Nota de parametrización:",

    # Probability messages
    interval_label = "P(a ≤ X ≤ b)",
    point_label = "P(X = x)",
    adjusted_interval = "Valores ajustados para la distribución discreta",
    adjustment_message = paste(
      "Los límites ingresados no son enteros.",
      "Para el cálculo se utilizaron los valores enteros resultantes",
      "del ajuste."
    ),
    no_integer_interval = paste(
      "No hay valores enteros de la distribución dentro del intervalo ingresado.",
      "La probabilidad calculada es 0."
    ),

    # Validation
    validation_error = "Error en los valores ingresados:",
    invalid_order = "El límite inferior debe ser menor o igual al límite superior.",
    outside_domain = "Uno o ambos valores están fuera del dominio de esta distribución.",
    continuous_domain = "Ingrese valores dentro del dominio indicado.",
    discrete_domain = "Ingrese valores enteros dentro del soporte de la distribución.",

    # Statistics messages
    undefined = "No definida",
    not_unique = "No única",
    multiple_modes = "Múltiples valores",

    # Legends
    legend_interval = "Intervalo seleccionado",
    legend_point = "Valor seleccionado",
    legend_other = "Resto",

    # Footer
    footer = "Plataforma educativa de estadística — Diseñada para docencia"
  ),

  en = list(

    # Application
    title = "Interactive Probability Distributions Laboratory",
    family = "Family:",
    continuous = "Continuous",
    discrete = "Discrete",
    model = "Model:",
    lang = "Language",

    # Parameters
    params = "Model Parameters",

    # Statistics
    stats = "Statistics",
    mean = "Mean (μ)",
    variance = "Variance (σ²)",
    std = "Standard Deviation (σ)",
    median = "Median",
    mode = "Mode",
    skewness = "Skewness",
    kurtosis = "Kurtosis (Excess)",

    # Probability calculator
    prob_calc = "Probability Calculator",
    lower_bound = "Lower bound (a):",
    upper_bound = "Upper bound (b):",
    prob_result = "Calculated probability",

    # Tabs
    pdf_tab = "Probability Density Function",
    pmf_tab = "Probability Mass Function",
    cdf_tab = "Cumulative Distribution Function",
    quantile_tab = "Quantile Table",
    probability_tab = "Probability Table",

    # Axes
    x_axis = "Value (x)",
    y_pdf = "Density f(x)",
    y_pmf = "Probability P(X = x)",
    y_cdf = "Cumulative Probability F(x)",

    # Tables
    probability = "Cumulative probability",
    quantile = "Quantile",

    # Equations
    eq_symbolic = "General form:",
    eq_numeric = "Evaluated:",
    support_label = "Support:",
    variable_label = "Random variable:",
    parameter_note = "Parameterization note:",

    # Probability messages
    interval_label = "P(a ≤ X ≤ b)",
    point_label = "P(X = x)",
    adjusted_interval = "Values adjusted for the discrete distribution",
    adjustment_message = paste(
      "The entered bounds are not integers.",
      "The calculation uses the integer values resulting",
      "from the adjustment."
    ),
    no_integer_interval = paste(
      "There are no integer values of the distribution within the entered interval.",
      "The calculated probability is 0."
    ),

    # Validation
    validation_error = "Input validation error:",
    invalid_order = "The lower bound must be less than or equal to the upper bound.",
    outside_domain = "One or both values are outside the domain of this distribution.",
    continuous_domain = "Enter values within the indicated domain.",
    discrete_domain = "Enter integer values within the distribution support.",

    # Statistics messages
    undefined = "Undefined",
    not_unique = "Not unique",
    multiple_modes = "Multiple values",

    # Legends
    legend_interval = "Selected interval",
    legend_point = "Selected value",
    legend_other = "Other",

    # Footer
    footer = "Educational Statistics Platform — Designed for Teaching"
  )
)


# =============================================================================
# USER INTERFACE
# =============================================================================

ui <- fluidPage(

  tags$head(

    tags$style(
      HTML("
        .well {
          background-color: #f8fafc;
          border: 1px solid #e2e8f0;
          border-radius: 10px;
          box-shadow: 0 1px 3px rgba(0,0,0,0.05);
          padding: 12px;
        }

        .prob-box {
          background-color: #e0e7ff;
          border: 1px solid #c7d2fe;
          border-radius: 8px;
          padding: 10px;
          margin-top: 10px;
          text-align: center;
        }

        .prob-box span {
          font-size: 13px;
          color: #3730a3;
          font-weight: bold;
          display: block;
        }

        .prob-box strong {
          font-size: 16px;
          color: #312e81;
        }

        .validation-box {
          background-color: #fef2f2;
          border: 1px solid #fecaca;
          border-radius: 8px;
          padding: 10px;
          margin-top: 10px;
          color: #991b1b;
          font-size: 13px;
        }

        .adjustment-box {
          background-color: #fffbeb;
          border: 1px solid #fde68a;
          border-radius: 8px;
          padding: 10px;
          margin-top: 10px;
          color: #92400e;
          font-size: 13px;
        }

        .eq-box {
          background-color: #f8fafc;
          border: 1px solid #e2e8f0;
          border-radius: 8px;
          padding: 12px;
          margin-top: 15px;
        }

        .eq-box .eq-line {
          margin: 6px 0;
        }

        .eq-box .eq-label {
          font-weight: 600;
          color: #334155;
          font-size: 13px;
        }

        .help-text {
          font-size: 12px;
          color: #64748b;
          margin-top: -5px;
          margin-bottom: 10px;
        }

        .definition-text {
          font-size: 13px;
          color: #475569;
          line-height: 1.5;
          margin-top: 6px;
        }
      ")
    )
  ),

  withMathJax(),

  fluidRow(

    column(
      8,
      titlePanel(textOutput("app_title"))
    ),

    column(
      4,
      style = "margin-top: 25px;",

      div(
        style = "width: 70%; float: right;",

        selectInput(
          "lang",
          label = NULL,
          choices = list(
            "Español" = "es",
            "English" = "en"
          ),
          selected = "es",
          width = "100%"
        )
      )
    )
  ),

  sidebarLayout(

    sidebarPanel(

      width = 4,

      fluidRow(

        column(
          6,
          uiOutput("family_ui")
        ),

        column(
          6,
          uiOutput("model_ui")
        )
      ),

      hr(style = "margin: 8px 0;"),

      uiOutput("params_ui"),

      hr(style = "margin: 8px 0;"),

      uiOutput("prob_calc_ui"),

      uiOutput("validation_panel"),

      uiOutput("adjustment_panel"),

      wellPanel(

        h4(
          textOutput("stats_title"),
          style = "margin-top: 0;"
        ),

        verbatimTextOutput("stats_summary")
      )
    ),

    mainPanel(

      width = 8,

      tabsetPanel(

        tabPanel(
          uiOutput("density_tab_title"),

          plotlyOutput(
            "plot_density",
            height = "420px"
          ),

          uiOutput("prob_result_panel"),

          uiOutput("equation_panel")
        ),

        tabPanel(
          textOutput("cdf_tab_title"),

          plotlyOutput(
            "plot_cdf",
            height = "420px"
          )
        ),

        tabPanel(
          uiOutput("table_tab_title"),

          tableOutput("data_table")
        )
      )
    )
  ),

  tags$footer(

    textOutput("footer_text"),

    style = paste(
      "text-align: center;",
      "margin-top: 40px;",
      "padding: 15px;",
      "color: #64748b;",
      "font-size: 12px;",
      "border-top: 1px solid #e2e8f0;"
    )
  )
)


# =============================================================================
# SERVER
# =============================================================================

server <- function(input, output, session) {


  # ===========================================================================
  # LANGUAGE REACTIVE
  # ===========================================================================

  t <- reactive({

    lang_code <- if (!is.null(input$lang)) {
      input$lang
    } else {
      "es"
    }

    i18n[[lang_code]]
  })


  # ===========================================================================
  # STATIC TEXT
  # ===========================================================================

  output$app_title <- renderText({
    t()$title
  })

  output$stats_title <- renderText({
    t()$stats
  })

  output$cdf_tab_title <- renderText({
    t()$cdf_tab
  })

  output$footer_text <- renderText({
    t()$footer
  })

  # ===========================================================================
  # DISTRIBUTION FAMILY
  # ===========================================================================

  output$family_ui <- renderUI({

    selectInput(

      "family",

      t()$family,

      choices = setNames(
        c("continuous", "discrete"),
        c(t()$continuous, t()$discrete)
      ),

      width = "100%"
    )
  })


  # ===========================================================================
  # DISTRIBUTION MODEL
  # ===========================================================================

  output$model_ui <- renderUI({

    req(input$family)

    if (input$family == "continuous") {

      selectInput(

        "model",

        t()$model,

        choices = if (input$lang == "es") {
          c(
            "Normal" = "normal",
            "t de Student" = "student",
            "Chi-cuadrado" = "chisq",
            "Exponencial" = "exponential",
            "Gamma" = "gamma",
            "Beta" = "beta"
          )
        } else {
          c(
            "Normal" = "normal",
            "Student t" = "student",
            "Chi-square" = "chisq",
            "Exponential" = "exponential",
            "Gamma" = "gamma",
            "Beta" = "beta"
          )
        },

        width = "100%"
      )

    } else {

      selectInput(

        "model",

        t()$model,

        choices = if (input$lang == "es") {
          c(
            "Binomial" = "binomial",
            "Poisson" = "poisson",
            "Geométrica" = "geometric",
            "Hipergeométrica" = "hypergeometric",
            "Binomial Negativa" = "negbin"
          )
        } else {
          c(
            "Binomial" = "binomial",
            "Poisson" = "poisson",
            "Geometric" = "geometric",
            "Hypergeometric" = "hypergeometric",
            "Negative Binomial" = "negbin"
          )
        },

        width = "100%"
      )
    }
  })


  # ===========================================================================
  # PARAMETERS UI
  # ===========================================================================

  output$params_ui <- renderUI({

    req(input$model)

    switch(

      input$model,


      # -----------------------------------------------------------------------
      # NORMAL
      # -----------------------------------------------------------------------

      normal = tagList(

        h4(
          t()$params,
          style = "font-size: 14px; color: #475569; margin-top: 0;"
        ),

        sliderInput(
          "mean",
          "Media (μ):",
          min = -25,
          max = 25,
          value = 0,
          step = 0.5,
          width = "100%"
        ),

        sliderInput(
          "sd",
          "Desv. Estándar (σ):",
          min = 0.1,
          max = 10,
          value = 1,
          step = 0.1,
          width = "100%"
        )
      ),


      # -----------------------------------------------------------------------
      # STUDENT T
      # -----------------------------------------------------------------------

      student = tagList(

        h4(
          t()$params,
          style = "font-size: 14px; color: #475569; margin-top: 0;"
        ),

        sliderInput(
          "df_t",
          "Grados de libertad (ν):",
          min = 1,
          max = 50,
          value = 5,
          step = 1,
          width = "100%"
        )
      ),


      # -----------------------------------------------------------------------
      # CHI-SQUARE
      # -----------------------------------------------------------------------

      chisq = tagList(

        h4(
          t()$params,
          style = "font-size: 14px; color: #475569; margin-top: 0;"
        ),

        sliderInput(
          "df_chi",
          "Grados de libertad (k):",
          min = 1,
          max = 40,
          value = 4,
          step = 1,
          width = "100%"
        )
      ),


      # -----------------------------------------------------------------------
      # EXPONENTIAL
      # -----------------------------------------------------------------------

      exponential = tagList(

        h4(
          t()$params,
          style = "font-size: 14px; color: #475569; margin-top: 0;"
        ),

        sliderInput(
          "rate",
          "Tasa (λ):",
          min = 0.1,
          max = 10,
          value = 1,
          step = 0.1,
          width = "100%"
        )
      ),


      # -----------------------------------------------------------------------
      # GAMMA
      # -----------------------------------------------------------------------

      gamma = tagList(

        h4(
          t()$params,
          style = "font-size: 14px; color: #475569; margin-top: 0;"
        ),

        sliderInput(
          "shape",
          "Forma (α):",
          min = 0.5,
          max = 15,
          value = 2,
          step = 0.5,
          width = "100%"
        ),

        sliderInput(
          "scale",
          "Escala (β):",
          min = 0.5,
          max = 10,
          value = 2,
          step = 0.5,
          width = "100%"
        )
      ),


      # -----------------------------------------------------------------------
      # BETA
      # -----------------------------------------------------------------------

      beta = tagList(

        h4(
          t()$params,
          style = "font-size: 14px; color: #475569; margin-top: 0;"
        ),

        sliderInput(
          "shape1",
          "Forma (α):",
          min = 0.2,
          max = 15,
          value = 2,
          step = 0.2,
          width = "100%"
        ),

        sliderInput(
          "shape2",
          "Forma (β):",
          min = 0.2,
          max = 15,
          value = 2,
          step = 0.2,
          width = "100%"
        )
      ),


      # -----------------------------------------------------------------------
      # BINOMIAL
      # -----------------------------------------------------------------------

      binomial = tagList(

        h4(
          t()$params,
          style = "font-size: 14px; color: #475569; margin-top: 0;"
        ),

        sliderInput(
          "n",
          "Ensayos (n):",
          min = 1,
          max = 60,
          value = 20,
          step = 1,
          width = "100%"
        ),

        sliderInput(
          "p",
          "Prob. éxito (p):",
          min = 0.01,
          max = 0.99,
          value = 0.5,
          step = 0.01,
          width = "100%"
        )
      ),


      # -----------------------------------------------------------------------
      # POISSON
      # -----------------------------------------------------------------------

      poisson = tagList(

        h4(
          t()$params,
          style = "font-size: 14px; color: #475569; margin-top: 0;"
        ),

        sliderInput(
          "lambda",
          "Tasa (λ):",
          min = 0.1,
          max = 50,
          value = 10,
          step = 0.1,
          width = "100%"
        )
      ),


      # -----------------------------------------------------------------------
      # GEOMETRIC
      # -----------------------------------------------------------------------

      geometric = tagList(

        h4(
          t()$params,
          style = "font-size: 14px; color: #475569; margin-top: 0;"
        ),

        sliderInput(
          "p_geo",
          "Prob. éxito (p):",
          min = 0.01,
          max = 1,
          value = 0.4,
          step = 0.01,
          width = "100%"
        )
      ),


      # -----------------------------------------------------------------------
      # HYPERGEOMETRIC
      # -----------------------------------------------------------------------

      hypergeometric = tagList(

        h4(
          t()$params,
          style = "font-size: 14px; color: #475569; margin-top: 0;"
        ),

        sliderInput(
          "N_pop",
          "Población total (N):",
          min = 5,
          max = 100,
          value = 30,
          step = 1,
          width = "100%"
        ),

        sliderInput(
          "K_success",
          "Éxitos en población (K):",
          min = 1,
          max = 99,
          value = 12,
          step = 1,
          width = "100%"
        ),

        sliderInput(
          "n_sample",
          "Muestra tomada (n):",
          min = 1,
          max = 99,
          value = 8,
          step = 1,
          width = "100%"
        )
      ),


      # -----------------------------------------------------------------------
      # NEGATIVE BINOMIAL
      # -----------------------------------------------------------------------

      negbin = tagList(

        h4(
          t()$params,
          style = "font-size: 14px; color: #475569; margin-top: 0;"
        ),

        sliderInput(
          "r",
          "Éxitos requeridos (r):",
          min = 1,
          max = 25,
          value = 4,
          step = 1,
          width = "100%"
        ),

        sliderInput(
          "p_nb",
          "Prob. éxito (p):",
          min = 0.01,
          max = 1,
          value = 0.5,
          step = 0.01,
          width = "100%"
        )
      )
    )
  })


  # ===========================================================================
  # PROBABILITY CALCULATOR
  # ===========================================================================

  output$prob_calc_ui <- renderUI({

    tagList(

      h4(
        t()$prob_calc,
        style = paste(
          "font-size: 13px;",
          "font-weight: bold;",
          "color: #334155;",
          "margin-top: 0;"
        )
      ),

      fluidRow(

        column(
          6,

          numericInput(
            "c_lower",
            t()$lower_bound,
            value = 0,
            step = 1,
            width = "100%"
          )
        ),

        column(
          6,

          numericInput(
            "c_upper",
            t()$upper_bound,
            value = 1,
            step = 1,
            width = "100%"
          )
        )
      )
    )
  })


  # ===========================================================================
  # SUPPORT DEFINITION
  # ===========================================================================

  distribution_support <- reactive({

    req(input$model)

    switch(

      input$model,

      normal = list(
        lower = -Inf,
        upper = Inf
      ),

      student = list(
        lower = -Inf,
        upper = Inf
      ),

      chisq = list(
        lower = 0,
        upper = Inf
      ),

      exponential = list(
        lower = 0,
        upper = Inf
      ),

      gamma = list(
        lower = 0,
        upper = Inf
      ),

      beta = list(
        lower = 0,
        upper = 1
      ),

      binomial = list(
        lower = 0,
        upper = input$n
      ),

      poisson = list(
        lower = 0,
        upper = Inf
      ),

      geometric = list(
        lower = 0,
        upper = Inf
      ),

      hypergeometric = {

        req(
          input$N_pop,
          input$K_success,
          input$n_sample
        )

        N <- input$N_pop
        K <- input$K_success
        n <- input$n_sample

        list(
          lower = max(0, n - (N - K)),
          upper = min(n, K)
        )
      },

      negbin = list(
        lower = 0,
        upper = Inf
      )
    )
  })


  # ===========================================================================
  # PROBABILITY INPUT VALIDATION
  # ===========================================================================

  probability_validation <- reactive({

    req(
      input$model,
      input$family,
      input$c_lower,
      input$c_upper
    )

    low <- input$c_lower
    up <- input$c_upper

    req(
      length(low) == 1,
      length(up) == 1,
      is.numeric(low),
      is.numeric(up),
      !is.na(low),
      !is.na(up),
      is.finite(low),
      is.finite(up)
    )

    support <- distribution_support()

    req(
      length(support$lower) == 1,
      length(support$upper) == 1,
      is.numeric(support$lower),
      is.numeric(support$upper),
      !is.na(support$lower),
      !is.na(support$upper)
    )

    if (
      length(low) != 1 ||
      length(up) != 1 ||
      !is.numeric(low) ||
      !is.numeric(up) ||
      is.na(low) ||
      is.na(up) ||
      !is.finite(low) ||
      !is.finite(up)
    ) {
      return(
        list(
          valid = FALSE,
          message = paste(
            t()$validation_error,
            t()$continuous_domain
          )
        )
      )
    }

    # -------------------------------------------------------------------------
    # ORDER VALIDATION
    # -------------------------------------------------------------------------

    if (isTRUE(low > up)) {

      return(
        list(
          valid = FALSE,
          message = paste(
            t()$validation_error,
            t()$invalid_order
          )
        )
      )
    }


    # -------------------------------------------------------------------------
    # CONTINUOUS DISTRIBUTIONS
    # -------------------------------------------------------------------------

    if (input$family == "continuous") {

      if (
        low < support$lower ||
        up > support$upper
      ) {

        return(
          list(
            valid = FALSE,
            message = paste(
              t()$validation_error,
              t()$outside_domain,
              t()$continuous_domain
            )
          )
        )
      }

      return(
        list(
          valid = TRUE,
          adjusted = FALSE,
          lower = low,
          upper = up
        )
      )
    }


    # -------------------------------------------------------------------------
    # DISCRETE DISTRIBUTIONS
    # -------------------------------------------------------------------------

    if (
      low < support$lower ||
      up > support$upper
    ) {
      return(
        list(
          valid = FALSE,
          message = paste(
            t()$validation_error,
            t()$outside_domain,
            t()$discrete_domain
          )
        )
      )
    }

    # A single non-integer value is interpreted as the corresponding discrete
    # point below it, as an explicit educational adjustment.
    if (low == up && low != floor(low)) {
      adjusted_low <- floor(low)
      adjusted_up <- adjusted_low
      empty <- FALSE
    } else {
      adjusted_low <- ceiling(low)
      adjusted_up <- floor(up)
      empty <- adjusted_low > adjusted_up
    }

    if (
      adjusted_low < support$lower ||
      adjusted_up > support$upper
    ) {
      return(
        list(
          valid = FALSE,
          message = paste(
            t()$validation_error,
            t()$outside_domain,
            t()$discrete_domain
          )
        )
      )
    }

    adjusted <- (
      low != adjusted_low ||
        up != adjusted_up
    )

    list(
      valid = TRUE,
      adjusted = adjusted,
      empty = empty,
      lower = adjusted_low,
      upper = adjusted_up,
      original_lower = low,
      original_upper = up
    )
  })


  # ===========================================================================
  # VALIDATION MESSAGE
  # ===========================================================================

  output$validation_panel <- renderUI({

    val <- probability_validation()

    if (!val$valid) {

      tags$div(
        class = "validation-box",
        strong(val$message)
      )

    } else {

      NULL
    }
  })


  # ===========================================================================
  # DISCRETE ADJUSTMENT MESSAGE
  # ===========================================================================

  output$adjustment_panel <- renderUI({

    val <- probability_validation()

    if (
      val$valid &&
      input$family == "discrete" &&
      isTRUE(val$adjusted)
    ) {

      message_text <- if (isTRUE(val$empty)) {
        t()$no_integer_interval
      } else {
        paste0(
          t()$adjustment_message,
          " [",
          val$lower,
          ", ",
          val$upper,
          "]"
        )
      }

      tags$div(
        class = "adjustment-box",
        tags$strong(t()$adjusted_interval),
        tags$br(),
        message_text
      )

    } else {

      NULL
    }
  })


  # ===========================================================================
  # DISTRIBUTION EQUATIONS AND DEFINITIONS
  # ===========================================================================

  equations <- reactive({
    req(input$model)

    fmt <- function(x) {
      formatC(x, format = "g", digits = 4, drop0trailing = TRUE)
    }

    power_term <- function(base, exponent) {
      if (abs(exponent) < 1e-10) {
        return("")
      }
      if (abs(exponent - 1) < 1e-10) {
        return(base)
      }
      paste0(base, "^{", fmt(exponent), "}")
    }

    coef_term <- function(coef) {
      if (abs(coef - 1) < 1e-10) {
        return("")
      }
      fmt(coef)
    }

    switch(
      input$model,

      # -----------------------------------------------------------------------
      # NORMAL
      # -----------------------------------------------------------------------
      normal = {
        req(input$mean, input$sd)
        mu <- input$mean
        sigma <- input$sd
        coef <- 1 / (sigma * sqrt(2 * pi))
        denom <- 2 * sigma^2

        centered_x <- if (abs(mu) < 1e-10) {
          "x"
        } else if (mu > 0) {
          paste0("(x-", fmt(mu), ")")
        } else {
          paste0("(x+", fmt(abs(mu)), ")")
        }

        list(
          symbolic =
            "$$f(x)=\\frac{1}{\\sigma\\sqrt{2\\pi}}\\exp\\left(-\\frac{(x-\\mu)^2}{2\\sigma^2}\\right)$$",
          numeric = paste0(
            "$$f(x)=", coef_term(coef),
            "\\exp\\left(-\\frac{", centered_x, "^2}{",
            fmt(denom), "}\\right)$$"
          ),
          support = "\\(x \\in (-\\infty, \\infty)\\)",
          variable = if (input$lang == "es") {
            "X representa una variable continua distribuida alrededor de una media μ."
          } else {
            "X represents a continuous variable distributed around a mean μ."
          },
          note = NULL
        )
      },

      # -----------------------------------------------------------------------
      # STUDENT T
      # -----------------------------------------------------------------------
      student = {
        req(input$df_t)
        nu <- input$df_t
        coef <- gamma((nu + 1) / 2) /
          (sqrt(nu * pi) * gamma(nu / 2))
        exponent <- -(nu + 1) / 2

        list(
          symbolic =
            "$$f(x)=\\frac{\\Gamma\\left(\\frac{\\nu+1}{2}\\right)}{\\sqrt{\\nu\\pi}\\Gamma\\left(\\frac{\\nu}{2}\\right)}\\left(1+\\frac{x^2}{\\nu}\\right)^{-\\frac{\\nu+1}{2}}$$",
          numeric = paste0(
            "$$f(x)=", fmt(coef),
            "\\left(1+\\frac{x^2}{", fmt(nu), "}\\right)^{", fmt(exponent), "}$$"
          ),
          support = "\\(x \\in (-\\infty, \\infty)\\)",
          variable = if (input$lang == "es") {
            "X representa una variable continua con ν grados de libertad."
          } else {
            "X represents a continuous variable with ν degrees of freedom."
          },
          note = NULL
        )
      },

      # -----------------------------------------------------------------------
      # CHI-SQUARE
      # -----------------------------------------------------------------------
      chisq = {
        req(input$df_chi)
        k <- input$df_chi
        coef <- 1 / (2^(k / 2) * gamma(k / 2))
        exponent <- k / 2 - 1

        list(
          symbolic =
            "$$f(x)=\\frac{x^{k/2-1}e^{-x/2}}{2^{k/2}\\Gamma(k/2)}$$",
          numeric = paste0(
            "$$f(x)=", coef_term(coef),
            power_term("x", exponent),
            "e^{-x/2}$$"
          ),
          support = "\\(x \\in [0, \\infty)\\)",
          variable = if (input$lang == "es") {
            "X representa una variable continua definida como la suma de cuadrados de k variables normales estándar independientes."
          } else {
            "X represents a continuous variable defined as the sum of squares of k independent standard normal variables."
          },
          note = NULL
        )
      },

      # -----------------------------------------------------------------------
      # EXPONENTIAL
      # -----------------------------------------------------------------------
      exponential = {
        req(input$rate)
        lambda <- input$rate

        list(
          symbolic = "$$f(x)=\\lambda e^{-\\lambda x}$$",
          numeric = if (abs(lambda - 1) < 1e-10) {
            "$$f(x)=e^{-x}$$"
          } else {
            paste0(
              "$$f(x)=", fmt(lambda),
              "e^{-", fmt(lambda), "x}$$"
            )
          },
          support = "\\(x \\in [0, \\infty)\\)",
          variable = if (input$lang == "es") {
            "X representa una variable continua no negativa; en un proceso de eventos con tasa constante, puede representar el tiempo de espera hasta la ocurrencia de un evento."
          } else {
            "X represents a non-negative continuous variable; in a constant-rate event process, it can represent the waiting time until an event occurs."
          },
          note = if (input$lang == "es") {
            "Esta aplicación utiliza la parametrización mediante tasa λ. Una parametrización alternativa utiliza el parámetro de escala β, donde λ = 1/β."
          } else {
            "This application uses the rate parameter λ. An alternative parameterization uses the scale parameter β, where λ = 1/β."
          }
        )
      },

      # -----------------------------------------------------------------------
      # GAMMA
      # -----------------------------------------------------------------------
      gamma = {
        req(input$shape, input$scale)
        alpha <- input$shape
        beta <- input$scale
        coef <- 1 / (beta^alpha * gamma(alpha))

        list(
          symbolic =
            "$$f(x)=\\frac{x^{\\alpha-1}e^{-x/\\beta}}{\\beta^\\alpha\\Gamma(\\alpha)}$$",
          numeric = paste0(
            "$$f(x)=", coef_term(coef),
            power_term("x", alpha - 1),
            if (abs(beta - 1) < 1e-10) {
              "e^{-x}"
            } else {
              paste0("e^{-x/", fmt(beta), "}")
            },
            "$$"
          ),
          support = "\\(x \\in [0, \\infty)\\)",
          variable = if (input$lang == "es") {
            "X representa una variable continua positiva modelada mediante parámetros de forma α y escala β."
          } else {
            "X represents a positive continuous variable modeled using shape α and scale β parameters."
          },
          note = NULL
        )
      },

      # -----------------------------------------------------------------------
      # BETA
      # -----------------------------------------------------------------------
      beta = {
        req(input$shape1, input$shape2)
        alpha <- input$shape1
        beta_param <- input$shape2
        coef <- 1 / beta(alpha, beta_param)

        list(
          symbolic =
            "$$f(x)=\\frac{x^{\\alpha-1}(1-x)^{\\beta-1}}{B(\\alpha,\\beta)}$$",
          numeric = {
            x_term <- power_term("x", alpha - 1)
            one_minus_x_term <- power_term("(1-x)", beta_param - 1)

            terms <- c(
              if (abs(coef - 1) < 1e-10) NULL else fmt(coef),
              if (nzchar(x_term)) x_term else NULL,
              if (nzchar(one_minus_x_term)) one_minus_x_term else NULL
            )

            expression <- if (length(terms) == 0) {
              "1"
            } else {
              paste0(terms, collapse = "")
            }

            paste0("$$f(x)=", expression, "$$")
          },
          support = "\\(x \\in [0,1]\\)",
          variable = if (input$lang == "es") {
            "X representa una variable continua limitada al intervalo [0, 1], frecuentemente utilizada para proporciones y probabilidades."
          } else {
            "X represents a continuous variable bounded between 0 and 1, commonly used for proportions and probabilities."
          },
          note = NULL
        )
      },

      # -----------------------------------------------------------------------
      # BINOMIAL
      # -----------------------------------------------------------------------
      binomial = {
        req(input$n, input$p)
        n <- input$n
        p <- input$p

        list(
          symbolic = "$$P(X=x)=\\binom{n}{x}p^x(1-p)^{n-x}$$",
          numeric = paste0(
            "$$P(X=x)=\\binom{", n, "}{x}", fmt(p), "^x",
            "(1-", fmt(p), ")^{", n, "-x}$$"
          ),
          support = paste0("\\(x \\in \\{0,1,\\dots,", n, "\\}\\)"),
          variable = if (input$lang == "es") {
            "X: número de éxitos en n ensayos independientes, cada uno con probabilidad de éxito p."
          } else {
            "X: number of successes in n independent trials, each with success probability p."
          },
          note = NULL
        )
      },

      # -----------------------------------------------------------------------
      # POISSON
      # -----------------------------------------------------------------------
      poisson = {
        req(input$lambda)
        lambda <- input$lambda

        list(
          symbolic =
            "$$P(X=x)=\\frac{e^{-\\lambda}\\lambda^x}{x!}$$",
          numeric =
            paste0(
              "$$P(X=x)=\\frac{e^{-",
              fmt(lambda),
              "}",
              fmt(lambda),
              "^x}{x!}$$"
            ),
          support = "\\(x \\in \\{0,1,2,\\dots\\}\\)",
          variable = if (input$lang == "es") {
            "X: número de eventos que ocurren en un intervalo fijo cuando estos ocurren con una tasa promedio λ."
          } else {
            "X: number of events occurring in a fixed interval when events occur at an average rate λ."
          },
          note = NULL
        )
      },

      # -----------------------------------------------------------------------
      # GEOMETRIC
      # -----------------------------------------------------------------------
      geometric = {
        req(input$p_geo)

        p <- input$p_geo

        list(
          symbolic = "$$P(X=x)=(1-p)^x p$$",
          numeric = paste0(
            "$$P(X=x)=(1-", fmt(p), ")^x", fmt(p), "$$"
          ),
          support = "\\(x \\in \\{0,1,2,\\dots\\}\\)",
          variable = if (input$lang == "es") {
            "X: número de fracasos observados antes del primer éxito."
          } else {
            "X: number of failures observed before the first success."
          },
          note = if (input$lang == "es") {
            "Bajo esta parametrización, utilizada por R, la distribución Geométrica es un caso particular de la Binomial Negativa con r = 1."
          } else {
            "Under this parameterization, used by R, the Geometric distribution is a special case of the Negative Binomial distribution with r = 1."
          }
        )
      },

      # -----------------------------------------------------------------------
      # HYPERGEOMETRIC
      # -----------------------------------------------------------------------
      hypergeometric = {
        req(input$N_pop, input$K_success, input$n_sample)

        N <- input$N_pop
        K <- input$K_success
        n <- input$n_sample

        list(
          symbolic =
            "$$P(X=x)=\\frac{\\binom{K}{x}\\binom{N-K}{n-x}}{\\binom{N}{n}}$$",
          numeric = paste0(
            "$$P(X=x)=\\frac{\\binom{", K, "}{x}\\binom{", N-K,
            "}{", n, "-x}}{\\binom{", N, "}{", n, "}}$$"
          ),
          support = paste0(
            "\\(x \\in \\{", max(0, n - (N - K)), ",\\dots,", min(n, K), "\\}\\)"
          ),
          variable = if (input$lang == "es") {
            "X: número de éxitos obtenidos en una muestra de tamaño n extraída sin reemplazo de una población finita de tamaño N."
          } else {
            "X: number of successes obtained in a sample of size n drawn without replacement from a finite population of size N."
          },
          note = NULL
        )
      },

      # -----------------------------------------------------------------------
      # NEGATIVE BINOMIAL
      # -----------------------------------------------------------------------
      negbin = {
        req(input$r, input$p_nb)
        r <- input$r
        p <- input$p_nb

        list(
          symbolic =
            "$$P(X=x)=\\binom{x+r-1}{x}p^r(1-p)^x$$",
          numeric = paste0(
            "$$P(X=x)=\\binom{x+", r, "-1}{x}", fmt(p), "^", r,
            "(1-", fmt(p), ")^x$$"
          ),
          support = "\\(x \\in \\{0,1,2,\\dots\\}\\)",
          variable = if (input$lang == "es") {
            "X: número de fracasos observados antes de alcanzar r éxitos."
          } else {
            "X: number of failures observed before achieving r successes."
          },
          note = NULL
        )
      }
    )
  })
  # ===========================================================================
  # EQUATION PANEL
  # ===========================================================================

  output$equation_panel <- renderUI({

    eq <- equations()

    req(eq)

    tagList(

      tags$div(

        class = "eq-box",

        tags$div(
          class = "eq-line",

          tags$span(
            class = "eq-label",
            paste0(t()$eq_symbolic, " ")
          ),

          withMathJax(
            HTML(eq$symbolic)
          )
        ),

        tags$div(
          class = "eq-line",

          tags$span(
            class = "eq-label",
            paste0(t()$eq_numeric, " ")
          ),

          withMathJax(
            HTML(eq$numeric)
          )
        ),

        tags$hr(
          style = "margin: 8px 0;"
        ),

        tags$div(
          class = "eq-line",

          tags$span(
            class = "eq-label",
            paste0(t()$support_label, " ")
          ),

          withMathJax(
            HTML(eq$support)
          )
        ),

        tags$div(
          class = "eq-line definition-text",

          tags$span(
            class = "eq-label",
            paste0(t()$variable_label, " ")
          ),

          eq$variable
        ),

        if (!is.null(eq$note)) {

          tags$div(
            class = "eq-line definition-text",

            tags$span(
              class = "eq-label",
              paste0(t()$parameter_note, " ")
            ),

            eq$note
          )
        }
      )
    )
  })


  # ===========================================================================
  # DISTRIBUTION DATA
  # ===========================================================================

  model_data <- reactive({

    req(input$family)
    req(input$model)

    validation <- probability_validation()

    mod <- input$model

    continuous_range <- function(quantile_fun, bounded = FALSE) {
      if (bounded) {
        return(c(0, 1))
      }
      base <- quantile_fun(c(0.001, 0.999))
      if (validation$valid) {
        c(
          min(base[1], validation$lower),
          max(base[2], validation$upper)
        )
      } else {
        base
      }
    }


    # =========================================================================
    # NORMAL
    # =========================================================================

    if (mod == "normal") {

      req(input$mean, input$sd)

      mu <- input$mean
      sigma <- input$sd

      X_range <- continuous_range(
        function(p) qnorm(p, mu, sigma)
      )

      X <- seq(
        X_range[1],
        X_range[2],
        length.out = 500
      )

      df <- data.frame(
        Xi = X,
        f_x = dnorm(X, mu, sigma),
        F_x = pnorm(X, mu, sigma)
      )

      prob_val <- if (validation$valid) {
        pnorm(validation$upper, mu, sigma) -
          pnorm(validation$lower, mu, sigma)
      } else {
        NA
      }

      return(
        list(
          df = df,
          type = "continuous",
          mean = mu,
          var = sigma^2,
          std = sigma,
          median = mu,
          mode = as.character(mu),
          skew = 0,
          kurt = 0,
          prob_val = prob_val,
          quantile_fun = function(p) qnorm(p, mu, sigma)
        )
      )
    }


    # =========================================================================
    # STUDENT T
    # =========================================================================

    if (mod == "student") {

      req(input$df_t)

      nu <- input$df_t

      X_range <- continuous_range(function(p) qt(p, nu))

      X <- seq(
        X_range[1],
        X_range[2],
        length.out = 500
      )

      df <- data.frame(
        Xi = X,
        f_x = dt(X, nu),
        F_x = pt(X, nu)
      )

      variance <- if (nu > 2) {
        nu / (nu - 2)
      } else {
        NA
      }

      std <- if (nu > 2) {
        sqrt(variance)
      } else {
        NA
      }

      skew <- if (nu > 3) {
        0
      } else {
        NA
      }

      kurt <- if (nu > 4) {
        6 / (nu - 4)
      } else {
        NA
      }

      prob_val <- if (validation$valid) {
        pt(validation$upper, nu) -
          pt(validation$lower, nu)
      } else {
        NA
      }

      return(
        list(
          df = df,
          type = "continuous",
          mean = if (nu > 1) 0 else NA,
          var = variance,
          std = std,
          median = 0,
          mode = "0",
          skew = skew,
          kurt = kurt,
          prob_val = prob_val,
          quantile_fun = function(p) qt(p, nu)
        )
      )
    }


    # =========================================================================
    # CHI-SQUARE
    # =========================================================================

    if (mod == "chisq") {

      req(input$df_chi)

      k <- input$df_chi

      X_range <- continuous_range(function(p) qchisq(p, k))

      X <- seq(
        X_range[1],
        X_range[2],
        length.out = 500
      )

      df <- data.frame(
        Xi = X,
        f_x = dchisq(X, k),
        F_x = pchisq(X, k)
      )

      prob_val <- if (validation$valid) {
        pchisq(validation$upper, k) -
          pchisq(validation$lower, k)
      } else {
        NA
      }

      mode_value <- if (k >= 2) {
        as.character(k - 2)
      } else {
        "0"
      }

      return(
        list(
          df = df,
          type = "continuous",
          mean = k,
          var = 2 * k,
          std = sqrt(2 * k),
          median = qchisq(0.5, k),
          mode = mode_value,
          skew = sqrt(8 / k),
          kurt = 12 / k,
          prob_val = prob_val,
          quantile_fun = function(p) qchisq(p, k)
        )
      )
    }


    # =========================================================================
    # EXPONENTIAL
    # =========================================================================

    if (mod == "exponential") {

      req(input$rate)

      lambda <- input$rate

      X_range <- continuous_range(function(p) qexp(p, lambda))

      X <- seq(
        X_range[1],
        X_range[2],
        length.out = 500
      )

      df <- data.frame(
        Xi = X,
        f_x = dexp(X, lambda),
        F_x = pexp(X, lambda)
      )

      prob_val <- if (validation$valid) {
        pexp(validation$upper, lambda) -
          pexp(validation$lower, lambda)
      } else {
        NA
      }

      return(
        list(
          df = df,
          type = "continuous",
          mean = 1 / lambda,
          var = 1 / lambda^2,
          std = 1 / lambda,
          median = log(2) / lambda,
          mode = "0",
          skew = 2,
          kurt = 6,
          prob_val = prob_val,
          quantile_fun = function(p) qexp(p, lambda)
        )
      )
    }


    # =========================================================================
    # GAMMA
    # =========================================================================

    if (mod == "gamma") {

      req(input$shape, input$scale)

      alpha <- input$shape
      beta <- input$scale

      X_range <- continuous_range(
        function(p) qgamma(
          p,
          shape = alpha,
          scale = beta
        )
      )

      X <- seq(
        X_range[1],
        X_range[2],
        length.out = 500
      )

      df <- data.frame(
        Xi = X,
        f_x = dgamma(
          X,
          shape = alpha,
          scale = beta
        ),
        F_x = pgamma(
          X,
          shape = alpha,
          scale = beta
        )
      )

      mode_value <- if (alpha >= 1) {
        as.character((alpha - 1) * beta)
      } else {
        "0"
      }

      prob_val <- if (validation$valid) {
        pgamma(
          validation$upper,
          shape = alpha,
          scale = beta
        ) -
          pgamma(
            validation$lower,
            shape = alpha,
            scale = beta
          )
      } else {
        NA
      }

      return(
        list(
          df = df,
          type = "continuous",
          mean = alpha * beta,
          var = alpha * beta^2,
          std = sqrt(alpha) * beta,
          median = qgamma(
            0.5,
            shape = alpha,
            scale = beta
          ),
          mode = mode_value,
          skew = 2 / sqrt(alpha),
          kurt = 6 / alpha,
          prob_val = prob_val,
          quantile_fun = function(p) {
            qgamma(
              p,
              shape = alpha,
              scale = beta
            )
          }
        )
      )
    }


    # =========================================================================
    # BETA
    # =========================================================================

    if (mod == "beta") {

      req(input$shape1, input$shape2)

      alpha <- input$shape1
      beta <- input$shape2

      X_range <- c(0, 1)

      X <- seq(
        X_range[1],
        X_range[2],
        length.out = 500
      )

      df <- data.frame(
        Xi = X,
        f_x = dbeta(X, alpha, beta),
        F_x = pbeta(X, alpha, beta)
      )

      # Mode
      mode_value <- dplyr::case_when(

        alpha > 1 && beta > 1 ~
          as.character(
            (alpha - 1) /
              (alpha + beta - 2)
          ),

        alpha < 1 && beta < 1 ~
          if (input$lang == "es") {
            "Dos modas: 0 y 1"
          } else {
            "Two modes: 0 and 1"
          },

        alpha <= 1 && beta > 1 ~ "0",

        alpha > 1 && beta <= 1 ~ "1",

        alpha == 1 && beta == 1 ~
          if (input$lang == "es") {
            "No única (Uniforme)"
          } else {
            "Not unique (Uniform)"
          },

        TRUE ~ NA_character_
      )

      # Excess kurtosis
      beta_kurtosis <-
        6 * (
          (alpha - beta)^2 * (alpha + beta + 1) -
            alpha * beta * (alpha + beta + 2)
        ) /
        (
          alpha * beta *
            (alpha + beta + 2) *
            (alpha + beta + 3)
        )

      prob_val <- if (validation$valid) {
        pbeta(
          validation$upper,
          alpha,
          beta
        ) -
          pbeta(
            validation$lower,
            alpha,
            beta
          )
      } else {
        NA
      }

      return(
        list(
          df = df,
          type = "continuous",
          mean = alpha / (alpha + beta),
          var =
            alpha * beta /
            (
              (alpha + beta)^2 *
                (alpha + beta + 1)
            ),
          std = sqrt(
            alpha * beta /
              (
                (alpha + beta)^2 *
                  (alpha + beta + 1)
              )
          ),
          median = qbeta(0.5, alpha, beta),
          mode = mode_value,
          skew =
            2 * (beta - alpha) *
            sqrt(alpha + beta + 1) /
            (
              (alpha + beta + 2) *
                sqrt(alpha * beta)
            ),
          kurt = beta_kurtosis,
          prob_val = prob_val,
          quantile_fun = function(p) {
            qbeta(p, alpha, beta)
          }
        )
      )
    }


    # =========================================================================
    # BINOMIAL
    # =========================================================================

    if (mod == "binomial") {

      req(input$n, input$p)

      n <- input$n
      p <- input$p

      X <- 0:n

      df <- data.frame(
        Xi = X,
        f_x = dbinom(X, n, p),
        F_x = pbinom(X, n, p)
      )

      mode_raw <- (n + 1) * p

      mode_value <- if (
        abs(mode_raw - round(mode_raw)) < 1e-10 &&
        mode_raw >= 1 &&
        mode_raw <= n
      ) {

        paste0(
          as.integer(mode_raw - 1),
          ", ",
          as.integer(mode_raw)
        )

      } else {

        as.character(floor(mode_raw))
      }

      prob_val <- if (validation$valid && isTRUE(validation$empty)) {
        0
      } else if (validation$valid) {
        sum(
          dbinom(
            validation$lower:validation$upper,
            n,
            p
          )
        )
      } else {
        NA
      }

      return(
        list(
          df = df,
          type = "discrete",
          mean = n * p,
          var = n * p * (1 - p),
          std = sqrt(n * p * (1 - p)),
          median = round(n * p),
          mode = mode_value,
          skew =
            (1 - 2 * p) /
            sqrt(n * p * (1 - p)),
          kurt =
            (
              1 - 6 * p * (1 - p)
            ) /
            (
              n * p * (1 - p)
            ),
          prob_val = prob_val
        )
      )
    }


    # =========================================================================
    # POISSON
    # =========================================================================

    if (mod == "poisson") {

      req(input$lambda)

      lambda <- input$lambda

      upper_x <- qpois(0.999, lambda)

      X <- 0:upper_x

      df <- data.frame(
        Xi = X,
        f_x = dpois(X, lambda),
        F_x = ppois(X, lambda)
      )

      mode_value <- if (
        abs(lambda - round(lambda)) < 1e-10 &&
        lambda > 0
      ) {

        paste0(
          as.integer(lambda - 1),
          ", ",
          as.integer(lambda)
        )

      } else {

        as.character(floor(lambda))
      }

      prob_val <- if (validation$valid && isTRUE(validation$empty)) {
        0
      } else if (validation$valid) {
        sum(
          dpois(
            validation$lower:validation$upper,
            lambda
          )
        )
      } else {
        NA
      }

      return(
        list(
          df = df,
          type = "discrete",
          mean = lambda,
          var = lambda,
          std = sqrt(lambda),
          median = floor(lambda + 1 / 3 - 0.02 / lambda),
          mode = mode_value,
          skew = 1 / sqrt(lambda),
          kurt = 1 / lambda,
          prob_val = prob_val
        )
      )
    }


    # =========================================================================
    # GEOMETRIC
    # =========================================================================

    if (mod == "geometric") {

      req(input$p_geo)

      p <- input$p_geo

      upper_x <- qgeom(0.999, p)

      X <- 0:upper_x

      df <- data.frame(
        Xi = X,
        f_x = dgeom(X, p),
        F_x = pgeom(X, p)
      )

      prob_val <- if (validation$valid && isTRUE(validation$empty)) {
        0
      } else if (validation$valid) {
        sum(
          dgeom(
            validation$lower:validation$upper,
            p
          )
        )
      } else {
        NA
      }

      return(
        list(
          df = df,
          type = "discrete",
          mean = (1 - p) / p,
          var = (1 - p) / p^2,
          std = sqrt((1 - p) / p^2),
          median = ceiling(
            -log(2) / log(1 - p)
          ) - 1,
          mode = "0",
          skew = if (p < 1) (2 - p) / sqrt(1 - p) else NA,
          kurt = if (p < 1) 6 + p^2 / (1 - p) else NA,
          prob_val = prob_val
        )
      )
    }


    # =========================================================================
    # HYPERGEOMETRIC
    # =========================================================================

    if (mod == "hypergeometric") {

      req(input$N_pop, input$K_success, input$n_sample)

      N <- input$N_pop
      K <- input$K_success
      n <- input$n_sample

      validate(
        need(
          K <= N,
          "K cannot exceed N"
        ),

        need(
          n <= N,
          "n cannot exceed N"
        )
      )

      min_x <- max(
        0,
        n - (N - K)
      )

      max_x <- min(
        n,
        K
      )

      X <- min_x:max_x

      df <- data.frame(
        Xi = X,
        f_x = dhyper(
          X,
          K,
          N - K,
          n
        ),
        F_x = phyper(
          X,
          K,
          N - K,
          n
        )
      )

      mode_raw <-
        (n + 1) *
        (K + 1) /
        (N + 2)

      if (
        abs(mode_raw - round(mode_raw)) < 1e-10
      ) {

        mode_value <- paste0(
          as.integer(mode_raw - 1),
          ", ",
          as.integer(mode_raw)
        )

      } else {

        mode_value <- as.character(
          floor(mode_raw)
        )
      }

      mean_h <- n * K / N

      variance_h <-
        n *
        (K / N) *
        (1 - K / N) *
        ((N - n) / (N - 1))

      mu2 <- sum((X - mean_h)^2 * df$f_x)
      mu3 <- sum((X - mean_h)^3 * df$f_x)
      mu4 <- sum((X - mean_h)^4 * df$f_x)

      skew_h <- if (mu2 > 0) {
        mu3 / mu2^(3 / 2)
      } else {
        NA
      }

      kurt_h <- if (mu2 > 0) {
        mu4 / mu2^2 - 3
      } else {
        NA
      }

      prob_val <- if (validation$valid && isTRUE(validation$empty)) {
        0
      } else if (validation$valid) {
        sum(
          dhyper(
            validation$lower:validation$upper,
            K,
            N - K,
            n
          )
        )
      } else {
        NA
      }

      return(
        list(
          df = df,
          type = "discrete",
          mean = mean_h,
          var = variance_h,
          std = sqrt(variance_h),
          median = round(mean_h),
          mode = mode_value,
          skew = skew_h,
          kurt = kurt_h,
          prob_val = prob_val
        )
      )
    }


    # =========================================================================
    # NEGATIVE BINOMIAL
    # =========================================================================

    if (mod == "negbin") {

      req(input$r, input$p_nb)

      r <- input$r
      p <- input$p_nb

      upper_x <- qnbinom(
        0.999,
        size = r,
        prob = p
      )

      X <- 0:upper_x

      df <- data.frame(
        Xi = X,
        f_x = dnbinom(
          X,
          size = r,
          prob = p
        ),
        F_x = pnbinom(
          X,
          size = r,
          prob = p
        )
      )

      mode_value <- if (r <= 1) {

        "0"

      } else {

        as.character(
          floor(
            (r - 1) *
              (1 - p) /
              p
          )
        )
      }

      prob_val <- if (validation$valid && isTRUE(validation$empty)) {
        0
      } else if (validation$valid) {
        sum(
          dnbinom(
            validation$lower:validation$upper,
            size = r,
            prob = p
          )
        )
      } else {
        NA
      }

      return(
        list(
          df = df,
          type = "discrete",
          mean = r * (1 - p) / p,
          var = r * (1 - p) / p^2,
          std = sqrt(
            r * (1 - p) / p^2
          ),
          median = NA,
          mode = mode_value,
          skew = if (p < 1) {
            (2 - p) / sqrt(r * (1 - p))
          } else {
            NA
          },
          kurt = if (p < 1) {
            6 / r + p^2 / (r * (1 - p))
          } else {
            NA
          },
          prob_val = prob_val
        )
      )
    }
  })


  # ===========================================================================
  # TAB TITLES
  # ===========================================================================

  output$density_tab_title <- renderUI({

    req(input$family)

    if (input$family == "continuous") {

      HTML(t()$pdf_tab)

    } else {

      HTML(t()$pmf_tab)
    }
  })


  output$table_tab_title <- renderUI({

    req(input$family)

    if (input$family == "continuous") {

      HTML(t()$quantile_tab)

    } else {

      HTML(t()$probability_tab)
    }
  })


  # ===========================================================================
  # PROBABILITY RESULT
  # ===========================================================================

  output$prob_result_panel <- renderUI({

    validation <- probability_validation()

    if (!validation$valid) {
      return(NULL)
    }

    res <- model_data()

    req(res)

    probability <- round(
      res$prob_val,
      6
    )

    is_point <- (
      res$type == "discrete" &&
        validation$lower == validation$upper
    )

    label <- if (is_point) {
      paste0(
        "P(X = ",
        validation$lower,
        ")"
      )
    } else if (isTRUE(validation$empty)) {
      paste0(
        "P(",
        validation$original_lower,
        " ≤ X ≤ ",
        validation$original_upper,
        ")"
      )
    } else {
      paste0(
        "P(",
        validation$lower,
        " ≤ X ≤ ",
        validation$upper,
        ")"
      )
    }

    tags$div(
      class = "prob-box",
      tags$span(paste0(label, " = ", probability))
    )
  })


  # ===========================================================================
  # STATISTICS
  # ===========================================================================

  output$stats_summary <- renderText({

    res <- model_data()

    req(res)

    format_value <- function(value) {

      if (
        is.null(value) ||
        is.na(value) ||
        is.infinite(value)
      ) {

        t()$undefined

      } else if (is.character(value)) {

        value

      } else {

        round(value, 4)
      }
    }

    paste0(

      t()$mean,
      ": ",
      format_value(res$mean),

      "\n",

      t()$variance,
      ": ",
      format_value(res$var),

      "\n",

      t()$std,
      ": ",
      format_value(res$std),

      "\n",

      t()$median,
      ": ",
      format_value(res$median),

      "\n",

      t()$mode,
      ": ",
      format_value(res$mode),

      "\n",

      t()$skewness,
      ": ",
      format_value(res$skew),

      "\n",

      t()$kurtosis,
      ": ",
      format_value(res$kurt)
    )
  })


  # ===========================================================================
  # DENSITY / MASS FUNCTION PLOT
  # ===========================================================================

  output$plot_density <- renderPlotly({

    res <- model_data()

    req(res)

    df <- res$df %>%
      arrange(Xi)

    validation <- probability_validation()


    # =========================================================================
    # CONTINUOUS DISTRIBUTIONS
    # =========================================================================

    if (res$type == "continuous") {

      df$tooltip_txt <- paste0(
        "X = ",
        round(df$Xi, 4),
        "<br>f(x) = ",
        round(df$f_x, 6)
      )

      p <- ggplot(
        df,
        aes(
          x = Xi,
          y = f_x,
          group = 1,
          text = tooltip_txt
        )
      ) +
        geom_line(
          color = "#4f46e5",
          linewidth = 1.1
        ) +
        labs(
          title = t()$pdf_tab,
          x = t()$x_axis,
          y = t()$y_pdf
        ) +
        theme_minimal()


      # -----------------------------------------------------------------------
      # INTERVAL VISUALIZATION
      # -----------------------------------------------------------------------

      if (validation$valid) {

        low <- validation$lower
        up <- validation$upper

        interval_x <- sort(unique(c(
          low,
          df$Xi[df$Xi > low & df$Xi < up],
          up
        )))

        interval_y <- approx(
          df$Xi,
          df$f_x,
          xout = interval_x,
          rule = 2
        )$y

        sub_df <- data.frame(
          Xi = interval_x,
          f_x = interval_y
        )

        probability_label <- paste0(
          "P(", low, " ≤ X ≤ ", up, ") = ",
          formatC(res$prob_val, format = "f", digits = 4)
        )

        p <- p +
          geom_area(
            data = sub_df,
            aes(
              x = Xi,
              y = f_x,
              fill = probability_label
            ),
            inherit.aes = FALSE,
            alpha = 0.25
          ) +
          scale_fill_manual(
            values = setNames("#4f46e5", probability_label),
            name = NULL
          )

        p <- p +
          geom_vline(
            xintercept = low,
            linetype = "dashed",
            color = "#475569"
          ) +

          geom_vline(
            xintercept = up,
            linetype = "dashed",
            color = "#475569"
          )
      }


      # =========================================================================
      # DISCRETE DISTRIBUTIONS
      # =========================================================================

    } else {

      if (validation$valid) {

        low <- validation$lower
        up <- validation$upper

        df <- df %>%

          mutate(

            highlight = case_when(

              Xi >= low &
                Xi <= up ~ "selected",

              TRUE ~ "other"
            )
          )

      } else {

        df <- df %>%
          mutate(
            highlight = "other"
          )
      }

      df$tooltip_txt <- paste0(
        "X = ",
        df$Xi,
        "<br>P(X = x) = ",
        round(df$f_x, 4)
      )

      legend_selected <- if (
        validation$valid &&
        validation$lower == validation$upper
      ) {
        t()$legend_point
      } else {
        t()$legend_interval
      }

      p <- ggplot(

        df,

        aes(
          x = Xi,
          y = f_x,
          fill = highlight,
          color = highlight,
          text = tooltip_txt
        )

      ) +

        geom_col(
          width = 0.65,
          alpha = 0.85
        ) +

        scale_fill_manual(

          values = c(
            selected = "#4f46e5",
            other = "#f1f5f9"
          ),

          labels = c(
            selected = legend_selected,
            other = t()$legend_other
          ),

          name = ""
        ) +

        scale_color_manual(

          values = c(
            selected = "#4f46e5",
            other = "#cbd5e1"
          ),

          guide = "none"
        ) +

        labs(
          title = t()$pmf_tab,
          x = t()$x_axis,
          y = t()$y_pmf
        ) +

        theme_minimal() +

        theme(
          legend.position = "bottom",
          legend.margin = margin(t = 2),
          legend.box.margin = margin(t = 4)
        )
    }

    ggplotly(
      p,
      tooltip = "text"
    ) %>%

      layout(
        margin = list(b = 100),
        legend = list(
          y = -0.2,
          x = 0.5,
          yanchor = "top",
          xanchor = "center"
        )
      )

  })


  # ===========================================================================
  # CUMULATIVE DISTRIBUTION FUNCTION
  # ===========================================================================

  output$plot_cdf <- renderPlotly({

    res <- model_data()

    req(res)

    df <- res$df %>%
      arrange(Xi)


    # =========================================================================
    # CONTINUOUS
    # =========================================================================

    if (res$type == "continuous") {

      df$tooltip_txt <- paste0(
        "X = ",
        round(df$Xi, 4),
        "<br>F(x) = ",
        round(df$F_x, 6)
      )

      p <- ggplot(

        df,

        aes(
          x = Xi,
          y = F_x,
          group = 1,
          text = tooltip_txt
        )

      ) +

        geom_line(
          color = "#60a5fa",
          linewidth = 1.1
        ) +

        coord_cartesian(
          ylim = c(0, 1)
        ) +

        labs(
          title = t()$cdf_tab,
          x = t()$x_axis,
          y = t()$y_cdf
        ) +

        theme_minimal()


      # =========================================================================
      # DISCRETE
      # =========================================================================

    } else {

      df$tooltip_txt <- paste0(
        "X = ",
        df$Xi,
        "<br>F(x) = ",
        round(df$F_x, 6)
      )

      p <- ggplot(

        df,

        aes(
          x = Xi,
          y = F_x,
          group = 1,
          text = tooltip_txt
        )

      ) +

        geom_step(
          color = "#60a5fa",
          linewidth = 1.1
        ) +

        geom_point(
          color = "#60a5fa",
          size = 1.5
        ) +

        coord_cartesian(
          ylim = c(0, 1.05)
        ) +

        labs(
          title = t()$cdf_tab,
          x = t()$x_axis,
          y = t()$y_cdf
        ) +

        theme_minimal()
    }

    ggplotly(
      p,
      tooltip = "text"
    ) %>%

      layout(
        margin = list(b = 100),
        legend = list(
          y = -0.25,
          x = 0.5,
          yanchor = "top"
        )
      )
  })


  # ===========================================================================
  # DATA TABLE
  # ===========================================================================

  output$data_table <- renderTable({

    res <- model_data()

    req(res)


    # =========================================================================
    # CONTINUOUS DISTRIBUTIONS: QUANTILE TABLE
    # =========================================================================

    if (res$type == "continuous") {

      probabilities <- c(
        0,
        0.01,
        seq(0.05, 0.95, by = 0.05),
        0.99,
        1
      )

      quantiles <- sapply(
        probabilities,
        res$quantile_fun
      )

      table_df <- data.frame(

        p = paste0(
          format(probabilities * 100, trim = TRUE, scientific = FALSE),
          "%"
        ),

        quantile = round(
          quantiles,
          5
        )
      )

      colnames(table_df) <- c(
        "p",
        t()$quantile
      )

      return(table_df)
    }


    # =========================================================================
    # DISCRETE DISTRIBUTIONS: PROBABILITY TABLE
    # =========================================================================

    table_df <- res$df %>%

      mutate(

        Xi = round(Xi, 4),

        f_x = round(f_x, 6),

        F_x = round(F_x, 6)
      )

    colnames(table_df) <- c(
      "x",
      "P(X = x)",
      "F(x)"
    )

    table_df

  }, rownames = FALSE)
}


# =============================================================================
# APPLICATION
# =============================================================================

shinyApp(
  ui = ui,
  server = server
)
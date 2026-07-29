# =============================================================================
# Laboratorio Interactivo de Distribuciones de Probabilidad
# =============================================================================

library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)

# --- Diccionarios de Idioma --------------------------------------------------
i18n <- list(
  es = list(
    title = "Laboratorio Interactivo de Distribuciones de Probabilidad",
    family = "Familia de Distribución:",
    continuous = "Continua",
    discrete = "Discreta",
    model = "Seleccionar Modelo:",
    lang = "Idioma / Language:",
    params = "Parámetros del Modelo",
    props = "Propiedades Teóricas y Estadísticos",
    mean = "Media (μ)",
    variance = "Varianza (σ²)",
    std = "Desviación Estándar (σ)",
    median = "Mediana",
    mode = "Moda",
    skewness = "Asimetría (Skewness)",
    kurtosis = "Curtosis (Exceso)",
    prob_calc = "Cálculo de Probabilidades",
    lower_bound = "Límite inferior (a):",
    upper_bound = "Límite superior (b):",
    prob_result = "Probabilidad calculada P(a ≤ X ≤ b):",
    tab_dens = "Función de Densidad / Probabilidad",
    tab_cum = "Función Acumulada F(x)",
    tab_data = "Tabla de Datos",
    x_axis = "Valor (x)",
    y_dens = "Densidad / Probabilidad f(x)",
    y_cum = "Probabilidad Acumulada F(x)",
    footer = "Plataforma Educativa de Estadística — Diseñada para Docencia"
  ),
  en = list(
    title = "Interactive Probability Distributions Laboratory",
    family = "Distribution Family:",
    continuous = "Continuous",
    discrete = "Discrete",
    model = "Select Model:",
    lang = "Language / Idioma:",
    params = "Model Parameters",
    props = "Theoretical Properties & Statistics",
    mean = "Mean (μ)",
    variance = "Variance (σ²)",
    std = "Standard Deviation (σ)",
    median = "Median",
    mode = "Mode",
    skewness = "Skewness",
    kurtosis = "Kurtosis (Excess)",
    prob_calc = "Probability Calculator",
    lower_bound = "Lower bound (a):",
    upper_bound = "Upper bound (b):",
    prob_result = "Calculated probability P(a ≤ X ≤ b):",
    tab_dens = "Density / Mass Function",
    tab_cum = "Cumulative Function F(x)",
    tab_data = "Data Table",
    x_axis = "Value (x)",
    y_dens = "Density / Probability f(x)",
    y_cum = "Cumulative Probability F(x)",
    footer = "Educational Statistics Platform — Designed for Teaching"
  )
)

# --- Interfaz de Usuario (UI) ------------------------------------------------
ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      .well { background-color: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
      h3, h4 { color: #1e293b; font-weight: 600; }
      .shiny-input-container { margin-bottom: 15px; }
      .prob-box { background-color: #e0e7ff; border: 1px solid #c7d2fe; border-radius: 8px; padding: 10px; margin-top: 10px; text-align: center; }
      .prob-box span { font-size: 13px; color: #3730a3; font-weight: bold; display: block; }
      .prob-box strong { font-size: 16px; color: #312e81; }
    "))
  ),
  
  titlePanel(textOutput("app_title")),
  
  sidebarLayout(
    sidebarPanel(
      width = 4,
      
      # Selector de Idioma
      selectInput("lang", NULL, choices = list("Español" = "es", "English" = "en"), selected = "es"),
      hr(style = "margin-top: 5px; margin-bottom: 15px;"),
      
      # Familia y Modelo
      uiOutput("family_ui"),
      uiOutput("model_ui"),
      hr(),
      
      # Parámetros dinámicos
      uiOutput("params_ui"),
      hr(),
      
      # Calculadora de intervalos
      uiOutput("calc_ui"),
      uiOutput("prob_result_box"),
      hr(),
      
      # Estadísticos teóricos
      wellPanel(
        h4(textOutput("props_title")),
        verbatimTextOutput("stats_summary")
      )
    ),
    
    mainPanel(
      width = 8,
      tabsetPanel(
        tabPanel(textOutput("tab1_title"), plotlyOutput("plot_densidad", height = "420px")),
        tabPanel(textOutput("tab2_title"), plotlyOutput("plot_acumulada", height = "420px")),
        tabPanel(textOutput("tab3_title"), tableOutput("data_table"))
      )
    )
  ),
  
  tags$footer(
    textOutput("footer_text"),
    style = "text-align: center; margin-top: 40px; padding: 15px; color: #64748b; font-size: 12px; border-top: 1px solid #e2e8f0;"
  )
)

# --- Servidor (Server) -------------------------------------------------------
server <- function(input, output, session) {
  
  t <- reactive({
    lang_code <- if (!is.null(input$lang)) input$lang else "es"
    i18n[[lang_code]]
  })
  
  output$app_title <- renderText({ t()$title })
  output$props_title <- renderText({ t()$props })
  output$tab1_title <- renderText({ t()$tab_dens })
  output$tab2_title <- renderText({ t()$tab_cum })
  output$tab3_title <- renderText({ t()$tab_data })
  output$footer_text <- renderText({ t()$footer })
  
  output$family_ui <- renderUI({
    selectInput("family", t()$family,
                choices = setNames(c("continuous", "discrete"), c(t()$continuous, t()$discrete)))
  })
  
  output$model_ui <- renderUI({
    req(input$family)
    if (input$family == "continuous") {
      selectInput("model", t()$model,
                  choices = c("Normal" = "normal", 
                              "t-Student" = "student", 
                              "Chi-Square" = "chisq", 
                              "Exponential" = "exponential", 
                              "Gamma" = "gamma", 
                              "Beta" = "beta"))
    } else {
      selectInput("model", t()$model,
                  choices = c("Binomial" = "binomial", "Poisson" = "poisson", 
                              "Geometric" = "geometric", "Hypergeometric" = "hypergeometric", 
                              "Negative Binomial" = "negbin"))
    }
  })
  
  output$params_ui <- renderUI({
    req(input$model)
    lang_code <- if (!is.null(input$lang)) input$lang else "es"
    
    switch(input$model,
           "normal" = tagList(
             h4(t()$params, style = "font-size: 14px; color: #475569;"),
             sliderInput("mean", "Media (μ):", min = -25, max = 25, value = 0, step = 0.5),
             sliderInput("sd", "Desv. Estándar (σ):", min = 0.1, max = 10, value = 1, step = 0.1)
           ),
           "student" = tagList(
             h4(t()$params, style = "font-size: 14px; color: #475569;"),
             sliderInput("df_t", "Grados de libertad (df):", min = 1, max = 50, value = 5, step = 1)
           ),
           "chisq" = tagList(
             h4(t()$params, style = "font-size: 14px; color: #475569;"),
             sliderInput("df_chi", "Grados de libertad (df):", min = 1, max = 40, value = 4, step = 1)
           ),
           "exponential" = tagList(
             h4(t()$params, style = "font-size: 14px; color: #475569;"),
             sliderInput("rate", "Tasa (λ):", min = 0.1, max = 10, value = 1, step = 0.1)
           ),
           "gamma" = tagList(
             h4(t()$params, style = "font-size: 14px; color: #475569;"),
             sliderInput("shape", "Forma (k):", min = 0.5, max = 15, value = 2, step = 0.5),
             sliderInput("scale", "Escala (θ):", min = 0.5, max = 10, value = 2, step = 0.5)
           ),
           "beta" = tagList(
             h4(t()$params, style = "font-size: 14px; color: #475569;"),
             sliderInput("shape1", "Alpha (α):", min = 0.2, max = 15, value = 2, step = 0.2),
             sliderInput("shape2", "Beta (β):", min = 0.2, max = 15, value = 2, step = 0.2)
           ),
           "binomial" = tagList(
             h4(t()$params, style = "font-size: 14px; color: #475569;"),
             sliderInput("n", "Ensayos (n):", min = 1, max = 60, value = 20, step = 1),
             sliderInput("p", "Prob. éxito (p):", min = 0.01, max = 0.99, value = 0.5, step = 0.01)
           ),
           "poisson" = tagList(
             h4(t()$params, style = "font-size: 14px; color: #475569;"),
             sliderInput("lambda", "Tasa (λ):", min = 1, max = 50, value = 10, step = 1)
           ),
           "geometric" = tagList(
             h4(t()$params, style = "font-size: 14px; color: #475569;"),
             sliderInput("p_geo", "Prob. éxito (p):", min = 0.01, max = 1, value = 0.4, step = 0.01)
           ),
           "hypergeometric" = tagList(
             h4(t()$params, style = "font-size: 14px; color: #475569;"),
             sliderInput("N_pop", "Población total (N):", min = 5, max = 100, value = 30, step = 1),
             sliderInput("K_success", "Éxitos en población (K):", min = 1, max = 29, value = 12, step = 1),
             sliderInput("n_sample", "Muestra tomada (n):", min = 1, max = 29, value = 8, step = 1)
           ),
           "negbin" = tagList(
             h4(t()$params, style = "font-size: 14px; color: #475569;"),
             sliderInput("r", "Éxitos requeridos (r):", min = 1, max = 25, value = 4, step = 1),
             sliderInput("p_nb", "Prob. éxito (p):", min = 0.01, max = 1, value = 0.5, step = 0.01)
           )
    )
  })
  
  output$calc_ui <- renderUI({
    req(input$model, input$family)
    tagList(
      h4(t()$prob_calc, style = "font-size: 13px; font-weight: bold; color: #334155;"),
      numericInput("c_lower", t()$lower_bound, value = 0, step = 1),
      numericInput("c_upper", t()$upper_bound, value = 5, step = 1)
    )
  })
  
  # Generación de Datos Reactivos
  model_data <- reactive({
    req(input$model)
    mod <- input$model
    
    low <- if(!is.null(input$c_lower) && !is.na(input$c_lower)) input$c_lower else 0
    up <- if(!is.null(input$c_upper) && !is.na(input$c_upper)) input$c_upper else 1
    
    if (mod == "normal") {
      mu <- input$mean; sig <- input$sd
      X <- seq(mu - 4 * sig, mu + 4 * sig, length.out = 300)
      df <- data.frame(Xi = X, f_x = dnorm(X, mu, sig), F_x = pnorm(X, mu, sig))
      list(df = df, mean = mu, var = sig^2, std = sig, median = mu, mode = mu, skew = 0, kurt = 0, type = "cont",
           prob_val = pnorm(up, mu, sig) - pnorm(low, mu, sig))
      
    } else if (mod == "student") {
      nu <- input$df_t
      X <- seq(-5, 5, length.out = 300)
      df <- data.frame(Xi = X, f_x = dt(X, nu), F_x = pt(X, nu))
      m <- 0; v <- if(nu > 2) nu/(nu - 2) else NA
      s <- if(nu > 3) 0 else NA
      k <- if(nu > 4) 6/(nu - 4) else NA
      list(df = df, mean = m, var = v, std = sqrt(v), median = 0, mode = 0, skew = s, kurt = k, type = "cont",
           prob_val = pt(up, nu) - pt(low, nu))
      
    } else if (mod == "chisq") {
      k <- input$df_chi
      X <- seq(0, qchisq(0.999, k), length.out = 300)
      df <- data.frame(Xi = X, f_x = dchisq(X, k), F_x = pchisq(X, k))
      m <- k; v <- 2 * k
      list(df = df, mean = m, var = v, std = sqrt(v), median = qchisq(0.5, k), mode = max(0, k - 2), skew = sqrt(8/k), kurt = 12/k, type = "cont",
           prob_val = pchisq(up, k) - pchisq(low, k))
      
    } else if (mod == "exponential") {
      rate <- input$rate
      X <- seq(0, qexp(0.999, rate), length.out = 300)
      df <- data.frame(Xi = X, f_x = dexp(X, rate), F_x = pexp(X, rate))
      list(df = df, mean = 1/rate, var = 1/(rate^2), std = 1/rate, median = log(2)/rate, mode = 0, skew = 2, kurt = 6, type = "cont",
           prob_val = pexp(up, rate) - pexp(low, rate))
      
    } else if (mod == "gamma") {
      shape <- input$shape; scale <- input$scale
      X <- seq(0, qgamma(0.999, shape = shape, scale = scale), length.out = 300)
      df <- data.frame(Xi = X, f_x = dgamma(X, shape = shape, scale = scale), F_x = pgamma(X, shape = shape, scale = scale))
      m <- shape * scale; v <- shape * (scale^2)
      list(df = df, mean = m, var = v, std = sqrt(v), median = qgamma(0.5, shape, scale = scale), mode = ifelse(shape > 1, (shape - 1)*scale, 0), skew = 2/sqrt(shape), kurt = 6/shape, type = "cont",
           prob_val = pgamma(up, shape, scale = scale) - pgamma(low, shape, scale = scale))
      
    } else if (mod == "beta") {
      s1 <- input$shape1; s2 <- input$shape2
      X <- seq(0.001, 0.999, length.out = 300)
      df <- data.frame(Xi = X, f_x = dbeta(X, s1, s2), F_x = pbeta(X, s1, s2))
      m <- s1 / (s1 + s2); v <- (s1 * s2) / (((s1 + s2)^2) * (s1 + s2 + 1))
      mode_val <- if(s1 > 1 && s2 > 1) (s1 - 1)/(s1 + s2 - 2) else NA
      list(df = df, mean = m, var = v, std = sqrt(v), median = qbeta(0.5, s1, s2), mode = mode_val, skew = 2*(s2 - s1)*sqrt(s1 + s2 + 1)/( (s1 + s2 + 2)*sqrt(s1 * s2) ), kurt = NA, type = "cont",
           prob_val = pbeta(up, s1, s2) - pbeta(low, s1, s2))
      
    } else if (mod == "binomial") {
      n <- input$n; p <- input$p
      X <- 0:n
      df <- data.frame(Xi = X, f_x = dbinom(X, n, p), F_x = pbinom(X, n, p))
      m <- n * p; v <- n * p * (1 - p)
      l_bound <- max(0, min(n, floor(low)))
      u_bound <- max(0, min(n, floor(up)))
      p_val <- if(l_bound <= u_bound) sum(dbinom(l_bound:u_bound, n, p)) else 0
      list(df = df, mean = m, var = v, std = sqrt(v), median = round(m), mode = floor((n + 1) * p), skew = (1 - 2*p)/sqrt(v), kurt = (1 - 6*p*(1-p))/v, type = "disc", prob_val = p_val)
      
    } else if (mod == "poisson") {
      lam <- input$lambda
      X <- 0:max(15, floor(lam + 4 * sqrt(lam)))
      df <- data.frame(Xi = X, f_x = dpois(X, lam), F_x = ppois(X, lam))
      l_bound <- max(0, floor(low)); u_bound <- max(0, floor(up))
      p_val <- if(l_bound <= u_bound) sum(dpois(l_bound:u_bound, lam)) else 0
      list(df = df, mean = lam, var = lam, std = sqrt(lam), median = round(lam), mode = floor(lam), skew = 1/sqrt(lam), kurt = 1/lam, type = "disc", prob_val = p_val)
      
    } else if (mod == "geometric") {
      p <- input$p_geo
      X <- 0:max(10, ceiling(qgeom(0.99, p)))
      df <- data.frame(Xi = X, f_x = dgeom(X, p), F_x = pgeom(X, p))
      l_bound <- max(0, floor(low)); u_bound <- max(0, floor(up))
      p_val <- if(l_bound <= u_bound) sum(dgeom(l_bound:u_bound, p)) else 0
      list(df = df, mean = (1-p)/p, var = (1-p)/(p^2), std = sqrt((1-p)/(p^2)), median = ceiling(-log(2)/log(1-p)) - 1, mode = 0, skew = (2-p)/sqrt(1-p), kurt = 6 + (p^2)/(1-p), type = "disc", prob_val = p_val)
      
    } else if (mod == "hypergeometric") {
      N <- input$N_pop; K <- input$K_success; n <- input$n_sample
      req(K <= N, n <= N)
      min_x <- max(0, n - (N - K)); max_x <- min(n, K)
      X <- min_x:max_x
      df <- data.frame(Xi = X, f_x = dhyper(X, K, N - K, n), F_x = phyper(X, K, N - K, n))
      l_bound <- max(min_x, floor(low)); u_bound <- min(max_x, floor(up))
      p_val <- if(l_bound <= u_bound) sum(dhyper(l_bound:u_bound, K, N - K, n)) else 0
      m <- n * (K / N); fc <- (N - n)/(N - 1); v <- fc * m * (1 - (K / N))
      list(df = df, mean = m, var = v, std = sqrt(v), median = round(m), mode = floor((n+1)*(K+1)/(N+2)), skew = NA, kurt = NA, type = "disc", prob_val = p_val)
      
    } else if (mod == "negbin") {
      r <- input$r; p <- input$p_nb
      X <- 0:max(15, ceiling(qnbinom(0.99, r, p)))
      df <- data.frame(Xi = X, f_x = dnbinom(X, r, p), F_x = pnbinom(X, r, p))
      l_bound <- max(0, floor(low)); u_bound <- max(0, floor(up))
      p_val <- if(l_bound <= u_bound) sum(dnbinom(l_bound:u_bound, r, p)) else 0
      m <- r * (1 - p) / p; v <- r * (1 - p) / (p^2)
      list(df = df, mean = m, var = v, std = sqrt(v), median = NA, mode = max(0, floor((r - 1)*(1 - p)/p)), skew = (2 - p)/sqrt(r*(1-p)), kurt = 6/r + (p^2)/(r*(1-p)), type = "disc", prob_val = p_val)
    }
  })
  
  output$prob_result_box <- renderUI({
    res <- model_data()
    req(res)
    val <- round(res$prob_val, 5)
    if(is.na(val)) val <- 0
    tags$div(
      class = "prob-box",
      tags$span(t()$prob_result),
      tags$strong(val)
    )
  })
  
  output$stats_summary <- renderText({
    res <- model_data()
    req(res)
    fmt <- function(val) if(is.null(val) || is.na(val) || is.infinite(val)) "N/A" else round(val, 4)
    paste0(
      t()$mean, ": ", fmt(res$mean), "\n",
      t()$variance, ": ", fmt(res$var), "\n",
      t()$std, ": ", fmt(res$std), "\n",
      t()$median, ": ", fmt(res$median), "\n",
      t()$mode, ": ", fmt(res$mode), "\n",
      t()$skewness, ": ", fmt(res$skew), "\n",
      t()$kurtosis, ": ", fmt(res$kurt)
    )
  })
  
  # Gráfico de Densidad / Probabilidad
  output$plot_densidad <- renderPlotly({
    res <- model_data()
    req(res)
    df <- res$df %>% arrange(Xi)   # ordenar por si acaso
    
    if (res$type == "cont") {
      df$tooltip_txt <- paste0("x: ", round(df$Xi, 3), "<br>f(x): ", round(df$f_x, 4))
      p <- ggplot(df, aes(x = Xi, y = f_x, group = 1, text = tooltip_txt)) +   # group=1
        geom_line(color = "#4f46e5", size = 1.2) +   # size en vez de linewidth
        labs(title = t()$tab_dens, x = t()$x_axis, y = t()$y_dens) +
        theme_minimal()
      
      # Sombreado del intervalo
      low <- if (!is.null(input$c_lower)) input$c_lower else min(df$Xi)
      up  <- if (!is.null(input$c_upper)) input$c_upper else max(df$Xi)
      low <- max(low, min(df$Xi))
      up  <- min(up,  max(df$Xi))
      sub_df <- df %>% filter(Xi >= low & Xi <= up)
      if (nrow(sub_df) > 0) {
        p <- p + geom_area(data = sub_df, aes(x = Xi, y = f_x), fill = "#818cf8", alpha = 0.5)
      }
    } else {
      # Discreta
      df$tooltip_txt <- paste0("x: ", df$Xi, "<br>P(X = x): ", round(df$f_x, 4))
      p <- ggplot(df, aes(x = Xi, y = f_x, group = 1, text = tooltip_txt)) +
        geom_col(fill = "#4f46e5", alpha = 0.85, width = 0.6) +
        labs(title = t()$tab_dens, x = t()$x_axis, y = t()$y_dens) +
        theme_minimal()
      
      # Resaltar intervalo
      low <- if (!is.null(input$c_lower)) input$c_lower else min(df$Xi)
      up  <- if (!is.null(input$c_upper)) input$c_upper else max(df$Xi)
      low <- max(low, min(df$Xi))
      up  <- min(up,  max(df$Xi))
      highlight_df <- df %>% filter(Xi >= low & Xi <= up)
      if (nrow(highlight_df) > 0) {
        p <- p + geom_col(data = highlight_df, aes(x = Xi, y = f_x), fill = "#f43f5e", width = 0.6)
      }
    }
    ggplotly(p, tooltip = "text")   # se puede añadir dynamicTicks = TRUE
  })
  
  
  
  # Gráfico de Acumulada (Limpio y robusto)
  output$plot_acumulada <- renderPlotly({
    res <- model_data()
    req(res)
    df <- res$df %>% arrange(Xi)
    
    if (res$type == "cont") {
      df$tooltip_txt <- paste0("x: ", round(df$Xi, 3), "<br>F(x): ", round(df$F_x, 4))
      p <- ggplot(df, aes(x = Xi, y = F_x, group = 1, text = tooltip_txt)) +
        geom_line(color = "#0ea5e9", size = 1.2) +   # size en lugar de linewidth
        ylim(0, 1) +
        labs(title = t()$tab_cum, x = t()$x_axis, y = t()$y_cum) +
        theme_minimal()
    } else {
      # Acumulada discreta: step + puntos
      df$tooltip_txt <- paste0("x: ", df$Xi, "<br>P(X ≤ x): ", round(df$F_x, 4))
      p <- ggplot(df, aes(x = Xi, y = F_x, group = 1, text = tooltip_txt)) +
        geom_step(color = "#0ea5e9", size = 1.2) +   # size en lugar de linewidth
        geom_point(color = "#0ea5e9", size = 1.5) +
        ylim(0, 1.05) +
        labs(title = t()$tab_cum, x = t()$x_axis, y = t()$y_cum) +
        theme_minimal()
    }
    ggplotly(p, tooltip = "text")
  })
}

# --- Ejecutar App ------------------------------------------------------------
shinyApp(ui = ui, server = server)

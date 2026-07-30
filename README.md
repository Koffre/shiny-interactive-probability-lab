# **📊 Interactive Probability Distributions Laboratory**

An advanced web-based educational dashboard built with **R Shiny**, **ggplot2**, and **Plotly** designed to teach and explore statistical probability distributions. The application provides real-time dynamic parameter tuning, interval probability calculations, step cumulative distribution functions (CDFs) for discrete models, and complete bilingual support (**Spanish / English**).

## **🎯 Key Features & Pedagogical Design**

1. **Hierarchical Distribution Selector:** \* Filter models cleanly between **Continuous** and **Discrete** families.  
   * **Continuous Models:** Normal, t-Student, Chi-Square (![][image1]), Exponential, Gamma, and Beta.  
   * **Discrete Models:** Binomial, Poisson, Geometric, Hypergeometric, and Negative Binomial.  
2. **Interactive Probability Calculator:**  
   * Compute probabilities for specific intervals ![][image2] in continuous distributions with automatic area shading under the curve.  
   * Calculate exact range probabilities for discrete models.  
   * Live output cards showing precise probability values in real time.  
3. **Modern Visualizations (plotly):**  
   * Smooth curves and density functions for continuous models.  
   * Proper step functions (geom\_step) for discrete cumulative distributions.  
   * Clean, formal hover tooltips avoiding raw variable names.  
4. **Extended Theoretical Statistics:**  
   * Instantly updates theoretical properties including **Mean (![][image3])**, **Variance (![][image4])**, **Standard Deviation (![][image5])**, **Median**, **Mode**, **Skewness**, and **Excess Kurtosis**.  
5. **Bilingual Support (ES/EN):**  
   * Instant runtime switching between Spanish and English for all UI labels, titles, and metrics.

## **📂 Repository Structure**

shiny-interactive-probability-lab/  
├── app.R          \# Unified R Shiny application script  
├── LICENSE        \# MIT Open Source License  
└── README.md      \# Project documentation

## **🛠️ Prerequisites & Dependencies**

To run this application locally, you need **R** and **RStudio** installed, along with the following required CRAN packages:

install.packages(c("shiny", "dplyr", "ggplot2", "plotly"))

## **🚀 Running the Application Locally**

1. Clone or download this repository to your local machine.  
2. Open the project folder in RStudio.  
3. Open app.R and click **Run App** in the upper-right corner of the editor, or run the following command in your R console:

shiny::runApp("app.R")

## **👨‍💻 Author & Academic Context**

* **Author:** Joffre Sanchez C.  
* **Context:** Developed as an interactive teaching tool for statistical modeling and probability theory.

## **📄 License**

This project is licensed under the terms of the **MIT License**. See the LICENSE file for details.

[image1]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABUAAAAaCAYAAABYQRdDAAABjElEQVR4Xu2VvUrEQBSFk0LwD2xcgrtJJomCDxAR7Cy0EMRCBcFKEHwBYQtbsXBrsRBBtBBfwMZqC4ttfQALQVawsbIQwfW7OLDJLWSzplDwwGHmzpyc3Lm5SRznt8D3/SFjzCZsxHE8rfcLIwzDBcyeGReTJBlj3oLNSqUyqrU9I4qieUze4baNz5k/wAmtLQTP80YYXMlOspRsJWut6wtSAgxf4Zre6xuY3XH8Daau3iuMNE0HMDywoct8ny7wciKBLHLXQb2uYQ2PxZTjrzPuwUtb5y5sbdqwg/GhXJgTgCAIZqrV6jCaJdEpnubEVniBWcR4Dz/galbDKWZZu82u9QwujOEjfJEYMyNm0vBaWwQuBmdyJPu2XJsy2oXarYgp1biBW04Z7UKmCaZPjHWnDEPn6/h1TN9Mtw9/BGniXUyv4LIp432WByIPRoxos3Gb7ZzWFQIGzVqt5mfiDjxy+q2rNLf0ZHbNZtrmKz8lMSVJs/vfQsy0oUB+GRjtYHwCG7TapNb844/jE0eVWth2qYHBAAAAAElFTkSuQmCC>

[image2]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACgAAAAaCAYAAADFTB7LAAACTElEQVR4Xu2Wv2tTURTHE0RQUFQwSmOS95KIoaC0EHARNx06ugkdHSoiuLV/gYNLQcFFBHFyqINOpZs/wB90EdFFKMUunYogtrjU+vmae+vNoXkvefZhh3zhcO4933Pv+d53fySFwhC7hHq9fjKKohH5dru93/J5IY7jo6orb7kukPClVqs9wt/FYsvnBcRdwx5Q8rHluoC4Z6VS6ZCN7waq1epF5l9ByI9eQnrFt5GnwEqlcgoBrxC4hZ+yvPBfBQqIe4GtU6dtOWEvCNzSGadZtJzwzwLjtFuWAgnEJmnuazabJyyfWSDxC9h7Jv+AX8Bfwe7bvCS0Wq3DjPmu24ota7sRdCd8zrIILDLRTewn3C318dPuS6wHeakgf9SNm+XCHHSxTURd9zkDC2SCT9gv4peC2IQKubPUNxhzL+psbxjbwL5iI+pnEagVfy6Xy8eD2G0X7yqWBOY9Rv4iNhrG3TyL4tXPKvCh74uLUp6KnSBh2JrOYRDW8em61ZkExsGjCt8gtupXjZ/wXBK0GC0qjLnf/U24yz6WRaAmmHFdrfibW/WMngnadREUG4s6N/Rdo9E44sd7+C/vLwf55zWXzc0i8Aa2hs3BveT39CztN1HnK74tuK1xAp5gS5E78BYUH4d7jX+uxTDf9A45gwkUGHRAReO/j/SfRzbob4O8p70EChqX9Fcuk8BBoAJakI33i7wFFilw1QYHQapAtmeeg3w6aRt6gQN/xsb6hY6LO0bJAkn4yFdckUfoOcvnBcTNqq685YYYYi/gN14ds9CLIgROAAAAAElFTkSuQmCC>

[image3]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAwAAAAaCAYAAACD+r1hAAABAUlEQVR4Xu1RvQ4BYRCkEBKCwrm4u9x/o1JcJ0pPoNB4AI8g0XsDvVpPJ4hWrdRJ9IJG/MxevpXNRdQKk0w2OzO7t3eXSv3xc4iiKOP7fimpfwQFXdfdOI6z9zxPZx19nTSZjYFQA8YJXOi6nmfdtu0BtKfMsjGB8UBts2aapgXtAG5lNgbEHXjEgM8aDaslE5mNAeMGzvEeOaGN6BywJ7NskjHkXtO0Avo1eMETIhoKwzAbm5ZlmWpgjDatFqyUtkawiNrhZXzrXXGGs6aoTVoAnsEl/SM5MECoT/fDrAVBUGUPWln2JFBojqHWW/wG/taGYVSS3kdgcxcD16T+h8ALCkk/L8xWoY4AAAAASUVORK5CYII=>

[image4]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABUAAAAZCAYAAADe1WXtAAABOElEQVR4Xu2UrUsFQRTF3wuKoiAoyyL7vUXYJKz6Pxi0WPyqNrvVJvhPiMmoYH2I0WoyWUSw2TQY1N+RCcMNMrtJ5B24zJ1z7xzOzs7MYPBXUFXVUlEUp8RumqbTtt4JZVlOIXRNXERRNMt8m/wzy7JN2xsMJ3pJ3CdJspDneUv+xnhkezuhbduJpmkmlcuhnMqx7euLIYIj9nTeFnoDwa04jmcs3xt89gr7eOLyVfID29MJHKc1XN6wjzuMewheMa7bvh9QPKP4RbwSzy7/gH9SIHJu1/wK/VEdDXfehuKYPxJ3dV3PmfYw4GQfgUOfkzO4F2q1zwdBTuSIqHye+ai3KIs2tH+WF4fbY8sHQUcCgXef072Ge+Aqpj4fDCdwq5+luUY5JJZtb2fogUB8UY+GrY0xxn/EN3soQqm6AB6EAAAAAElFTkSuQmCC>

[image5]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAwAAAAbCAYAAABIpm7EAAAA1UlEQVR4XmNgGAVDH8jJyWkB8Qp5eflnQPwfDfeiKFZQUOiESvwCanqEpPAZiA+Uj4crNjY2ZgVK/AVK5AO5zCAxIHs+UOwfUKEHXCEMyMrK+gElJgCZjDAxoAZfkA1AuhxJKQODjIwMJ1BwB1CTDrI40IB0rBqAgpZA/BNFECJ+HYQVFRXFUSSAAvpAiU8oggxgDX+BOBhdHOwkoMRmJSUlfqgQI8hPQLFiEBtZLRxIS0vLABXcAeK5QHwO6O6TDLgUwwDQkwJAxZKioqI86HKjYPABANTpNTQr7uEiAAAAAElFTkSuQmCC>
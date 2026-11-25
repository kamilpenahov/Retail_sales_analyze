# =====================================================
# RETAIL SALES ANALYSIS
# Data Analysis Project using R
# =====================================================


# -----------------------------------------------------
# 1. DESCRIPTIVE STATISTICS
# Orta, median və standart kənarlaşmanın hesablanması
# -----------------------------------------------------

# Average Sales – Orta satış məbləğini hesabladım.
ortalama_sales = round(mean(data$sales, na.rm = TRUE), 0)

# Median Sales – Satış məbləğlərinin median dəyərini müəyyən etdim.
median_sales = round(median(data$sales, na.rm = TRUE), 0)

# Standard Deviation – Satışların orta dəyərdən yayınmasını ölçdüm.
standart_yayinma = round(sd(data$sales, na.rm = TRUE), 0)


# -----------------------------------------------------
# 2. YEARLY SALES TREND
# İllər üzrə satışların analizi
# -----------------------------------------------------

library(dplyr)
library(ggplot2)
library(lubridate)

# İllər üzrə ümumi satış məbləğini hesabladım.
yearly_sales <- data %>%
  group_by(year = format(as.Date(order_date), "%Y")) %>%
  summarise(total_sales = sum(sales, na.rm = TRUE))

# İllik satış dinamikasını Line Chart ilə vizuallaşdırdım.
ggplot(yearly_sales, aes(x = year, y = total_sales, group = 1)) +
  geom_line(color = "blue", linewidth = 1.2) +
  geom_point(color = "red", size = 3) +
  labs(
    title = "Yearly Sales Trend",
    x = "Year",
    y = "Total Sales"
  ) +
  theme_minimal()


# -----------------------------------------------------
# 3. CORRELATION ANALYSIS
# Endirim və mənfəət arasındakı əlaqə
# -----------------------------------------------------

# Discount vs Profit – Endirim və mənfəət arasındakı korrelyasiyanı hesabladım.
cor(data$discount, data$profit, use = "complete.obs")


# -----------------------------------------------------
# 4. PROFIT BY CATEGORY
# Kateqoriyalar üzrə mənfəətin analizi
# -----------------------------------------------------

# Profit by Category – Hər məhsul kateqoriyası üzrə ümumi mənfəəti hesabladım.
category_profit <- data %>%
  group_by(category) %>%
  summarise(total_profit = sum(profit, na.rm = TRUE))

# Nəticələri göstərdim.
print(category_profit)


# -----------------------------------------------------
# 5. MONTHLY SALES TREND
# Aylıq satışların və mövsümi dəyişikliklərin analizi
# -----------------------------------------------------

# Sifariş tarixlərini Date formatına çevirdim.
data$order_date <- as.Date(data$order_date)

# Sifariş tarixlərindən ay məlumatlarını əldə etdim.
data$month <- month(data$order_date, label = TRUE, abbr = FALSE)

# Aylar üzrə ümumi satış məbləğini hesabladım.
monthly_sales <- data %>%
  group_by(month) %>%
  summarise(total_sales = sum(sales, na.rm = TRUE))

# Nəticələri göstərdim.
print(monthly_sales)


# -----------------------------------------------------
# 6. SALES DISTRIBUTION
# Satışların paylanmasının vizuallaşdırılması
# -----------------------------------------------------

# Sales Distribution – Satış məbləğlərinin paylanmasını Boxplot ilə göstərdim.
boxplot(
  data$sales,
  main = "Sales Distribution",
  ylab = "Sales",
  col = "lightblue"
)


# -----------------------------------------------------
# 7. OUTLIER DETECTION
# Kənar dəyərlərin müəyyən edilməsi
# -----------------------------------------------------

# Outlier Detection – Satış məlumatlarındakı kənar dəyərləri müəyyən etdim.
boxplot.stats(data$sales)


# -----------------------------------------------------
# 8. CHI-SQUARE TEST
# Region və kateqoriya arasındakı əlaqənin analizi
# -----------------------------------------------------

# Chi-Square Test – State və Category dəyişənləri arasında statistik əlaqəni yoxladım.
chisq.test(data$state, data$category)


# =====================================================
# END OF RETAIL SALES ANALYSIS
# =====================================================
# 🛒 Retail Market Basket Intelligence: End-to-End Data Engineering & Association Rule Mining Pipeline

> **Market Basket Analysis using Python & SQL | Retail Purchase Patterns & Association Rule Mining**

[![Python](https://img.shields.io/badge/Python-3.9%2B-3776AB.svg?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![MySQL](https://img.shields.io/badge/MySQL-4479A1.svg?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Pandas](https://img.shields.io/badge/Pandas-150458.svg?style=for-the-badge&logo=pandas&logoColor=white)](https://pandas.pydata.org/)
[![Jupyter](https://img.shields.io/badge/Jupyter-F37626.svg?style=for-the-badge&logo=Jupyter&logoColor=white)](https://jupyter.org/)
[![Machine Learning](https://img.shields.io/badge/Machine_Learning-Apriori-FF6F00.svg?style=for-the-badge&logo=scikit-learn&logoColor=white)](https://pypi.org/project/mlxtend/)
[![Data Visualization](https://img.shields.io/badge/Data_Viz-Seaborn_%7C_NetworkX-008080.svg?style=for-the-badge&logo=databricks&logoColor=white)](https://seaborn.pydata.org/)

## 📌 Executive Summary
In the highly competitive retail sector, understanding organic customer purchasing behavior is the key to increasing Average Order Value (AOV) and driving sustainable revenue. 

This project is a complete, end-to-end data analytics pipeline that ingests **522,000+ raw retail transactions**, engineers a clean relational schema, and deploys the **Apriori Machine Learning Algorithm** to mathematically uncover hidden product associations. The insights extracted from this pipeline provide data-driven blueprints for autonomous cross-selling, hard product bundling, and physical store layout optimization.

---

## 🚀 Business Impact & Key Discoveries
By translating a sparse boolean matrix of **17,500+ unique shopping baskets** into actionable association rules, this project successfully identified:
* **The Regency Tea Set Bundle (Lift: 18.34):** Discovered a near-guaranteed purchase relationship (73%+ Confidence) between specific teacup variants, providing the exact mathematical basis for a highly profitable, single-SKU bundled product.
* **Algorithmic Cross-Selling:** Proved that customers buying the *Pink Polkadot Jumbo Bag* have a 65.9% probability of purchasing the *Red Retrospot Bag*, establishing the foundation for a digital "Frequently Bought Together" recommendation engine.
* **Predictive Inventory Planning:** Identified that specific decorative items drive over 10% of all store foot traffic, dictating strict minimum-stock threshold alerts to prevent cascading lost sales.

---

## 🛠️ Technology Stack
* **Database & Extraction:** MySQL, SQLAlchemy, PyMySQL
* **Data Engineering & Wrangling:** Python, Pandas, NumPy
* **Machine Learning (Association Rules):** `mlxtend` (Apriori Algorithm)
* **Visual Intelligence:** Matplotlib, Seaborn, NetworkX (Graph Theory)
* **Reporting & BI:** Microsoft Excel, PowerPoint

---

## 📂 Project Architecture & Pipeline

### Phase 1: Exploratory Data Analysis & Validation
Extracted raw data from a read-only MySQL production environment to profile structural topography.
* Detected and mapped 134K+ hidden missing identifiers and 5K+ absolute duplicate records.
* Executed Z-score and Interquartile Range (IQR) analysis to isolate standard consumer variance from extreme wholesale outliers (e.g., maximum quantities of 80K+ units).

### Phase 2: Data Preprocessing & Feature Engineering
Engineered a rigorous data cleansing pipeline to stabilize the dataset for machine learning ingestion.
* Purged negative quantities (returns), invalid pricing (adjustments), and standardized text nomenclature.
* Derived new business features including `Revenue`, `Transaction Size`, and `Product Frequency`.
* Transformed the relational data into a highly optimized **Sparse Boolean Matrix (17K rows × 1.2K columns)**, algorithmically filtering out ultra-rare products to eliminate computational noise.

### Phase 3: Market Basket Analysis (Apriori)
Deployed the Apriori algorithm against the boolean matrix to mine frequent itemsets.
* Calculated mathematical relationships utilizing **Support** (Frequency), **Confidence** (Probability), and **Lift** (Strength of Association).
* Filtered the matrix to isolate ultra-strong, actionable business rules (Lift > 1.2, Confidence ≥ 30%).
* Visualized high-dimensional product clusters using NetworkX Directed Graphs to map out complementary product ecosystems.

---

## ⚙️ How to Execute the Pipeline

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/Karthik-Yelugam/retail-market-basket-intelligence.git](https://github.com/Karthik-Yelugam/retail-market-basket-intelligence.git)
   cd retail-market-basket-intelligence
   ```

2. **Install required dependencies:**
   ```bash
   pip install pandas numpy matplotlib seaborn mlxtend networkx sqlalchemy pymysql
   ```

3. **Execute the SQL Validation:** Run the scripts in the `sql/` folder against your local MySQL environment to validate initial data topography.

4. **Run the Analytics Engine:** Launch Jupyter Notebook and execute the `.ipynb` files in the `notebooks/` directory sequentially (01 -> 02 -> 03).

*(Note: Full 522K+ row datasets are kept local via `.gitignore` to adhere to enterprise data governance and repository optimization standards. Lightweight 5K-row structural samples are provided in `data/sample_data/` for execution testing).*

---

## 📁 Folder Structure

```text
retail-market-basket-intelligence/
│
├── data/                       
│   └── sample_data/                    
│       ├── sample_raw_transactions.csv
│       ├── sample_cleaned_transactions.csv
│       └── sample_basket_matrix.csv
│
├── notebooks/                  
│   ├── 01_exploratory_data_analysis.ipynb
│   ├── 02_data_preprocessing_and_feature_engineering.ipynb
│   └── 03_apriori_market_basket_analysis.ipynb
│
├── sql/                        
│   ├── 01_eda_and_validation.sql
│   └── 02_data_cleaning_checks.sql
│
├── reports/                    
│   ├── Comprehensive_Analysis_Report.pdf
│   ├── Executive_Summary_Presentation.pdf
│   └── phase_reports/          
│       ├── Phase_1_EDA_Summary.pdf
│       ├── Phase_2_Data_Cleaning_Log.pdf
│       └── Phase_3_Market_Basket_Insights.pdf
│
└── visuals/                    
    ├── dashboards/
    │   ├── sales_trends_and_seasonality_dashboard.jpg
    │   ├── top_5_countries_comparison_dashboard.png
    │   └── top_products_and_customers_dashboard.jpg
    └── plots/
        ├── lift_distribution.png
        ├── product_association_network.png
        ├── support_vs_confidence_scatter.png
        ├── top_10_association_rules_by_lift.png
        └── top_10_frequent_products.png
```

---

### 👨‍💻 Author
**Karthik Yelugam** | *Data Analyst* [LinkedIn Profile](https://www.linkedin.com/in/karthik-yelugam/) | [GitHub Profile](https://github.com/Karthik-Yelugam) | [Email](karthikyelugam09@gmail.com)

*If you found this project interesting or useful, feel free to ⭐ the repository!*

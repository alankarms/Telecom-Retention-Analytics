import pandas as pd
import sqlite3

# Loading the processed CSV
csv_path = "/Users/alankar/Desktop/Projects/Telecom Retention Analytics/data/processed/Telco_customer_churn.csv"
df = pd.read_csv(csv_path)

# Creating SQLite database
db_path = "/Users/alankar/Desktop/Projects/Telecom Retention Analytics/data/processed/telco_churn.db"
conn = sqlite3.connect(db_path)

# Saving dataframe as SQL table
df.to_sql("telco_churn", conn, index=False, if_exists="replace")

conn.close()

print("SQLite database created successfully.")
print(f"Database saved at: {db_path}")
print("Table name: telco_churn")
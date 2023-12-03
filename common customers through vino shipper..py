#!/usr/bin/env python
# coding: utf-8

# In[19]:


import pandas as pd
all_states_data = pd.read_csv('/Users/rahulscandavadde/Desktop/Vino_Combined/All States-Table 1.csv')
append_data = pd.read_csv('/Users/rahulscandavadde/Desktop/Vino_Combined/Append-Table 1.csv')
final_data = pd.read_csv('/Users/rahulscandavadde/Desktop/Vino_Combined/Final.csv')
vinoset_data = pd.read_csv('/Users/rahulscandavadde/Desktop/vinoset.csv')
sheet1_data = pd.read_csv('/Users/rahulscandavadde/Desktop/Vino_Combined/Sheet1-Table 1.csv')
multi_pack_data = pd.read_csv('/Users/rahulscandavadde/Desktop/Vino_Combined/multi_pack.csv')
tenders_combined_data = pd.read_csv('/Users/rahulscandavadde/Desktop/cleaned datasets/TENDERS_combined.csv', encoding='ISO-8859-1')
items_combined_data = pd.read_csv('/Users/rahulscandavadde/Desktop/cleaned datasets/ITEMS_combined.csv', encoding='ISO-8859-1')


# In[21]:


# Extract unique customer names from Vino Shipper datasets
vinoshipper_datasets = [all_states_data, append_data, final_data, vinoset_data, sheet1_data, multi_pack_data]
vinoshipper_customers = pd.concat([data[['First Name', 'Last Name']] for data in vinoshipper_datasets if ('First Name_2' in data.columns) and ('Last Name_3' in data.columns)], ignore_index=True).drop_duplicates()
vinoshipper_customers_combined = vinoshipper_customers['First Name'].str.cat(vinoshipper_customers['Last Name'], sep=" ").str.strip().str.lower()


# In[22]:


# Extracting unique customer names from the in-person dataset
inperson_customers_tenders = tenders_combined_data['Customer Name'].dropna().str.strip().str.lower()


# In[23]:


# Identify common customers between the two sets
common_customers = set(inperson_customers_tenders).intersection(set(vinoshipper_customers_combined))
common_customers_count = len(common_customers)

print("Number of common customers:", common_customers_count)


# In[24]:


common_customers = set(inperson_customers_tenders).intersection(set(vinoshipper_customers_combined))


# In[25]:


# Filter for common customers
common_in_person_data = tenders_combined_data[tenders_combined_data['Customer Name'].str.strip().str.lower().isin(common_customers)]

# Group by 'Customer Name' and sum their 'Net Total' to get their total spend
in_person_summary = common_in_person_data.groupby('Customer Name').agg({'Net Total': 'sum'}).reset_index()

# Sort the data by total spend for better visualization
in_person_summary = in_person_summary.sort_values(by='Net Total', ascending=False)

print(in_person_summary)


# In[26]:


# Convert the 'Time' column to a datetime format
tenders_combined_data['Time'] = pd.to_datetime(tenders_combined_data['Time'])

# Extract month and year from the 'Time' column
tenders_combined_data['Month-Year'] = tenders_combined_data['Time'].dt.to_period('M')

# Filter for common customers
common_in_person_data = tenders_combined_data[tenders_combined_data['Customer Name'].str.strip().str.lower().isin(common_customers)]

# Group by 'Customer Name' and 'Month-Year', then sum their 'Net Total' to get their monthly sales
monthly_sales_summary = common_in_person_data.groupby(['Customer Name', 'Month-Year']).agg({'Net Total': 'sum'}).reset_index()

# Sort the data for better visualization
monthly_sales_summary = monthly_sales_summary.sort_values(by=['Customer Name', 'Month-Year'])

print(monthly_sales_summary)


# In[1]:


# Importing necessary libraries
from matplotlib_venn import venn2
import matplotlib.pyplot as plt

# Getting the unique customer sets
inperson_customers_tenders_set = set(inperson_customers_tenders)
vinoshipper_customers_combined_set = set(vinoshipper_customers_combined)

# Plotting the Venn diagram
plt.figure(figsize=(10, 7))
venn2([inperson_customers_tenders_set, vinoshipper_customers_combined_set], 
      ('In-Person Customers', 'Vino Shipper Customers'))
plt.title('Overlap of In-Person and Vino Shipper Customers')
plt.show()


# In[ ]:





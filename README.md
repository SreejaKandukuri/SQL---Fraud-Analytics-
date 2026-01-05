# SQL---Fraud-Analytics-
This project focuses on detecting fraudulent financial activity using advanced SQL techniques. By leveraging recursive CTEs, window functions, and multi-stage query logic, the analysis uncovers money laundering patterns, temporal fraud trends, suspicious account behavior, and transaction balance inconsistencies.

The goal of this project is to demonstrate how SQL can be used not only for querying data, but also for building scalable fraud detection logic and validating financial data integrity.

Tools & Concepts Used: 
SQL (CTEs, Recursive CTEs, Window Functions)
Fraud Detection Logic
Financial Transaction Analysis
Data Validation & Integrity Checks
Pattern Recognition in Transaction Flows

The dataset represents financial transactions between accounts, including:
Source and destination accounts
Transaction amounts
Account balances before and after transactions
Fraud indicators
Transaction sequence steps

This structure enables multi-step transaction tracking and temporal fraud analysis.

1. Detecting Recursive Fraudulent Transactions (Money Laundering Chains)
Problem Statement: Identify potential money laundering chains where funds move across multiple accounts and all transactions in the chain are flagged as fraudulent.
Approach: A recursive Common Table Expression (CTE) is used to trace the flow of money from one account to another over successive transaction steps. The recursive logic allows the query to follow transaction paths of arbitrary length and isolate chains that may indicate coordinated fraudulent activity.
Key Insight: This approach helps uncover hidden transaction networks that are not visible through single-step analysis.

2. Analyzing Fraudulent Activity Over Time
Problem Statement: Calculate the rolling sum of fraudulent transactions for each account over the last five transaction steps.
Approach: A CTE combined with window functions computes a rolling fraud count per account. This temporal analysis helps understand how fraud activity evolves over time rather than viewing transactions in isolation.
Key Insight: Accounts with consistently high rolling fraud counts can be flagged for early risk detection and monitoring.

3. Complex Fraud Detection Using Multiple CTEs
Problem Statement: Identify accounts exhibiting multiple suspicious behaviors, including: Large transaction amounts, Consecutive transactions with no balance change, Transactions explicitly flagged as fraudulent.
Approach: Multiple CTEs are created, each targeting a specific fraud indicator. These are then combined to produce a consolidated list of accounts showing one or more high-risk behaviors.
Key Insight: Breaking logic into modular CTEs improves query readability, scalability, and maintainability, making it easier to extend fraud rules in the future.

4. Transaction Balance Validation (Data Integrity Check)
Problem Statement: Verify whether the computed destination balance matches the recorded destination balance after a transaction.
Approach: The query recalculates the expected destination balance and compares it against the actual value stored in the dataset.
Key Insight: This validation step helps identify data quality issues, processing errors, or potential manipulation, ensuring reliable analytics and model inputs.

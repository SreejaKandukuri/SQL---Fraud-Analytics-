use banking;
select * from transactions; 
#loading the data into the transactions table in the db, where each value is separated by comma in the csv file. text files are represented in quotation marks, each line represents a new transaction, skip the first row as its usually header value 
LOAD DATA INFILE "C:/Users/sreej/Downloads/archive (2)/PS_20174392719_1491204439457_log.csv" INTO TABLE transactions FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

SELECT * FROM PS_20174392719_1491204439457_log; 
drop table  PS_20174392719_1491204439457_log; 

-- identify recrusive fraud transactions 
-- money is transfered from one account to another as multiple steps with all transactions are flagged as fraudulent 

WITH RECURSIVE fraud_chain as (   #recursive function 
select nameOrig as initial_account, #sender account 
nameDest as next_Account, #receiveraccount 
step, #timerate 
amount, #money
newbalanceOrig
FROM
transactions 
WHERE isFraud = 1 and type = 'TRANSFER' #selecting the transactions that are fraud and the type is transfer 

UNION ALL 
SELECT fc.initial_account, 
t.nameDest,t.step,t.amount, t.newbalanceOrig
FROM fraud_chain fc
JOIN transactions t #joining transactions 
ON fc.next_Account = t.nameOrig and fc.step < t.step
where t.isFraud = 1 and t.type='TRANSFER')
SELECT * FROM fraud_chain;



-- identifying / calculate the rolling sum of the last 5 latest transactions - analyzing fraud activity over time 
#CTE is used to calculate the cumulative sum of fradulent transactions for each account over the last 5 steps 
#useful for identifying patterns over time 
with rolling_fraud as ( SELECT nameOrig,step, 
SUM(isFraud) OVER (PARTITION BY nameORig order by STEP ROWS BETWEEN  4 PRECEDING and CURRENT ROW ) AS 
fraud_rolling #summing is fraud and retrieving the rows by step 
FROM transactions) 
#select * from rolling_fraud;   

select * from rolling_fraud where fraud_rolling > 0; #retreving the accounts who did transactions in the last 5 transactions 


-- complex Fraud Transactions using multiple CTEs. to identify large transfers, consecutive transactions without balance change, suspicious activities 
# CTE for large transactions 
with large_transfer as ( 
SELECT nameOrig,step,amount FROM transactions where type = 'transfer' and amount > 500000),
no_balance_change as ( 
SELECT  nameOrig,step,oldbalanceOrg, newbalanceOrig from transactions where oldbalanceOrg = newbalanceOrig),
flagged_transactions as ( 
SELECT nameOrig, step FROM transactions where isflaggedfraud = 1)

#SELECT * FROM large_transfer limit 1 
#select * from 
SELECT lt.nameOrig 
FROM
large_transfer as lt
JOIN 
no_balance_change nbc on lt.nameOrig = nbc.nameOrig and lt.step = nbc.step 
JOIN
flagged_transactions ft on lt.nameOrig  = ft.nameOrig and lt.step = ft.step;  

#checking if the computed new_updatedBalance is the same as the actual  newbalannceDest
#check if old balance + account = new balance 
 
 with CTE as ( 
 SELECT amount, nameOrig, oldbalancedest, newbalancedest, ( amount+oldbalancedest) as new_updated_balance
 FROM transactions 
 )
 SELECT * FROM CTE where new_updated_balance = newbalancedest; 


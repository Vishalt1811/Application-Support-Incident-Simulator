from dotenv import load_dotenv
import os
from pathlib import Path
import oracledb

load_dotenv()

#------------------Classify_incident--------------------------------

def classify_incident(result,error_code):
    if result is None:
        return "Data_not_found"
    transaction_status=result[5]
    payment_status=result[7]

    if(transaction_status=="FAILED" and payment_status=="FAILED" and error_code=="GW_TIMEOUT"):
        return "Payment_timeout"
    return "Further_investigation_required"


#--------------------End of Classify_incident-----------------------------

#-----------------Investigate_Transaction Function Body--------------------------------

def investigate_transaction(cursor, sql, transaction_id, error_code):

    print("=" * 50 )
    print("Transaction Investigation")
    print("=" * 50)

    print("Transaction ID:", transaction_id)
    print("Application Error:", error_code)


    try:
        cursor.execute(sql, transaction_id=transaction_id)
        result=cursor.fetchone()
    except oracledb.Error as error:
        print(f"Error SQL query Failed {transaction_id}: {error}")
        return
    
   
    if result is None:
        print(f"Transaction {transaction_id} was not found in Oracle.")
        return
    else:
        print("----------Database Evidence-------------------")
        print(f"Transaction ID: {result[0]}")
        print(f"Account ID: {result[1]}")
        print(f"Account Balance: ${result[2]}")
        print(f"Transaction Type: {result[3]}")
        print(f"Amount: ${result[4]}")
        print(f"Transaction Status: {result[5]}")
        print(f"Payment ID: {result[6]}")
        print(f"Payment Status: {result[7]}")
        print(f"Payment Method: {result[8]}")
        print(f"Payment Date: {result[9]}")
        #print(f"Error Code: {error_code}")

        incident_type=classify_incident(result,error_code)
        print(f"Incident Type: {incident_type}")

        print("-----------------------Findings-------------------------")

        if result[2]<result[4]:
            print("Insufficient funds in the account")
        if result[5] == "FAILED":        
            print("Transaction is FAILED ")
        if result[7]=="FAILED":
            print("Payment is FAILED")
        if error_code == "GW_TIMEOUT":
            print("application recorded payment gateway timeout error.")

        print("-----------Root Cause Analysis------------------")

        print("Payment Transaction Failed, Evidence:")
        print(f"Transaction ID: {result[0]}")
        print(f"Account ID: {result[1]}")
        print(f"Account Balance: ${result[2]}")
        print(f"Transaction Type: {result[3]}")
        print(f"Amount: ${result[4]}")
        print(f"Transaction Status: {result[5]}")
        print(f"Payment ID: {result[6]}")
        print(f"Payment Status: {result[7]}")
        print(f"Payment Method: {result[8]}")
        print(f"Payment Date: {result[9]}")
        print(f"Error Code: {error_code}")
        print("Payment transaction failed.")

    print()
    print("Evidence:")

    print(f"- Transaction ID: {result[0]}")
    print(f"- Account ID: {result[1]}")
    print(f"- Account Balance: ${result[2]}")
    print(f"- Amount: ${result[4]}")
    print(f"- Transaction Status: {result[5]}")
    print(f"- Payment Status: {result[8]}")
    print(f"- Payment Method: {result[7]}")
    print(f"- Application Error: {error_code}")

    print()
    print("Current Root Cause Hypothesis:")

    if error_code == "GW_TIMEOUT":
        print(
            "The payment request appears to have failed after "
            "the application recorded a payment gateway timeout."
        )
    else:
        print(
            "The transaction failed and requires further "
            "technical investigation."
        )

    print()
    print("Root Cause Status:")
    print("NOT FULLY CONFIRMED")

    print()
    print("Recommended Additional Investigation:")

    print("- Payment gateway logs")
    print("- Gateway response time")
    print("- Network/connectivity metrics")
    print("- Application timeout configuration")
    print("- Request/correlation ID")



#------------------Function Body End--------------------------------












log_file=Path("logs/application.log")

try:
    with open(log_file, "r") as file:
        lines=file.readlines()
except FileNotFoundError:
    print(f"Log file '{log_file}' not found.")
    exit(1)


transaction_error={}


for line in lines:
    
    if "ERROR" in line:
        if "transaction_id=" not in line:
            print("Error found in log but no transaction_id present.")
            print("log: ",line.strip())
            continue

        if "error_code=" not in line:
            print("Error found in log but no error_code present.")
            print("log: ",line.strip())
            continue
        
        transaction_id=int(line.split("transaction_id=")[1].split()[0])
        error_code=line.split("error_code=")[1].split()[0]

        transaction_error[transaction_id]=error_code


#--------------Oracle Database Connection------------------ 


Username = os.getenv("ORACLE_USERNAME")
password = os.getenv("ORACLE_PASSWORD")

host = os.getenv("ORACLE_HOST", "localhost")
port = int(os.getenv("ORACLE_PORT", "1521"))
service_name = os.getenv("ORACLE_SERVICE", "orcl")

#Username="app_support"   #input("Enter Username : ")
#password=input("Enter Password : ")
#host="localhost"
#port=1521
#service_name="orcl"

if not Username or not password:
    print("Error: ORACLE_USERNAME and ORACLE_PASSWORD environment variables must be set.")
    exit(1)

try:
    connection=oracledb.connect(
    user=Username, 
    password=password, 
    dsn=f"{host}:{port}/{service_name}")
except oracledb.Error as error:
    print("Error: Unable to connect to the Oracle database.",error)
    print("Oracle error:", error)


cursor=connection.cursor()

# SQl Query--------------

sql="""Select t.Transaction_id,t.account_id,a.balance,
 t.transaction_type,t.amount,
 t.Transaction_status, p.payment_id, p.Payment_status, p.payment_method,
 p.Processed_date from transactions t join Payments p on
 t.transaction_id = p.transaction_id join accounts a
 on t.account_id = a.account_id
 where t.transaction_id=:transaction_id"""

 # SQL Query END---------------------------

for transaction_id in transaction_error:
    error_code = transaction_error[transaction_id]
    

    investigate_transaction(cursor, sql, transaction_id, error_code)







cursor.close()
connection.close()
print()
print("=" * 55)
print("Incident analysis completed.")
print("=" * 55)
from mysql.connector import connect, Error
import pandas as pd
import warnings
from getpass4 import getpass

try:
    db = connect(
        host='localhost',
        user=input('Enter username'),
        password=getpass('Enter password'),
        db='restaurant')
except Error as e:
    print(e)
#getpass
warnings.filterwarnings(action = 'ignore', category = UserWarning)

print("Welcome Manager!")

print("Below are the current manager messages.") 
manager_view = "SELECT message FROM manager LIMIT 1"
manager  = pd.read_sql(manager_view,db)
print(manager)


question = input("Would you like to see your weekly sales? ('yes' or 'no')")

if question == 'yes':
    sales_week = """select get_sales(%s, %s)"""
    inst_id = input("Enter manager_id: ")
    
    try:
        inst_id = int(inst_id)
    except ValueError:
        print("Noninteger Value Entered")
        inst_id = input("Re-enter manager_id: ")
        inst_id = int(inst_id)
        
    inst_date = input("Enter week start date (YYYY-MM-DD): ")
    va_list = (inst_id, inst_date)
    
    sales_total = 0.0
    try:
        with db.cursor() as cursor:
            cursor.execute(sales_week, va_list)
            get_sales_total = cursor.fetchall()
            for i in get_sales_total:
                sales_total = i[0]
    except Error as e:
        print(e)
        db.close()
    sales_total = str(sales_total)      
            
    print("Your weekly total is " + sales_total)

new_question = input("Would you like to see sales per week for the whole restaurant? ('yes' or 'no')")
if new_question == 'yes':
    sales_query = "SELECT WEEK(order_meta.order_date) as 'Week Number',SUM(order_detail.total) as 'Week Total' FROM order_detail INNER JOIN order_meta ON order_detail.order_id = order_meta.order_id GROUP BY (WEEK(order_meta.order_date))"
    sales_per_week = pd.read_sql(sales_query,db)
    print(sales_per_week)

question = input("Would you like to see pending orders? ('yes' or 'no'")
if question == "yes":
    query = """
        select order_detail.order_id,order_meta.order_date,order_meta.order_time, menu.item_name, menu.menu_type
        from order_meta, menu, order_detail
        where order_meta.order_id = order_detail.order_id and
            order_detail.item_id = menu.item_id and
            order_meta.order_status = 'cooking'"""
        
    pending_order  = pd.read_sql(query,db)
    print(pending_order)

# Choose table to update 
update = input("Would you like to add a new employee? ('yes' or 'no')")
if update == 'yes':
    emp = input("What type of employee would you like to add? ('manager','waiter',chef') ")    
    if emp == "waiter":
            waiter_old = "SELECT MAX(waiter_id) FROM waiter"
            wait_old = 0
            try:
                with db.cursor() as cursor:
                    cursor.execute(waiter_old)
                    wait_old_id = cursor.fetchall()
                    for i in wait_old_id:
                        wait_old = i[0]
            except Error as e:
                print(e)
                db.close()
            new_waiter = wait_old + 1
    
    # First name
            first = input("Enter employee first name: ")
    
    # Last name
            last = input("Enter employee last name: ")

    # Phone number
            phone = input("Enter employee phone number: ")

    # Email 
            email = input("Enter employee email: ")

    # Manager ID 
            m_id = input("Enter manager ID to assign to waiter: ")
            try:
                m_id = int(m_id)
            except ValueError:
                print("Non integer value entered")
                m_id = input("Please reenter manager ID")
                m_id = int(m_id)
    
    # Add values
            add_waiter_query = """
            insert into waiter values(%s, %s, %s, %s, %s, %s)
            """
            tuple_values = (new_waiter, first, last, phone, email, m_id)
            try:
                with db.cursor() as cursor: 
                    cursor.execute(add_waiter_query, tuple_values)
                    db.commit()
            except Error as e:
                print(e)
                db.close()
            print("Thank you for your input! Below is the new waiter information.")
            show_waiter = "SELECT * FROM waiter WHERE waiter_id = %s"
            waiter = pd.read_sql(show_waiter,db,params = [new_waiter])
            print(waiter)

# Chef
    elif emp == "chef":
            chef_query = "SELECT MAX(chef_id) FROM chef"
            chef_old = 0
            try:
                with db.cursor() as cursor:
                    cursor.execute(chef_query)
                    chef_old_id = cursor.fetchall()
                    for i in chef_old_id:
                        chef_old = i[0]
            except Error as e:
                print(e)
                db.close()
            new_chef = chef_old + 1

    # First name
            chef_first = input("Enter employee first name: ")

    # Last name
            chef_last = input("Enter the last name: ")

    # Phone number
            chef_phone = input("Enter the phone number: ")

    # Email 
            chef_email = input("Enter the email: ")

    # Manager ID 
            m_id = input("Enter manager ID to assign to chef: ")
            try:
                m_id = int(m_id)
            except ValueError:
                print("Non integer value entered")
                m_id = input("Please reenter your ID")
                m_id = int(m_id)
    
    # Add values
            add_chef_query = """
                insert into chef values(%s, %s, %s, %s, %s, %s)
                """
            tuple_values = (new_chef, chef_first, chef_last, chef_phone, chef_email, m_id)
            try:
                with db.cursor() as cursor: 
                    cursor.execute(add_chef_query, tuple_values)
                    db.commit()
            except Error as e:
                print(e)
                db.close()
            print("Thank you for your input! Below is the new chef information.")    
            show_chef = "SELECT * FROM chef WHERE chef_id = %s"
            chef = pd.read_sql(show_chef,db,params = [new_chef])
            print(chef)

    elif emp == "manager":
            manager_old = "SELECT MAX(manager_id) FROM manager"
            man_old = 0
            try:
                with db.cursor() as cursor:
                    cursor.execute(manager_old)
                    man_old_id = cursor.fetchall()
                    for i in man_old_id:
                        man_old = i[0]
            except Error as e:
                print(e)
                db.close()
            new_manager = man_old + 1

    # First name
            manager_first = input("Enter employee first name: ")

    # Last name
            manager_last = input("Enter employee last name: ")

    # Phone number
            manager_phone = input("Enter employee phone number: ")

    # Email 
            manager_email = input("Enter employee email: ")
        
            message = ""
                
    # Add values
            add_manager_query = """
                insert into manager values(%s, %s, %s, %s, %s, %s)
                """
            manager_values = (new_manager, manager_first, manager_last, manager_phone, manager_email, message)
            try:
                with db.cursor() as cursor: 
                    cursor.execute(add_manager_query, manager_values)
                    db.commit()
            except Error as e:
                print(e)
                db.close()
            print("Thank you for your input! Below is the new manager information")
            show_manager = "SELECT * FROM manager WHERE manager_id = %s"
            manager = pd.read_sql(show_manager,db,params = [new_manager])
            print(manager)

#Exit program
print("Northeastern Dining thanks you for your time! We appreciate your hard work!") 
db.close()

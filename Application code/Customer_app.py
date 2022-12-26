from mysql.connector import connect, Error
from getpass4 import getpass
import pandas as pd
from datetime import date
from datetime import datetime
import random
import warnings

#Connect to DB
try:
    conn = connect(
            host= 'localhost',
            user= input('Enter Username'),
            password = getpass('Enter Password'),
            database= 'restaurant')
except Error as e:
    print(e)



#Customer
warnings.filterwarnings(action = 'ignore', category = UserWarning)
print("Welcome to Premier Northeastern!")
print("We are the first dine-in restaurant at Northeastern serving student's favorite dishes")
print("Please see below for our menu items, to place an order, or to make a reservation.")
customer_view = "SELECT menu_type as 'Menu Type', item_name as 'Item', price as 'Price' FROM show_menu"
menu_data = pd.read_sql(customer_view, conn)
print(menu_data)


option = input("Would you like to place an order or make a reservation?(Write 'order', 'reservation')")

#Place order
if option == 'order':
    print("We appreciate you choosing Premier Northeastern!")
    customer_name = input("Enter your name")
    customer_phone = input("Enter your phone number")
    customer_email = input("Enter your email")
    num_items = input("How many different items would you like to order?")
    
    try:
        num_items = int(num_items)
    except ValueError:
        print("Non integer value entered")
        num_items = input("Re-enter: How many different items would you like to order?")
        num_items = int(num_items)
    
    items = []
    quantity = []
    prices = []
    for i in range(num_items):
        num = str(i + 1) 
        item_n = input('Enter item number (number before Menu Type column) for item '+ num)
        
        try:
            item_n = int(item_n)
        except ValueError:
            print("Non integer value entered")
            item_n = input('Re-enter item number (number before Menu Type column) for item '+ num)
            item_n = int(item_n)
            
        item_q = input('Enter quantity of item')
        
        try:
            item_q = int(item_q)
        except:
            print("Non integer value entered")
            item_q = input('Re-enter quantity of item')
            item_q = int(item_q)
            
        item = menu_data['Item'][item_n]
        price = menu_data['Price'][item_n]
        items.append(item)
        quantity.append(item_q)
        prices.append(price)


    #generate new customer id
    customer_old = "SELECT MAX(customer_id) FROM customer"
    cust_old = 0
    try:
        with conn.cursor() as cursor:
            cursor.execute(customer_old)
            cust_old_id = cursor.fetchall()
            for i in cust_old_id:
                cust_old = i[0]
    except Error as e:
        print(e)
        conn.close()
    new_customer = cust_old + 1
    
    #insert into customer table
    insert_customer = """INSERT INTO customer VALUES (%s,%s,%s,%s)"""
    customer_tuple = (new_customer,customer_name,customer_phone, customer_email)
    try:
        with conn.cursor() as cursor:
            cursor.execute(insert_customer,customer_tuple)
            conn.commit()
    except Error as e:
        print(e)
        conn.close()
    
    #generate new order id
    order_old = "SELECT MAX(order_id) FROM order_meta"
    or_old = 0
    try:
        with conn.cursor() as cursor:
            cursor.execute(order_old)
            or_old_id = cursor.fetchall()
            for i in or_old_id:
                or_old = i[0]
    except Error as e:
        print(e)
        conn.close()
    new_order = or_old + 1
    
    
    #store order_meta
    table_id = 0
    order_status = 'cooking'
    dine_delivery = 'no'
    today = date.today()
    time = datetime.now()
    meta_tuple = (new_order,today,time,order_status,table_id,dine_delivery)
    try:
        with conn.cursor() as cursor:
            cursor.callproc('store_order_meta',meta_tuple)
            conn.commit()
    except Error as e:
        print(e)
        conn.close()
    
    #insert into places table
    insert_places = """INSERT INTO places VALUES (%s,%s)"""
    places_tuple = (new_customer,new_order)
    try:
        with conn.cursor() as cursor:
            cursor.execute(insert_places,places_tuple)
            conn.commit()
    except Error as e:
        print(e)
        conn.close()
   
    index = 0
    #store order_detail
    for i in items:
        item_name = items[index]
        qty = quantity[index]
        total = qty * (prices[index])
        total = float(total)
        index = index + 1
        item_id = """SELECT item_id FROM menu WHERE item_name = %s"""
        item_tuple = (item_name,)
        i_id = 0
        try:
            with conn.cursor() as cursor:
                cursor.execute(item_id,item_tuple)
                get_item_id = cursor.fetchall()
                for i in get_item_id:
                    i_id = i[0]
            
            detail_tuple = (new_order, i_id, item_name,qty,total)
            with conn.cursor() as cursor:
                cursor.callproc('store_order_detail',detail_tuple)
                conn.commit()
        except Error as e:
            print(e)
            conn.close()
    
    #confirmation
    print("")
    print("")
    print("Thank you for your order! Your order is now in progress and will be ready shortly.")
    print("")
    print("")
    print("Below are the details of your order.")
    new_order_str = str(new_order)
    print("Your order id is " + new_order_str)
    order_query = "SELECT order_detail.item_name as 'Item', menu.price as 'Price', order_detail.quantity as 'Quantity',order_detail.total as 'Total' FROM order_detail INNER JOIN menu ON order_detail.item_id = menu.item_id WHERE order_id = %s"
    confirmation = pd.read_sql(order_query, conn, params = [new_order])
    print(confirmation)
    
    #display order_total for confirmation
    order_total = """SELECT get_total(%s)"""
    o_tuple = (new_order,)
    o_total = 0
    try:
        with conn.cursor() as cursor:
            cursor.execute(order_total,o_tuple)
            get_order_total = cursor.fetchall()
            for i in get_order_total:
                o_total = i[0]
    except Error as e:
        print(e)
        conn.close()
    o_total = str(o_total)
    print("Your order total is " + o_total)
    
if option == 'reservation':
    print('Please enter the following information for your reservation')
    reservation_time = input('Enter reservation time (ex. 7:00 PM as 19:00)')
    reservation_date = input('Enter reservation date (YYYY-MM-DD)')
    party_size = input('Enter party size')
    party_size = int(party_size)
    
    #generate reservation id
    reserve_old = "SELECT MAX(reservation_id) FROM reservation"
    res_old = 0
    try:
        with conn.cursor() as cursor:
            cursor.execute(reserve_old)
            res_old_id = cursor.fetchall()
            for i in res_old_id:
                res_old = i[0]
    except Error as e:
        print(e)
        conn.close()
    new_res_id = res_old + 1
    
    #generate table id
    get_table = "SELECT table_id FROM tables_ WHERE table_status = 'open'"
    table_id = 0
    try:
        with conn.cursor() as cursor:
            cursor.execute(get_table)
            tab_id = cursor.fetchall()
            for i in tab_id:
                table_id = i[0]
    except Error as e:
        print(e)
        conn.close()
    
    #Select Free waiter
    waiter_num = random.randint(0,9)
    get_waiter_list = "SELECT waiter_id FROM waiter"
    waiter_id = 0
    try:
        with conn.cursor() as cursor:
            cursor.execute(get_waiter_list)
            wait_id = cursor.fetchall()
            idx = 0
            for i in wait_id:
                if idx == waiter_num:
                    waiter_id = i[0]
                idx = 1+idx
    except Error as e:
        print(e)
        conn.close()
    
    #Update reservation table
    res_up = """INSERT INTO reservation VALUES (%s,%s,%s,%s)"""
    res_tuple = (new_res_id,reservation_date,reservation_time,party_size)
    try:
        with conn.cursor() as cursor:
            cursor.execute(res_up,res_tuple)
            conn.commit()
    except Error as e:
        print(e)
        conn.close()
    
    #update assists table
    assist_up = """INSERT INTO assists VALUES (%s,%s)"""
    assists_tuple = (waiter_id,new_res_id)
    try:
        with conn.cursor() as cursor:
            cursor.execute(assist_up,assists_tuple)
            conn.commit()
    except Error as e:
        print(e)
        conn.close()
        
    #update reserve_table
    rt_up = """INSERT INTO reserve_table VALUES (%s,%s)"""
    rt_tuple = (new_res_id,table_id)
    try:
        with conn.cursor() as cursor:
            cursor.execute(rt_up,rt_tuple)
            conn.commit()
    except Error as e:
        print(e)
        conn.close()
    
    print("Thank you for making a reservation! Below are your reservation details.")
    res_detail = "SELECT reservation_id as 'Reservation ID',reservation_date as 'Date', reservation_time as 'Time', party_size as 'Party Size' FROM reservation WHERE reservation_id = %s"
    details = pd.read_sql(res_detail,conn,params = [new_res_id])
    print(details)

print("Thank you for choosing Premier Northeastern for your dining needs! We hope to see you soon!")
conn.close()  

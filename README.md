# ProntoPizza-Database

SQL script for the database project at DHBW Stuttgart in the 4th semester.
<br/>
<h2>Requirements analysis</h2>
The Heilbronn-based delivery service "Pronto Pizza" aims to optimize its
order processing and the digitalization of customer and employee data. The
orders are to be recorded and processed by software in the future.
The delivery service has expanded considerably as a result of the Corona lockdowns, and therefore employs
several employees with different areas of responsibility. In addition to some cooks
suppliers are also employed. There are always 3 suppliers assigned to each shift, each of which
takes over exactly one of the three delivery zones completely. Employees of the same job
can substitute for each other in case of illness.
Orders placed by customers consist of a single item or several items.
several items. The company's product range includes pizza specialties as well as
Italian wines. Several of the same dishes or drinks from the range can also be ordered per order.
from the offer can be ordered. The pizzas are topped with ingredients according to the customer's wishes.
with ingredients according to the customer's wishes. It should be noted that a pizza can be topped with a minimum of 2 and a maximum of 7 different ingredients.
different ingredients. Since the capacities in the stone oven are limited,
a single customer order can only consist of a maximum of 10 pizzas. For the wines
no restriction. The order is delivered to the customer by a supplier.
Various personal data should be collected on the customers and employees.
be recorded. For the customers, this includes customer number, first name, last name, address,
telephone number and e-mail address. For employees, instead of the customer number
salary, bank account data and tax identification number are also stored.
are stored. Since the family comes first at Pronto Pizza, employees dine for free and are not recorded as customers.
free of charge and are not recorded as customers.

<h2>Conceptual design</h2>

![Datenbanken_KonzeptionellerEntwurf_JonathanDiebel_2341463](https://user-images.githubusercontent.com/88625959/164546326-9c497923-162c-4851-bf1b-589354a984f7.jpg)

<h2>Deletion rules</h2>

![Datenbanken_ConstraintFürDelete_JonathanDiebel_2341463](https://user-images.githubusercontent.com/88625959/164546387-187816ac-34a3-4768-a350-883537b6d2ef.jpg)

<h2>Views</h2>
<b>HR Department:</b><br/>
1) The data of the cooks and suppliers, including telephone numbers, are to be completely
be displayed in an employee table.<br/>
2) Employees who earn more than the average salary with tax ID, first name
and last name sorted by salary.<br/><br/>
<b>Cooks:</b><br/>
3) Overview of all current open pizza orders with items, responsible
Cooks and sorted by order date.<br/>
4) Overview of all currently open wine orders with articles, responsible cooks and
cooks and sorted by order date.<br/>
5) Overview of the ingredients currently in stock, sorted by quantity, whose
Stock is still 20 items or less.<br/><br/>
<b>Suppliers:</b><br/>
6) Overview of all currently open orders with customer address, responsible
Suppliers and sorted by order date.<br/><br/>
<b>Customers:</b><br/>
7) Menu with all pizzas and information on item numbers, sizes, prices and toppings.
toppings.<br/>
8) Display menu with all vegetarian pizzas and information on item numbers, sizes, prices and toppings,
prices and toppings.<br/>
9) Show beverage list with all wines and information on article numbers, grape varieties, vintages and prices.
and prices.<br/><br/>
<b>Boss:</b><br/>
10) View customer information including phone numbers, total number of orders, number of
ordered food & beverages and the generated revenue by the customer should be
be displayed in a table.<br/>
11) From all orders of the current day, the number of orders, the
the number of orders, the number of meals & beverages sold and the total turnover.

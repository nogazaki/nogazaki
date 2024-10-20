annual_salary = float(input("Enter your annual salary: "))
portion_saved = float(input("Enter the percent of your salary to save, as a decimal: "))
total_cost = float(input("Enter the cost of your dream home: "))

months = 0
current_savings = 0
monthly_save = annual_salary / 12 * portion_saved

while current_savings < total_cost * 0.25:
    current_savings += (current_savings * 0.04 / 12) + monthly_save
    months += 1

print("Number of months: ", months)

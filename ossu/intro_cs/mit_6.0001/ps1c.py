annual_salary = float(input("Enter the starting salary: "))
total_cost = 1000000
portion_down_payment = total_cost * 0.25
semi_annual_raise = 0.07

lower_limit = 0
upper_limit = 1
portion_saved = 0.5
steps = 0


def calculate_saving(portion_saved):
    current_savings = 0
    monthly_save = annual_salary / 12 * portion_saved

    for month in range(1, 37):
        current_savings += (current_savings * 0.04 / 12) + monthly_save
        if month % 6 == 0:
            monthly_save *= semi_annual_raise + 1

    return current_savings


if calculate_saving(upper_limit) < portion_down_payment:
    print("It is not possible to pay the down payment in three years")
else:
    while True:
        steps += 1
        saved = calculate_saving(portion_saved)

        if abs(saved - portion_down_payment) <= 100:
            break

        if saved > portion_down_payment:
            upper_limit = portion_saved
        else:
            lower_limit = portion_saved

        portion_saved = (upper_limit - lower_limit) / 2 + lower_limit

    print("Best savings rate: ", round(portion_saved, 4))
    print("Steps in bisection search: ", steps)

#!/usr/bin/env python3

class Car():

    def __init__(self, make, model, year):
        self.make = make
        self.model = model
        self.year = year
        self.odometer_reading = 0

    def __str__(self):
        return str(self.__class__) + ": " + str(self.__dict__)

    def get_descriptive_name(self):
        long_name = str(self.year) + ' ' + self.make + ' ' + self.model
        return long_name.title()

    def read_odometer(self):
        print("This car has " + str(self.odometer_reading) + " miles on it.")

    def update_odometer(self, mileage):
        if mileage >= self.odometer_reading:
            self.odometer_reading = mileage
        else:
            print("You can't roll back an odometer!")

    def increment_odometer(self, miles):
        self.odometer_reading += miles


class ElectricCar(Car):

    def __init___(self, make, model, year):
        super(ElectricCar, self).__init__(make, model, year)
        self.odometer_reading = 100
        self.battery_size = 70

    def __str__(self):
        return str(self.__class__) + ": " + str(self.__dict__)

    def describe_battery(self):
        print(self.battery_size)


my_tesla = ElectricCar('tesla', 'model s', 2016)
# print(my_tesla.describe_battery())

print(my_tesla)

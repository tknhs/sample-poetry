from abc import ABCMeta, abstractmethod


class Animal(metaclass=ABCMeta):
    @abstractmethod
    def say(self):
        pass


class Dog(Animal):
    def say(self):
        return "Bow Wow"


class Cat(Animal):
    def say(self):
        return "Meow"

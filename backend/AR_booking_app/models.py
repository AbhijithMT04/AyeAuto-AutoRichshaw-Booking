from django.db import models

# Create your models here.

class login(models.Model):
    username = models.CharField(max_length=100)
    password = models.CharField(max_length=100)
    usertype = models.CharField(max_length=100)

class fare(models.Model):
    fare = models.CharField(max_length=100)

class driver(models.Model):
    name = models.CharField(max_length=100)
    phone = models.CharField(max_length=100)
    email = models.CharField(max_length=100)
    pin = models.CharField(max_length=100)
    post = models.CharField(max_length=100)
    place = models.CharField(max_length=100)
    photo = models.CharField(max_length=100)
    proof = models.CharField(max_length=100)
    LOGIN = models.ForeignKey(login,on_delete=models.CASCADE)
    available_status = models.CharField(max_length=100,default=1)


class user(models.Model):
    name =  models.CharField(max_length=100)
    phone = models.CharField(max_length=100)
    email = models.CharField(max_length=100)
    pin = models.CharField(max_length=100)
    post= models.CharField(max_length=100)
    place = models.CharField(max_length=100)
    LOGIN = models.ForeignKey(login, on_delete=models.CASCADE)

class rating_review(models.Model):
    rating = models.CharField(max_length=100)
    review = models.CharField(max_length=100)
    date = models.CharField(max_length=100)
    USER = models.ForeignKey(user,on_delete=models.CASCADE)
    DRIVER = models.ForeignKey(driver,on_delete=models.CASCADE)


class request(models.Model):
    USER = models.ForeignKey(user, on_delete=models.CASCADE)
    DRIVER = models.ForeignKey(driver, on_delete=models.CASCADE)
    from_location = models.CharField(max_length=100)
    to_location = models.CharField(max_length=100)
    date_and_time = models.DateField(max_length=100)
    status = models.CharField(max_length=100)
    amount = models.CharField(max_length=100)

class payment(models.Model):
    USER = models.ForeignKey(user, on_delete=models.CASCADE)
    date_and_time = models.CharField(max_length=100)
    REQUEST = models.ForeignKey(request, on_delete=models.CASCADE)
    payment_type = models.CharField(max_length=100)
    payment_status = models.CharField(max_length=100)

class report(models.Model):
    DRIVER = models.ForeignKey(driver, on_delete=models.CASCADE)
    USER = models.ForeignKey(user, on_delete=models.CASCADE,default=1)
    reason = models.CharField(max_length=100)
    date = models.CharField(max_length=100)

class chat(models.Model):
    DRIVER = models.ForeignKey(driver, on_delete=models.CASCADE)
    USER = models.ForeignKey(user, on_delete=models.CASCADE)
    date = models.CharField(max_length=100)
    message = models.CharField(max_length=100)
    type = models.CharField(max_length=100,default=1)

class feedback(models.Model):
    LOGIN = models.ForeignKey(login, on_delete=models.CASCADE,default=1)
    feedback = models.CharField(max_length=100)
    date = models.CharField(max_length=100)


















from django.contrib.auth.models import User
from django.db import models

# Create your models here.
class Forestdivision(models.Model):
    name=models.CharField(max_length=100)
    place=models.CharField(max_length=100)



class Foreststation(models.Model):
    name = models.CharField(max_length=100)
    Email = models.CharField(max_length=100)
    phone = models.CharField(max_length=100)
    pin = models.CharField(max_length=100)
    Place = models.CharField(max_length=100)
    District = models.CharField(max_length=100)
    State= models.CharField(max_length=100)
    FORESTDIVISION = models.ForeignKey(Forestdivision, on_delete=models.CASCADE)




class Forestofficer(models.Model):
    name = models.CharField(max_length=100)
    gender = models.CharField(max_length=100)
    place = models.CharField(max_length=100)
    email = models.CharField(max_length=100)
    dob = models.CharField(max_length=100)
    photo = models.CharField(max_length=100)
    phone_number= models.CharField(max_length=100)
    district= models.CharField(max_length=100)
    state= models.CharField(max_length=100)
    FORESTSTATION = models.ForeignKey(Foreststation, on_delete=models.CASCADE)
    AUTH_USER=models.OneToOneField(User,on_delete=models.CASCADE)




class Users(models.Model):
     name = models.CharField(max_length=100)
     gender = models.CharField(max_length=100)
     dob = models.CharField(max_length=100)
     number = models.CharField(max_length=100)
     email = models.CharField(max_length=100)
     place= models.CharField(max_length=100)
     disrict = models.CharField(max_length=100)
     state = models.CharField(max_length=100)
     photo = models.CharField(max_length=100)
     pin = models.CharField(max_length=100)
     AURH_USER=models.OneToOneField(User,on_delete=models.CASCADE)


class Complaint(models.Model):
    complaint = models.CharField(max_length=100)
    date = models.DateField()
    replay = models.CharField(max_length=100)
    status = models.CharField(max_length=100)
    USERS=models.ForeignKey(Users,on_delete=models.CASCADE)

class Product(models.Model):
    name= models.CharField(max_length=100)
    quantity = models.CharField(max_length=100)
    image = models.CharField(max_length=100)
    price = models.CharField(max_length=100)
    description = models.CharField(max_length=100)
    USERS=models.ForeignKey(Users,on_delete=models.CASCADE)

class Cart(models.Model):
    quantity = models.CharField(max_length=100)
    date = models.DateField()
    USERS=models.ForeignKey(Users,on_delete=models.CASCADE)
    PRODUCT=models.ForeignKey(Product,on_delete=models.CASCADE)


class Alert(models.Model):
    latitude = models.CharField(max_length=100)
    longitude = models.CharField(max_length=100)
    message = models.CharField(max_length=500)
    date = models.DateField()
    OFFICER = models.ForeignKey(Forestofficer, on_delete=models.CASCADE)

class Detect_Alert(models.Model):
    latitude = models.CharField(max_length=100)
    longitude = models.CharField(max_length=100)
    message = models.CharField(max_length=500)
    animal_name = models.CharField(max_length=500)
    animal_image = models.CharField(max_length=500)
    date = models.DateField()



class Ordermain(models.Model):
    total_amount=models.CharField(max_length=200)
    Date=models.DateField(max_length=500)
    Status=models.CharField(max_length=500)
    PRODUCT_OWNER=models.ForeignKey(Users,on_delete=models.CASCADE,related_name='owner')
    BUYING_USERS = models.ForeignKey(Users, on_delete=models.CASCADE,related_name='buyer')



class Ordersub(models.Model):
    Quantity = models.CharField(max_length=200)
    ORDERMAIN = models.ForeignKey(Ordermain, on_delete=models.CASCADE)
    PRODUCT = models.ForeignKey(Product, on_delete=models.CASCADE)















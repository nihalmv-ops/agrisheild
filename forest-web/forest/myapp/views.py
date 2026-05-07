import datetime

from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.hashers import check_password
from django.contrib.auth.models import Group, User
from django.core.files.storage import FileSystemStorage
from django.http import JsonResponse
from django.shortcuts import render, redirect


# Create your views here.
from django.views.decorators.csrf import csrf_exempt

from myapp.models import *


def loginpage_get(request):
    return render(request,"loginpage.html")

def loginpage_post(request):
    username=request.POST['username']
    password=request.POST['password']
    print(request.POST)

    check=authenticate(request,username=username, password=password)
    if check is not None:
        login(request,check)
        if check.groups.filter(name='admin'):
            return redirect('/myapp/adminhome_get/')
        if check.groups.filter(name='forestofficer').exists():
            return redirect('/myapp/officer_home_get/')
        else:
            return redirect('/myapp/loginpage_get/')
    else:
        return redirect('/myapp/loginpage_get/')


def logout_post(request):
    logout(request)
    return redirect('/myapp/loginpage_get/')


def adminhome_get(request):
    return render(request,"admin/adminhome.html")



def addforestdivision_get(request):
    return render(request,'admin/Add_forestdivision.html')

def addforestdivision_post(request):
    name=request.POST['name']
    place=request.POST['place']
    data=Forestdivision()
    data.name=name
    data.place=place
    data.save()
    return redirect('/myapp/viewforestdivision_get/#a')

def viewforestdivision_get(request):
    data=Forestdivision.objects.all()
    return render(request,'admin/view_forestdivision.html',{'data':data})

def editforestdivision_get(request,id):
    data=Forestdivision.objects.get(id=id)
    return render(request,'admin/edit_forestdivision.html',{'data':data})

def deleteforestdivision_get(request,id):
    Forestdivision.objects.get(id=id).delete()
    return redirect('/myapp/viewforestdivision_get/#a')

def editforestdivision_post(request):
    name=request.POST['name']
    place=request.POST['place']
    id=request.POST['id']
    data=Forestdivision.objects.get(id=id)
    data.name = name
    data.place = place
    data.save()
    return redirect('/myapp/viewforestdivision_get/#a')




def addforeststation_get(request):
    data=Forestdivision.objects.all()
    return render(request,'admin/add_foreststation.html',{'data':data})

def addforeststation_post(request):
    Name=request.POST['name']
    email_address=request.POST['email']
    phone=request.POST['phone']
    place=request.POST['place']
    district=request.POST['district']
    state=request.POST['state']
    pincode=request.POST['pincode']
    division=request.POST['division']

    s=Foreststation()
    s.name=Name
    s.Email=email_address
    s.phone=phone
    s.pin=pincode
    s.Place=place
    s.District=district
    s.State=state
    s.FORESTDIVISION_id=division
    s.save()
    return redirect('/myapp/viewforeststation_get/')

def viewforeststation_get(request):
    data=Foreststation.objects.all()
    return render(request,'admin/view_foreststation.html',{'data':data})

def deleteforeststation_get(request,id):
    Foreststation.objects.filter(id=id).delete()
    return redirect('/myapp/viewforeststation_get/#a')

def editforeststation_get(request,id):
    data1=Forestdivision.objects.all()
    data=Foreststation.objects.get(id=id)
    return render(request,'admin/edit_foreststation.html',{'data':data,'data1':data1})


def editforeststation_post(request):
    Name=request.POST['name']
    email_address=request.POST['email']
    phone=request.POST['phone']
    place=request.POST['place']
    district=request.POST['district']
    state=request.POST['state']
    pincode=request.POST['pincode']
    division=request.POST['division']
    id=request.POST['id']

    s=Foreststation.objects.get(id=id)
    s.name=Name
    s.Email=email_address
    s.phone=phone
    s.pin=pincode
    s.Place=place
    s.District=district
    s.State=state
    s.FORESTDIVISION_id=division
    s.save()
    return redirect('/myapp/viewforeststation_get/#a')

def addforestofficer_get(request):
    data=Foreststation.objects.all()
    return render(request,'admin/add_forestofficer.html',{'data':data})

def addforestofficer_post(request):
    name=request.POST['name']
    gender=request.POST['gender']
    place=request.POST['place']
    District=request.POST['district']
    dob=request.POST['dob']
    state=request.POST['state']
    email=request.POST['email']
    photo=request.FILES['photo']
    phone=request.POST['phone']
    foreststation=request.POST['foreststation']

    fs=FileSystemStorage()
    date=datetime.datetime.now().strftime('%d-%M-%Y-%H-%M-%S')+".jpg"
    fs.save(date,photo)
    path=fs.url(date)

    u=User.objects.create_user(username=email,password=phone)
    u.groups.add(Group.objects.get(name="forestofficer"))
    u.save()

    d=Forestofficer()
    d.name=name
    d.gender=gender
    d.place=place
    d.district=District
    d.dob=dob
    d.state=state
    d.email=email
    d.photo=path
    d.phone_number=phone
    d.FORESTSTATION_id=foreststation
    d.AUTH_USER=u
    d.save()

    return redirect('/myapp/viewforestofficer_get')






def viewforestofficer_get(request):
    data=Forestofficer.objects.all()
    return render(request,'admin/view_forestofficer.html',{'data':data})


def editforestofficer_get(request,id):
    i=Forestofficer.objects.get(id=id)
    data=Foreststation.objects.all()

    return render(request,'admin/edit_forestofficer.html',{"i":i,'data':data})

def editforstofficer_post(request):
    name = request.POST['name']
    gender = request.POST['gender']
    place = request.POST['place']
    District = request.POST['district']
    dob = request.POST['dob']
    state = request.POST['state']
    email = request.POST['email']
    phone = request.POST['phone']
    foreststation = request.POST['foreststation']
    id=request.POST['id']



    d = Forestofficer.objects.get(id=id)
    if 'photo' in request.FILES:
        photo = request.FILES['photo']
        fs = FileSystemStorage()
        date = datetime.datetime.now().strftime('%d-%M-%Y-%H-%M-%S') + ".jpg"
        fs.save(date, photo)
        path = fs.url(date)
        d.photo = path
        d.save()

    d.name = name
    d.gender = gender
    d.place = place
    d.district = District
    d.dob = dob
    d.state = state
    d.email = email
    d.phone_number = phone
    d.FORESTSTATION_id = foreststation
    d.save()

    return redirect('/myapp/viewforestofficer_get')

def deleteforestofficer_get(request,id):
    Forestofficer.objects.filter(AUTH_USER_id=id).delete()
    User.objects.get(id=id).delete()
    return redirect('/myapp/viewforestofficer_get/#a')


def viewalert_get(request):
    data=Detect_Alert.objects.all
    return render(request, 'admin/view alert.html',{'data':data})





def changepassword_get(request):
    return render(request,'admin/change_password.html')


def changepassword_post(request):
    password=request.POST['password']
    new_password=request.POST['new_password']
    confirm_password=request.POST['confirm_password']

    if check_password(password,request.user.password):
        if new_password==confirm_password:
            user=request.user
            user.set_password(new_password)
            user.save()
            return redirect('/myapp/loginpage_get/')
        else:
            return redirect('/myapp/changepassword_get/')

    else:
        return redirect('/myapp/changepassword_get/')


def sendreplay_get(request,id):
    data=Complaint.objects.get(id=id)
    return render(request,'admin/send_replay.html',{'data':data})

def sendreplay_post(request):
    replay=request.POST['replay']
    id=request.POST['id']

    obj=Complaint.objects.get(id=id)
    obj.replay=replay
    obj.status='replayed'
    obj.save()
    return redirect('/myapp/viewcomplaint_get/')



def viewcomplaint_get(request):
    data=Complaint.objects.all
    return render(request,'admin/view_complaint.html',{'data':data})


#------------- Officer --------

def officer_home_get(request):
    return render(request,'forest officer/officer_home.html')


def officer_viewprofile(request):
    data=Forestofficer.objects.get(AUTH_USER_id=request.user.id)
    return render(request,'forest officer/view_profile.html',{'data':data})



def officer_viewcomplaint(request):
    data=Complaint.objects.all()
    return render(request,'forest officer/view_complaint.html',{'data':data})


def officer_sendreplay_get(request,id):
    data=Complaint.objects.get(id=id)
    return render(request,'forest officer/send_replay.html',{'data':data})

def officer_sendreplay_post(request):
    replay=request.POST['replay']
    id=request.POST['id']

    obj=Complaint.objects.get(id=id)
    obj.replay=replay
    obj.status='replayed'
    obj.save()
    return redirect('/myapp/officer_viewcomplaint/')

def officer_sendalert_get(request):
    return render(request,'forest officer/send_alert.html')

def officer_sendalert_post(request):
    latitude=request.POST['latitude']
    longitude=request.POST['longitude']
    message=request.POST['message']

    a=Alert()
    a.latitude=latitude
    a.longitude=longitude
    a.message=message
    a.date=datetime.datetime.now().today()
    a.OFFICER=Forestofficer.objects.get(AUTH_USER_id=request.user.id)
    a.save()
    return redirect('/myapp/officer_viewalert_get/#b')


def officer_viewalert_get(request):
    data=Alert.objects.filter(OFFICER__AUTH_USER_id=request.user.id)
    return render(request,'forest officer/view alert.html',{'data':data})


def officer_deletealert(request,id):
    Alert.objects.get(id=id).delete()
    return redirect('/myapp/officer_viewalert_get/#b')


def officer_changepassword_get(request):
    return render(request,'forest officer/change_password.html')


def officer_changepassword_post(request):
    password=request.POST['password']
    new_password=request.POST['new_password']
    confirm_password=request.POST['confirm_password']

    if check_password(password,request.user.password):
        if new_password==confirm_password:
            user=request.user
            user.set_password(new_password)
            user.save()
            return redirect('/myapp/loginpage_get/')
        else:
            return redirect('/myapp/officer_changepassword_get/#b')

    else:
        return redirect('/myapp/officer_changepassword_get/#b')



#----------- users------------
@csrf_exempt
def user_signup(request):
    name=request.POST['name']
    email=request.POST['email']
    number=request.POST['number']
    gender=request.POST['gender']
    dob=request.POST['dob']
    place=request.POST['place']
    district=request.POST['district']
    state=request.POST['state']
    pincode=request.POST['pincode']
    photo=request.FILES['photo']
    password=request.POST['password']
    confirm_password=request.POST['confirm_password']

    print(pincode,number,district)

    print(photo,'ggggg')

    fs=FileSystemStorage()
    date=datetime.datetime.now().strftime('%Y%m%d%H%M%S')+'.jpg'
    fs.save(date,photo)
    path=fs.url(date)


    if password==confirm_password:
        user=User.objects.create_user(username=email,password=password)
        user.groups.add(Group.objects.get(name='user'))
        user.save()

        v=Users()
        v.name=name
        v.gender=gender
        v.dob=dob
        v.number=number
        v.email=email
        v.place=place
        v.disrict=district
        v.state=state
        v.photo=path
        v.pin=pincode
        v.AURH_USER=user
        v.save()
        return JsonResponse({'status':'ok'})
    else:

        return JsonResponse({'status': 'no'})

def userloginpage_post(request):
    username = request.POST['username']
    password = request.POST['password']
    print(request.POST)

    check = authenticate(request, username=username, password=password)
    if check is not None:
        login(request, check)
        if check.groups.filter(name='user'):
            return JsonResponse({'status':'ok','lid':str(check.id)})
        else:
            return JsonResponse({'status':'No'})
    else:
        return JsonResponse({'status': 'No'})


def  user_viewprofile_post(request):
    id=request.POST['lid']
    a=Users.objects.get(AURH_USER_id=id)
    return JsonResponse({
        'status':'ok',
        'name':a.name,
        'gender':a.gender,
        'dob':a.dob,
        'number':a.number,
        'email':a.email,
        'place':a.place,
        'disrict':a.disrict,
        'state':a.state,
        'photo':a.photo,
        'pincode':a.pin,

    })


def edit_userprofile_POST(request):
    id=request.POST['lid']
    name = request.POST['name']
    email = request.POST['email']
    number = request.POST['number']
    gender = request.POST['gender']
    dob = request.POST['dob']
    place = request.POST['place']
    district = request.POST['district']
    state = request.POST['state']
    pincode = request.POST['pincode']

    obj=Users.objects.get(AURH_USER_id=id)
    if 'photo' in request.FILES:
        photo = request.FILES['photo']
        fs = FileSystemStorage()
        date = datetime.datetime.now().strftime('%Y%m%d%H%M%S') + '.jpg'
        fs.save(date, photo)
        path = fs.url(date)
        obj.photo=path
    obj.name = name
    obj.gender = gender
    obj.dob = dob
    obj.number = number
    obj.email = email
    obj.place = place
    obj.disrict = district
    obj.state = state
    obj.pin = pincode
    obj.save()
    return JsonResponse({'status': 'ok'})

def user_add_product(request):
    Name = request.POST['Name']
    Quantity = request.POST['Quantity']
    photo = request.FILES['photo']
    price = request.POST['price']
    description = request.POST['description']
    lid = request.POST['lid']

    fs = FileSystemStorage()
    date = datetime.datetime.now().strftime('%Y%m%d%H%M%S') + '.jpg'
    fs.save(date, photo)
    path = fs.url(date)

    v=Product()
    v.name= Name
    v.quantity=Quantity
    v.image=path
    v.price=price
    v.description=description
    v.USERS=Users.objects.get(AURH_USER=lid)
    v.save()
    return JsonResponse({'status': 'ok'})


def view_product(request):
    lid = request.POST['lid']
    l=[]
    data=Product.objects.filter(USERS__AURH_USER=lid)
    for i in data:
        l.append({
            'id':i.id,
            'name':i.name,
            'quantity':i.quantity,
            'image':i.image,
            'price':i.price,
            'description':i.description,
        })
    print(l)
    return JsonResponse({'status': 'ok','data':l})


def edit_product(request):
    id = request.POST['pid']
    data=Product.objects.get(id=id)
    return JsonResponse({'status': 'ok','name':data.name,
                         'quantity':data.quantity,
                         'image':data.image,
                         'price':data.price,
                         'description':data.description})


def edit_product_post(request):
    id=request.POST['pid']
    name = request.POST['name']
    quantity = request.POST['quantity']
    price = request.POST['price']
    description = request.POST['description']


    v = Product.objects.get(id=id)
    if 'image' in request.FILES:
        image = request.FILES['image']
        fs = FileSystemStorage()
        date = datetime.datetime.now().strftime('%Y%m%d%H%M%S') + '.jpg'
        fs.save(date, image)
        path = fs.url(date)
        v.image = path

    v.name = name
    v.quantity = quantity
    v.price = price
    v.description = description
    v.save()
    return JsonResponse({'status': 'ok'})

def delete_product_post(request):
    id=request.POST['pid']
    Product.objects.filter(id=id).delete()

    return JsonResponse({'status':'ok'})






def view_alert(request):
    lid = request.POST['lid']
    l=[]
    data=Alert.objects.all()
    for i in data:
        l.append({
            'id':i.id,
            'latitude':i.latitude,
            'longitude':i.longitude,
            'message':i.message,
            'date':i.date,
            'officer':i.OFFICER.name,
        })
    return JsonResponse({'status': 'ok','data':l})



def changepassword_post(request):
    id=request.POST['lid']
    currentpassword = request.POST['currentpassword']
    changepassword = request.POST['changepassword']
    confirmpassword = request.POST['confirmpassword']
    user=User.objects.get(id=id)
    if user.check_password(currentpassword):
        if changepassword==confirmpassword:
            user.set_password(changepassword)
            user.save()
            logout(request)
            return JsonResponse({'status':'ok'})
        else:
            return JsonResponse({'status': 'No'})
    else:
        return JsonResponse({'status': 'No'})







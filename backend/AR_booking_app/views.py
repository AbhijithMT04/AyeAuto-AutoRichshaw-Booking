import datetime
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

from django.core.files.storage import FileSystemStorage
from django.http import HttpResponse, JsonResponse
from django.shortcuts import render

# Create your views here.
from AR_booking_app.models import *


def Login(request):
    return render(request,'index.html')


def login_post(request):
    username1 = request.POST['textfield']
    password1 = request.POST['textfield2']
    res=login.objects.filter(username=username1,password=password1)
    if res.exists():
        res=res[0]
        request.session['lid']=res.id
        request.session['log']="lg"
        if res.usertype=="admin":
            return HttpResponse("<script>alert('login suceess');window.location='/Homepage'</script>")

        elif res.usertype=="driver":
            return HttpResponse("<script>alert('login suceess');window.location='/Home_Page'</script>")
    else:
        return HttpResponse("<script>alert('login failed');window.location='/'</script>")


def Addfare(request):
    if request.session['log']!="lg":
        return HttpResponse("<script>alert('logout successfully');window.location='/'</script>")
    request.session['head']="ADD FARE"
    return render(request,'admin/add_fare.html')

def Addfare_post(request):
    fare1 = request.POST['textfield']
    i=fare.objects.filter(fare=fare1)
    if i.exists():
        return HttpResponse("<script>alert('Already Added');window.location='/Addfare'</script>")
    else:
        obj = fare()
        obj.fare = fare1
        obj.save()
        return HttpResponse("<script>alert('Added suceessfully');window.location='/Viewfare'</script>")


def Viewfare(request):
    if request.session['log']!="lg":
        return HttpResponse("<script>alert('logout successfully');window.location='/'</script>")
    res=fare.objects.all()
    request.session['head']="VIEW FARE"
    return render(request,'admin/view_fare.html',{"data":res})

def delete_fare(request,id):
    fare.objects.get(id=id).delete()
    return HttpResponse("<script>alert('Deleted successfully');window.location='/Viewfare'</script>")




def Viewdriverandverify(request):
    res=driver.objects.filter(LOGIN__usertype="pending")
    request.session['head']="DRIVER VERIFY"
    if request.session['log']!="lg":
        return HttpResponse("<script>alert('logout successfully');window.location='/'</script>")

    return render(request,'admin/view_driver&verify.html',{"data":res})

def approve_driver(request,id):
    login.objects.filter(id=id).update(usertype="driver")
    import smtplib
    s = smtplib.SMTP(host='smtp.gmail.com', port=587)
    s.starttls()
    s.login(os.environ.get("EMAIL_USER"), os.environ.get("EMAIL_PASS"))
    msg = MIMEMultipart()  # create a message.........."
    msg['From'] = os.environ.get("EMAIL_USER")
    msg['To'] = login.objects.get(id=id).username
    msg['Subject'] = "Your Request Status"
    body = "Your Request is Approved"
    msg.attach(MIMEText(body, 'plain'))
    s.send_message(msg)
    return HttpResponse("<script>alert('Approved');window.location='/Homepage'</script>")

def reject_driver(request,id):
    login.objects.filter(id=id).update(usertype="reject")
    import smtplib
    s = smtplib.SMTP(host='smtp.gmail.com', port=587)
    s.starttls()
    s.login("arbooking666@gmail.com", "tvwa oezn pwqt frbr")
    msg = MIMEMultipart()  # create a message.........."
    msg['From'] = "arbooking666@gmail.com"
    msg['To'] = login.objects.get(id=id).username
    msg['Subject'] = "Your Request Status"
    body = "Your Request is Rejected"
    msg.attach(MIMEText(body, 'plain'))
    s.send_message(msg)
    return HttpResponse("<script>alert('Rejected');window.location='/Homepage'</script>")

def view_verified_drivers(request):
    res=driver.objects.filter(LOGIN__usertype__in=["driver","block"])
    request.session['head']="VERIFIED DRIVERS"
    if request.session['log']!="lg":
        return HttpResponse("<script>alert('logout successfully');window.location='/'</script>")

    return render(request,'admin/verified driver.html',{"data":res})

def Viewuser(request):
    res=user.objects.all()
    request.session['head']="USER"
    if request.session['log']!="lg":
        return HttpResponse("<script>alert('logout successfully');window.location='/'</script>")

    return render(request,'admin/view_user.html',{"data":res})

def Viewratingandreview(request):
    res=rating_review.objects.all()
    request.session['head']="RATING & REVIEW"

    if request.session['log']!="lg":
        return HttpResponse("<script>alert('logout successfully');window.location='/'</script>")
    return render(request,'admin/view_rating&review.html',{"data": res})

def Viewandblockunblock(request):
    res=report.objects.all()
    ar=[]
    for i in res:
        if i.DRIVER_id not in ar:
            ar.append(i.DRIVER_id)
        else:
            pass
    re=[]
    for j in ar:
        ress=report.objects.filter(DRIVER=j)
        if ress.exists():
            re.append({
                "id":ress[0].DRIVER.LOGIN_id,
                "type":ress[0].DRIVER.LOGIN.usertype,
                "name":ress[0].DRIVER.name,
                "email":ress[0].DRIVER.email,
                "reason":ress[0].reason,
                "count":ress.count()
            })

            request.session['head'] = "REPORTS"
            if request.session['log'] != "lg":
                return HttpResponse("<script>alert('logout successfully');window.location='/'</script>")

    return render(request, 'admin/report_driver.html',{"data":re})


def block_driver(request,id):
    login.objects.filter(id=id).update(usertype="block")
    return HttpResponse("<script>alert('blocked');window.location='/Homepage'</script>")

def unblock_driver(request,id):
    login.objects.filter(id=id).update(usertype="driver")
    return HttpResponse("<script>alert('unblocked');window.location='/Homepage'</script>")

def Feedback(request):
    request.session['head']="FEEDBACK"
    res=feedback.objects.all()
    ar=[]
    for i in res:
        if i.LOGIN.usertype=="driver":
            dr=driver.objects.filter(LOGIN=i.LOGIN_id)
            if dr.exists():
                ar.append({
                    "id":i.id,
                    "date":i.date,
                    "feedback":i.feedback,
                    "type":i.LOGIN.usertype,
                    "name":dr[0].name,
                    "email":dr[0].email,
                })
        else:
            dr = user.objects.filter(LOGIN=i.LOGIN_id)
            if dr.exists():
                ar.append({
                    "id": i.id,
                    "date": i.date,
                    "feedback": i.feedback,
                    "type": i.LOGIN.usertype,
                    "name": dr[0].name,
                    "email": dr[0].email,
                })

    if request.session['log']!="lg":
        return HttpResponse("<script>alert('logout successfully');window.location='/'</script>")
    return render(request,'admin/view_feedback.html',{"data":ar})

def Changepass(request):
    request.session['head']="CHANGE PASSWORD"
    if request.session['log']!="lg":
        return HttpResponse("<script>alert('logout successfully');window.location='/'</script>")
    return render(request,'admin/change_password.html')

def Changepass_post(request):
    currentpass = request.POST['textfield']
    newpass = request.POST['textfield2']
    confirmpass = request.POST['textfield3']
    res=login.objects.filter(password=currentpass,id=request.session['lid'])
    if res.exists():
        if newpass == confirmpass:
            login.objects.filter(id=request.session['lid']).update(password=newpass)
            return HttpResponse("<script>alert('changed');window.location='/'</script>")
        return HttpResponse("<script>alert('mismatch');window.location='/Changepass'</script>")
    return HttpResponse("<script>alert('not found');window.location='/Changepass'</script>")

def Homepage(request):
    request.session['head']=""
    return render(request,'admin/index.html')

def index_home(request):
    return render(request,'admin/index.html')

def pass_change(request):
    request.session['head']="CHANGE PASSWORD"
    if request.session['log']!="lg":
        return HttpResponse("<script>alert('logout successfully');window.location='/'</script>")
    return render(request,'admin/change_pass.html')

def logout(request):
    request.session['log']=""
    return HttpResponse("<script>alert('LogOut Successfully');window.location='/'</script>")




##################################################################


def and_login(request):
    uname=request.POST['username']
    password=request.POST['password']
    res = login.objects.filter(username=uname, password=password)
    if res.exists():
        res = res[0]
        if res.usertype=="driver":
            lid = res.id
            type = res.usertype
            sts=driver.objects.get(LOGIN=lid).available_status
            return JsonResponse({"res":"true","lid":lid,"type":type,"sts":sts})
        else:
            lid = res.id
            type = res.usertype
            return JsonResponse({"res": "true", "lid": lid, "type": type})

    else:
        return JsonResponse({"status":"Data Not Found"})

def and_regiter(request):
    Name = request.POST['name']
    phone = request.POST['phone']
    Email = request.POST['email']
    place = request.POST['place']
    pin = request.POST['pin']
    post = request.POST['post']
    password = request.POST['password']
    Confirm_pass = request.POST['confirm_pass']

    uploaded_file = request.FILES.get('file')      # License file
    uploaded_image = request.FILES.get('file1')    # Profile photo

    if password != Confirm_pass:
        return JsonResponse({"status": "not ok"})

    if not uploaded_file:
        return JsonResponse({
            "status": "not ok",
            "message": "License file is required"
        })

    if not uploaded_image:
        return JsonResponse({
            "status": "not ok",
            "message": "Profile photo is required"
        })

    # Create login
    obj = login()
    obj.username = Email
    obj.password = password
    obj.usertype = 'pending'
    obj.save()

    # Create driver
    obj1 = driver()
    obj1.LOGIN = obj
    obj1.name = Name
    obj1.phone = phone
    obj1.email = Email
    obj1.pin = pin
    obj1.post = post
    obj1.place = place

    # Save uploaded files
    fs = FileSystemStorage(location='media/uploads/')

    image_filename = fs.save(uploaded_image.name, uploaded_image)
    proof_filename = fs.save(uploaded_file.name, uploaded_file)

    obj1.photo = 'media/uploads/' + image_filename
    obj1.proof = 'media/uploads/' + proof_filename

    obj1.save()

    return JsonResponse({
        "status": "ok"
    })


def view_profileandupdate(request):
    lid=request.POST['lid']
    res=driver.objects.get(LOGIN=lid)
    photo_url = ""
    proof_url = ""

    if res.photo:
        photo_url = request.build_absolute_uri(
            settings.MEDIA_URL + "uploads/" + os.path.basename(str(res.photo))
        )

    if res.proof:
        proof_url = request.build_absolute_uri(
            settings.MEDIA_URL + "uploads/" + os.path.basename(str(res.proof))
        )
    return JsonResponse({"status": "ok","Name":res.name,"Phone":res.phone,"Email":res.email,"Place":res.place,"Pin":res.pin,"Post":res.post,"Proof":proof_url,"Photo":photo_url, })

def and_edit_profile(request):
    lid = request.POST['lid']

    Name = request.POST['name']
    Phone = request.POST['phone']
    Email = request.POST['email']
    Place = request.POST['place']
    Pin = request.POST['pin']
    Post = request.POST['post']

    obj = driver.objects.get(LOGIN=lid)

    obj.name = Name
    obj.phone = Phone
    obj.email = Email
    obj.pin = Pin
    obj.post = Post
    obj.place = Place

    # New license file
    if 'proof' in request.FILES:
        uploaded_file = request.FILES['proof']

        fs = FileSystemStorage(location='media/uploads/')
        proof_filename = fs.save(uploaded_file.name, uploaded_file)

        obj.proof = 'media/uploads/' + proof_filename

    # New profile photo
    if 'photo' in request.FILES:
        uploaded_image = request.FILES['photo']

        fs = FileSystemStorage(location='media/uploads/')
        image_filename = fs.save(uploaded_image.name, uploaded_image)

        obj.photo = 'media/uploads/' + image_filename

    obj.save()

    return JsonResponse({
        "status": "ok",
        "message": "Profile updated successfully"
    })

def and_view_fare(request):
    res=fare.objects.all()
    ar=[]
    for i in res:
        ar.append({
            "id":i.id,
            "fare":i.fare
        })
    return JsonResponse({"status":"ok","data":ar})

def and_view_request(requestt):
    lid=requestt.POST['lid']
    ar=[]
    res=request.objects.filter(DRIVER__LOGIN=lid,status="pending")
    for i in res:
        ar.append({
            "id":i.id,
            "username":i.USER.name,
            "email" : i.USER.email,
            "Date" : i.date_and_time,
            "From" : i.from_location,
            "To" : i.to_location,
            "Amount" :i.amount,

        })
    return JsonResponse({"status":"ok","message":ar})

def and_reject_request(requestt):
    rid=requestt.POST['rid']
    lid = requestt.POST['lid']
    em = login.objects.get(id=lid).username
    request.objects.filter(id=rid).update(status="rejected")
    import smtplib
    s = smtplib.SMTP(host='smtp.gmail.com', port=587)
    s.starttls()
    s.login("arbooking666@gmail.com", "tvwa oezn pwqt frbr")
    msg = MIMEMultipart()  # create a message.........."
    msg['From'] = "arbooking666@gmail.com"
    msg['To'] = em
    msg['Subject'] = "Your Request Status"
    body = "Your Request is Rejected"
    msg.attach(MIMEText(body, 'plain'))
    s.send_message(msg)
    return JsonResponse({"status":"ok"})

def upddateamount(requestt):
    Amount = requestt.POST['amount']
    rid=requestt.POST['rid']
    lid=requestt.POST['lid']
    em=login.objects.get(id=lid).username
    request.objects.filter(id=rid).update(status="approved",amount=Amount)
    import smtplib
    s = smtplib.SMTP(host='smtp.gmail.com', port=587)
    s.starttls()
    s.login("arbooking666@gmail.com", "tvwa oezn pwqt frbr")
    msg = MIMEMultipart()  # create a message.........."
    msg['From'] = "arbooking666@gmail.com"
    msg['To'] = em
    msg['Subject'] = "Your Request Status"
    body = "Your Request is Accepted"
    msg.attach(MIMEText(body, 'plain'))
    s.send_message(msg)

    return JsonResponse({ "status" : "ok"})

def and_view_verifiedrequest(requestt):
    lid=requestt.POST['lid']
    ar=[]
    print(lid,"hgdfg")
    res=request.objects.filter(DRIVER__LOGIN=lid,status="approved")
    for i in res:
        ar.append({
            "id":i.USER.id,
            "username":i.USER.name,
            "email" : i.USER.email,
            "Date" : i.date_and_time,
            "From" : i.from_location,
            "To" : i.to_location,
            "Amount" :i.amount

        })
    print(res,"resss")
    return JsonResponse({"status":"ok.","message":ar})

def and_view_requesthistory(requestt):
    lid=requestt.POST['lid']
    ar=[]
    res=request.objects.filter(DRIVER__LOGIN=lid,date_and_time__lt=datetime.datetime.now().strftime("%Y-%m-%d"))
    for i in res:
        ar.append({
            "id": i.id,
            "username": i.USER.name,
            "email": i.USER.email,
            "Date": i.date_and_time,
            "From": i.from_location,
            "To": i.to_location,
            "Amount" :i.amount,
            "Status" :i.status

        })
    return JsonResponse({"status":"ok","message":ar})

def and_view_paymenthistory(request):
    lid=request.POST['lid']
    ar=[]
    res=payment.objects.filter(REQUEST__DRIVER__LOGIN=lid)
    for i in res:
        ar.append({
            "id" :i.id,
            "username": i.USER.name,
            "Date" : i.date_and_time,
            "Payment_Type" : i.payment_type,
            "Payment_Status" : i.payment_status
                    })
    return JsonResponse({"status":"ok","message":ar})

def and_view_reviewandrating(request):
    lid = request.POST['lid']
    ar=[]
    res=rating_review.objects.filter(DRIVER__LOGIN=lid)
    for i in res:
        ar.append({
            "id" : i.id,
            "username" : i.USER.name,
            "Date" : i.date,
            "Rating" :i.rating,
            "Review" : i.review
        })
    return JsonResponse({"status":"ok","message":ar})

def and_sendfeedback(request):
    fd=request.POST['Feedback']
    lid=request.POST['lid']
    obj=feedback()
    obj.date=datetime.datetime.now().strftime("%Y-%m-%d")
    obj.feedback=fd

    obj.LOGIN_id=lid
    obj.save()
    return JsonResponse({"res":"true"})

def and_changepass(request):
    lid = request.POST['lid']
    cp = request.POST['current']
    np = request.POST['new_pass']
    con_p = request.POST['confirm']
    res=login.objects.filter(password=cp,id=lid)
    if res.exists():
        if np == con_p:
            login.objects.filter(id=lid).update(password=np)
            return JsonResponse({"res": "true"})
        return JsonResponse({"res": "false"})
    return JsonResponse({"res":"not"})


def availability_management(request):
    lid=request.POST['lid']
    driver.objects.filter(LOGIN=lid).update(available_status="available")
    return JsonResponse({"status":"ok"})

def set_as_available(request):
    lid=request.POST['lid']
    driver.objects.filter(LOGIN=lid).update(available_status="available")
    return JsonResponse({"status" : "ok"})


def set_as_not_available(request):
    lid=request.POST['lid']
    driver.objects.filter(LOGIN=lid).update(available_status="not available")
    return JsonResponse({"status" : "ok"})



##############################################################################################




def user_register(request):
    Name = request.POST['name']
    phone = request.POST['phone']
    Email = request.POST['email']
    place = request.POST['place']
    pin = request.POST['pin']
    post = request.POST['post']
    Password = request.POST['password']
    Confirm_pass = request.POST['confirm_pass']

    if Password == Confirm_pass:
        obj=login()
        obj.usertype="user"
        obj.password=Password
        obj.username=Email
        obj.save()

        ob=user()
        ob.LOGIN=obj
        ob.name=Name
        ob.phone=phone
        ob.email=Email
        ob.pin=pin
        ob.post=post
        ob.place=place
        ob.save()
        return JsonResponse({"status" : "ok"})
    else:
        return JsonResponse({"status" : "no"})


def user_viewprofileandupdate(request):
    lid=request.POST['lid']
    res=user.objects.get(LOGIN=lid)
    return JsonResponse({"status": "ok","Name":res.name,"Phone":res.phone,"Email":res.email,"Place":res.place,"Pin":res.pin,"Post":res.post})

def user_viewavailabledrivers(request):
    res=driver.objects.filter(available_status="available")
    ar=[]
    for i in res:
        ar.append({
            "id" : i.id,
            "Name" : i.name,
            "Phone" : i.phone,
            "Email" : i.email,
            "Place" : i.place,
            "Pin" : i.pin,
            "Post" : i.post,
            "Proof" : i.proof,
            "Photo" : i.photo

        })
    print(ar,"ddddddddd")
    return JsonResponse ({"status" :"ok","message":ar})



def user_viewratingandreview(request):
    did = request.POST['did']
    ar=[]
    res=rating_review.objects.filter(DRIVER=did)
    for i in res:
        ar.append({
            "id" : i.id,
            "drivername" : i.DRIVER.name,
             "Date" : i.date,
            "Rating" : i.rating,
            "Review" : i.review
        })
    print(res)
    return JsonResponse({"status":"ok","message":ar})


# def user_bookdrivers(request):


def user_viewrequeststatus(requestt):
    lid=requestt.POST['lid']
    ar=[]
    res=request.objects.filter(USER__LOGIN=lid)
    for i in res:
        ar.append({
            "id" : i.id,
            "drivername" : i.DRIVER.name,
            "email" : i.DRIVER.email,
            "Date": i.date_and_time,
            "From": i.from_location,
            "To": i.to_location,
            "amount" :i.amount,
            "Status" :i.status,
            "did": i.DRIVER_id,

        })
    return JsonResponse({"status" : "ok","message":ar})


# def user_makepayment(request):


def user_viewrequesthistory(requestt):
    lid = requestt.POST['lid']
    ar = []
    res = request.objects.filter(USER__LOGIN=lid, date_and_time__lt=datetime.datetime.now().strftime("%Y-%m-%d"))
    for i in res:
        ar.append({
            "id": i.id,
            "drivername": i.DRIVER.name,
            "email": i.DRIVER.email,
            "Date": i.date_and_time,
            "From": i.from_location,
            "To": i.to_location,
            "amount": i.amount,
            "status" : i.status,
            "did":i.DRIVER_id

        })
    return JsonResponse({"status" : "ok","message":ar})



def reportdriver(request):
    rea= request.POST['Reason']
    did = request.POST['did']
    lid = request.POST['lid']
    print(rea,lid,did)
    obj = report()
    obj.date = datetime.datetime.now().strftime("%Y-%m-%d")
    obj.reason = rea
    obj.DRIVER_id = did
    obj.USER=user.objects.get(LOGIN=lid)
    obj.save()
    return JsonResponse({"status" : "ok"})



def send_ratingandreview(request):
    rat = request.POST['rating']
    rev = request.POST['review']
    did = request.POST['did']
    lid = request.POST['lid']
    print(did,lid)
    obj = rating_review()
    obj.date = datetime.datetime.now().strftime("%Y-%m-%d")
    obj.rating = rat
    obj.review = rev
    obj.USER=user.objects.get(LOGIN=lid)
    obj.DRIVER_id = did
    obj.save()
    return JsonResponse({"status" : "ok"})




def user_send_feedback(request):
    fd = request.POST['feed']
    lid = request.POST['lid']
    obj = feedback()
    obj.date = datetime.datetime.now().strftime("%Y-%m-%d")
    obj.feedback = fd
    obj.LOGIN_id = lid
    obj.save()
    return JsonResponse({"res": "true"})

def user_changepass(request):
    lid = request.POST['lid']
    cp = request.POST['current']
    np = request.POST['new_pass']
    con_p = request.POST['confirm']
    res = login.objects.filter(password=cp, id=lid)
    if res.exists():
        if np == con_p:
            login.objects.filter(id=lid).update(password=np)
            return JsonResponse({"res": "true"})
        return JsonResponse({"res": "false"})
    return JsonResponse({"res": "not"})

def book_driver(requestt):
    From = requestt.POST['from']
    To = requestt.POST['to']
    did=requestt.POST['did']
    lid=requestt.POST['lid']
    obj=request()
    obj.amount="pending"
    obj.status="pending"
    obj.USER=user.objects.get(LOGIN=lid)
    obj.DRIVER_id=did
    obj.from_location=From
    obj.to_location=To
    obj.date_and_time=datetime.datetime.now().strftime("%Y-%m-%d")
    obj.save()
    return JsonResponse({"status" : "ok"})


# def and_regiter(request):
#     Name = request.POST['name']
#     phone = request.POST['phone']
#     Email = request.POST['email']
#     place = request.POST['place']
#     pin = request.POST['pin']
#     post = request.POST['post']
#     password = request.POST['password']
#     Confirm_pass = request.POST['confirm_pass']
#
#     uploaded_file = request.FILES.get('file')
#     print(uploaded_file,"pppppppppppppppppp")
#     if uploaded_file:
#         try:
#             # Save the file in the MEDIA_ROOT directory
#             with open(f'media/uploads/{uploaded_file.name}', 'wb') as f:
#                 for chunk in uploaded_file.chunks():
#                     f.write(chunk)
#         except Exception as e:
#             pass
#
#     uploaded_image = request.FILES.get('file1')
#     print(uploaded_image, "pppppppppppppppppp")
#     if uploaded_image:
#         try:
#             # Save the file in the MEDIA_ROOT directory
#             with open(f'media/uploads/{uploaded_image.name}', 'wb') as f:
#                 for chunk in uploaded_file.chunks():
#                     f.write(chunk)
#         except Exception as e:
#             pass
#     if password == Confirm_pass:
#         obj = login()
#         obj.username = Email
#         obj.password = Confirm_pass
#         obj.usertype = 'pending'
#         obj.save()
#
#         obj1 = driver()
#         obj1.LOGIN = obj
#         obj1.name = Name
#         obj1.phone = phone
#         obj1.email = Email
#         obj1.pin = pin
#         obj1.post = post
#         obj1.place = place
#         obj1.photo = f'media/uploads/{uploaded_image.name}'
#         obj1.proof = f'media/uploads/{uploaded_file.name}' if uploaded_file else 'not_uploaded'
#         obj1.save()
#
#         return JsonResponse({"status": "ok"})
#     else:
#         return JsonResponse({"status": "not ok"})
#


def driver_sendchat(request):
    lid=request.POST['from_id']
    FROM_id=driver.objects.get(LOGIN=lid)
    TOID_id=request.POST['to_id']
    msg=request.POST['message']
    print(FROM_id,TOID_id,msg,"toooooo")
    from  datetime import datetime
    c=chat()
    c.DRIVER=FROM_id
    c.USER_id=TOID_id
    c.message=msg
    c.type="driver"
    c.date=datetime.now()
    c.save()
    return JsonResponse({'status':"ok"})

def driver_viewchat(request):
    from_id=request.POST['from_id']
    to_id=request.POST['to_id']
    print(from_id,to_id)
    l=[]
    data=chat.objects.filter(DRIVER__LOGIN=from_id,USER=to_id).order_by('id')
    for res in data:
        l.append({'id':res.id,'from':res.DRIVER.id,'to':res.USER.id,'msg':res.message,'date':res.date,"type":res.type})
    return JsonResponse({'status':"ok",'data':l})



def user_sendchat(request):
    lid=request.POST['from_id']
    TOID_id=request.POST['to_id']
    FROM_id=user.objects.get(LOGIN=lid)
    msg=request.POST['message']
    from  datetime import datetime
    c=chat()
    c.USER=FROM_id
    c.DRIVER_id=TOID_id
    c.message=msg
    c.type="user"
    c.date=datetime.now()
    c.save()
    return JsonResponse({'status':"ok"})

def user_viewchat(request):
    from_id=request.POST['from_id']
    to_id=request.POST['to_id']
    l=[]
    data=chat.objects.filter(USER__LOGIN=from_id,DRIVER=to_id).order_by('id')
    for res in data:
        l.append({'id':res.id,'from':res.USER.LOGIN_id,'to':res.DRIVER.id,'msg':res.message,'date':res.date,"type":res.type})
    return JsonResponse({'status':"ok",'data':l})



#############################################################################################################################

from django.conf import settings
import os


def view_profile(request):
    lid = request.POST['lid']

    res = driver.objects.get(LOGIN=lid)

    photo_url = ""
    proof_url = ""

    if res.photo:
        photo_url = request.build_absolute_uri(
            settings.MEDIA_URL + "uploads/" + os.path.basename(str(res.photo))
        )

    if res.proof:
        proof_url = request.build_absolute_uri(
            settings.MEDIA_URL + "uploads/" + os.path.basename(str(res.proof))
        )

    return JsonResponse({
        "status": "ok",
        "name": res.name,
        "email": res.email,
        "phone": res.phone,
        "place": res.place,
        "post": res.post,
        "pin": res.pin,
        "image": photo_url,
        "proof": proof_url,
    })
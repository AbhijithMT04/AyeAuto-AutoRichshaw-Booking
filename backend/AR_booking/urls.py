"""AR_booking URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from django.conf.urls.static import static
from django.conf import settings

from AR_booking_app import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('',views.Login),
    path('login_post',views.login_post),
    path('Addfare_post',views.Addfare_post),
    path('Addfare',views.Addfare),
    path('Viewfare',views.Viewfare),
    path('delete_fare/<id>',views.delete_fare),
    path('Viewdriverandverify',views.Viewdriverandverify),
    path('view_verified_drivers',views.view_verified_drivers),
    path('approve_driver/<id>',views.approve_driver),
    path('reject_driver/<id>',views.reject_driver),
    path('block_driver/<id>',views.block_driver),
    path('unblock_driver/<id>',views.unblock_driver),
    path('Viewuser',views.Viewuser),
    path('Viewratingandreview',views.Viewratingandreview),
    path('Viewandblockunblock',views.Viewandblockunblock),
    path('Feedback',views.Feedback),
    path ('Changepass',views.Changepass),
    path('Changepass_post',views.Changepass_post),
    path('Homepage',views.Homepage),
    path('index_home',views.index_home),
    path('pass_change',views.pass_change),
    path('logout',views.logout),


    ##########################################

    #
    # path('Register',views.Register),
    # path('View_profileandupdate',views.View_profileandupdate),
    # path('ViewFare',views.ViewFare),
    # path('Viewrequestandverify',views.Viewrequestandverify),
    # path('Viewverifiedrequest',views.Viewverifiedrequest),
    # path('Viewrequesthistory',views.Viewrequesthistory),
    # path('Viewpaymenthistory',views.Viewpaymenthistory),
    # path('View_reviewandrating',views.View_reviewandrating),
    # path('Chatwithuser',views.Chatwithuser),
    # path('SendFeedback',views.SendFeedback),
    # path('ChangePass',views.ChangePass),
    # path('Registerpost',views.Registerpost),
    # path('Home_Page',views.Home_Page),



    ###################################


    path('and_login',views.and_login),
    path('and_regiter',views.and_regiter),
    path('and_driver_regiter',views.and_regiter),
    path('and_edit_profile',views.and_edit_profile),
    path('view_profileandupdate',views.view_profileandupdate),
    path('and_view_fare',views.and_view_fare),
    path('and_view_request',views.and_view_request),
    path('and_reject_request',views.and_reject_request),
    path('and_view_verifiedrequest',views.and_view_verifiedrequest),
    path('and_view_requesthistory',views.and_view_requesthistory),
    path('and_view_paymenthistory',views.and_view_paymenthistory),
    path('and_view_reviewandrating',views.and_view_reviewandrating),
    path('and_sendfeedback',views.and_sendfeedback),
    path('and_changepass',views.and_changepass),
    path('availability_management',views.availability_management),
    path('set_as_available',views.set_as_available),
    path('set_as_not_available',views.set_as_not_available),
    path('upddateamount', views.upddateamount),
    path('view_profile',views.view_profile),




    #################################################################

    path('user_register',views.user_register),
    path('user_viewprofileandupdate',views.user_viewprofileandupdate),
    path('user_viewavailabledrivers',views.user_viewavailabledrivers),
    path('user_viewratingandreview',views.user_viewratingandreview),
    # path('user_bookdrivers',views.user_bookdrivers),
    path('user_viewrequeststatus',views.user_viewrequeststatus),
    # path('user_makepayment',views.user_makepayment),
    path('user_viewrequesthistory',views.user_viewrequesthistory),
    path('reportdriver',views.reportdriver),
    path('send_ratingandreview',views.send_ratingandreview),
    path('user_send_feedback',views.user_send_feedback),
    path('user_changepass',views.user_changepass),
    path('book_driver',views.book_driver),
    path('user_sendchat',views.user_sendchat),
    path('user_viewchat',views.user_viewchat),
    path('driver_sendchat',views.driver_sendchat),
    path('driver_viewchat',views.driver_viewchat),

    # path('view_profile_flutter',views.view_profile_flutter),

]+ static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

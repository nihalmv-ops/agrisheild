"""forest URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.0/topics/http/urls/
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
from django.urls import path, include
from myapp import views

urlpatterns = [
    path("adminhome_get/",views.adminhome_get),
    path("loginpage_get/",views.loginpage_get),
    path("loginpage_post/",views.loginpage_post),
    path("logout_post/",views.logout_post),



    path("viewalert_get/",views.viewalert_get),

    path("addforestdivision_get/",views.addforestdivision_get),
    path("addforestdivision_post/",views.addforestdivision_post),
    path("viewforestdivision_get/",views.viewforestdivision_get),
    path("editforestdivision_get/",views.editforestdivision_get),
    path("editforestdivision_post/",views.editforestdivision_post),
    path("addforestofficer_post/",views.addforestofficer_post),
    path("addforestofficer_get/",views.addforestofficer_get),
    path("addforeststation_get/",views.addforeststation_get),
    path("addforeststation_post/",views.addforeststation_post),

    path("viewforestofficer_get/",views.viewforestofficer_get),
    path("viewforeststation_get/",views.viewforeststation_get),

    path("editforestdivision_post/", views.editforestdivision_post),
    path("editforestdivision_get/<id>", views.editforestdivision_get),
    path("editforeststation_get/<id>", views.editforeststation_get),


    path("changepassword_post/", views.changepassword_post),
    path("changepassword_get/", views.changepassword_get),

    path("sendreplay_post/", views.sendreplay_post),
    path("sendreplay_get/<id>", views.sendreplay_get),


    path("viewcomplaint_get/", views.viewcomplaint_get),
    path("deleteforestdivision_get/<id>", views.deleteforestdivision_get),
    path("deleteforeststation_get/<id>", views.deleteforeststation_get),
    path("editforstofficer_post/", views.editforstofficer_post),
    path("editforestofficer_get/<id>", views.editforestofficer_get),
    path("deleteforestofficer_get/<id>", views.deleteforestofficer_get),

    #----------- offficer --------
    path("officer_home_get/", views.officer_home_get),

    path("officer_viewprofile/", views.officer_viewprofile),

    path("officer_viewcomplaint/", views.officer_viewcomplaint),
    path("officer_sendreplay_get/<id>", views.officer_sendreplay_get),
    path("officer_sendreplay_post/", views.officer_sendreplay_post),

    path("officer_sendalert_get/", views.officer_sendalert_get),
    path("officer_sendalert_post/", views.officer_sendalert_post),


    path("officer_viewalert_get/", views.officer_viewalert_get),

    path("officer_deletealert/<id>", views.officer_deletealert),

    path("officer_changepassword_get/", views.officer_changepassword_get),
    path("officer_changepassword_post/", views.officer_changepassword_post),


    path("userloginpage_post/", views.userloginpage_post),


    path("user_viewprofile_post/", views.user_viewprofile_post),


    path("edit_userprofile_POST/", views.edit_userprofile_POST),

    path("changepassword_post/", views.changepassword_post),


    path("user_add_product/", views.user_add_product),

    path("view_product/", views.view_product),
    path("edit_product/", views.edit_product),

    path("edit_product_post/", views.edit_product_post),

    path("delete_product_post/", views.delete_product_post),


    path("view_alert/", views.view_alert),
    path("userview_complaint/", views.userview_complaint),
    path("usersend_complaint/", views.usersend_complaint),


    path("userview_forestdivision/", views.userview_forestdivision),


    path("Detect_Alert/", views.Detect_Alert),
    path("notifi/", views.notifi),



    path("user_delete_cart/", views.user_delete_cart),
    path("user_place_order/", views.user_place_order),
    path("user_vieworder/", views.user_vieworder),
    path("user_vieworderitem/", views.user_vieworderitem),
    path("user_addquantity/", views.user_addquantity),
    path("user_viewfarmer/", views.user_viewfarmer),
    path("user_viewcart/", views.user_viewcart),
    path("user_clear_cart/", views.user_clear_cart),
    path("user_viewproducts/", views.user_viewproducts),





    path("user_signup/", views.user_signup),

    path("viweanimaldtect/", views.viweanimaldtect),


]

require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  
  def setup
  @chef = Chef.create!(chefname: "nori", email:"nori@gmail.com",
                         password: "password", password_confirmation: "password")
  @chef2 = Chef.create!(chefname: "john", email:"john@gmail.com",
                         password: "password", password_confirmation: "password")
  @admin_user = Chef.create!(chefname: "john1", email:"john1@gmail.com",
                         password: "password", password_confirmation: "password", admin: true)
  
  end
  
  test "reject an invalid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: {chef: {chefname:" ", email:"nori@email.com "}}
    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  test "accept valid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: {chef: {chefname:"Noria", email:"noria@email.com"}}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "Noria", @chef.chefname
    assert_match "noria@email.com", @chef.email
  end
  
  test "accept edit attempt by admin user" do
    sign_in_as(@admin_user, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: {chef: {chefname:"Noria", email:"noria@email.com"}}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "Noria", @chef.chefname
    assert_match "noria@email.com", @chef.email
  end
  
  test "reject edit attempt by non-admin user" do
    sign_in_as(@chef2, "password")
    updated_name = "joe"
    updated_email ="joe@email.com"
    patch chef_path(@chef), params: {chef: {chefname:updated_name, email:updated_email}}
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match "nori", @chef.chefname
    assert_match "nori@gmail.com", @chef.email
  end
  
  
end

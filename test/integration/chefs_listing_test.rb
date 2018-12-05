require 'test_helper'

class ChefsListingTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: "nori", email:"nori@gmail.com",
                         password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "john", email: "john@example.com",
                         password: "password", password_confirmation: "password")
    @recipe = Recipe.create(name: "Vegetable soup", description: "vege and soup so yammy yes", chef:@chef)
    @recipe2 =@chef.recipes.build(name: "Chicken soute",description:"little spicy but availbel for kids as well")
    @recipe2.save
  end
  
  test "should get chefs listing" do
    get chefs_path
    assert_response :success
    assert_select "a[href=?]", chef_path(@chef), text:@chef.chefname.capitalize
    assert_select "a[href=?]", chef_path(@chef2), text:@chef2.chefname.capitalize
    
  end
  
end

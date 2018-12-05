require 'test_helper'

class ChefsShowTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: "nori", email:"nori@gmail.com",
                         password: "password", password_confirmation: "password")
    @recipe = Recipe.create(name: "Vegetable soup", description: "vege and soup so yammy yes", chef:@chef)
    @recipe2 =@chef.recipes.build(name: "Chicken soute",description:"little spicy but availbel for kids as well")
    @recipe2.save
  end
  
  test "should get chefs show" do
    get chef_path(@chef)
    assert_template 'chefs/show'
    assert_select "a[href=?]", recipe_path(@recipe), text:@recipe.name
    assert_select "a[href=?]", recipe_path(@recipe2), text:@recipe2.name
    assert_match @recipe.description, response.body
    assert_match @recipe2.description,response.body
    assert_match @chef.chefname, response.body
  end
  
end

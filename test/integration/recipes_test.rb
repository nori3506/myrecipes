require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: "nori", email:"nori@gmail.com")
    @recipe = Recipe.create(name: "vegetable soup", description: "vege and soup so yammy yes", chef:@chef)
    @recipe2 =@chef.recipes.build(name: "chicken soute",description:"little spicy but availbel for kids as well")
    @recipe2.save
  end
  
  test "should et recipes index" do
    get recipes_url
    assert_response :success
  end

  test "should get recipes listing" do
    get recipes_path
    assert_template 'recipes/index'
    assert_match @recipe.name, response.body
    assert_match @recipe2.name, response.body
  end


end

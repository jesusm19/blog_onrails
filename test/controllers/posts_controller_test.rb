# encoding: UTF-8
require 'simplecov'
SimpleCov.start
require 'test_helper'

# Clase de pruebas de unidad: Post
class PostsControllerTest < ActionController::TestCase
  def setup
    @post = posts(:one)
  end

  # Pruebas de creacion de posts:
  test 'debe crear un post' do
    get :new
    assert_response :success
  end

  test 'no guardar un post si no tiene titulo' do
    post = Post.new
    assert !post.save
  end

  test 'debe crear un post y redireccionar a la lista' do
    assert_difference('Post.count') do
      post :create, post: { titulo: 'El que sea',
                            texto: 'otra vez el que sea' }
    end
    assert_redirected_to post_path(assigns(:post))
  end

  # Pruebas para mostrar un post
  test 'debe mostrar un post' do
    get :show, id: @post.id
    assert_response :success
  end

  # Pruebas de obtencion de la pagina principal
  test 'obtener el index' do
    get :index
    assert_response :success
  end

  # Pruebas para mostrar un post en edicion
  test 'debe enviar un post a edicion' do
    get :edit, id: @post.id
    assert_response :success
  end

  test "debe actualizar un post" do
    post = posts(:one)
    put :update, :id => post, :post => {:titulo => "Sobres"}
    assert_equal "Sobres", post.reload.titulo
  end
  # Pruebas para eliminar un post
  test 'debe destruir un post' do
    assert_difference('Post.count', -1) do
      delete :destroy, id: @post.id
    end
    assert_redirected_to posts_path
  end
end

# encoding: UTF-8
# Clase de modelo: Post
class Post < ActiveRecord::Base
  # attr_accessible :texto, :titulo
  validates :titulo, :presence => true,
                     :length => { :minimum => 5 }
  
  has_many :comments, :dependent => :destroy
  private

  def post_params
    params.require(:post).permit(:titulo, :texto)
  end
end

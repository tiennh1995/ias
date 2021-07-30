class Supports::Like < Supports::Application
  attr_reader :post_display_id
  attr_reader :user_display_id
  attr_reader :liked

  def initialize attributes
    @post_display_id = attributes[:post_display_id]
    @user_display_id = attributes[:user_display_id]
    @liked           = attributes[:liked] || false
  end

  class << self
    def create_like like_params
      user = User.find_by(display_id: like_params[:user_display_id]) || User.new
      post = Post.find_by(display_id: like_params[:post_display_id]) || Post.new
      like = Like.find_by(user_id: user.id, post_id: post.id)
      if like.nil?
        return Like.create(user_id: user.id, post_id: post.id)
      else
        return false
      end
    end

    def delete_like like_params
      user = User.find_by(display_id: like_params[:user_display_id]) || User.new
      post = Post.find_by(display_id: like_params[:post_display_id]) || Post.new
      like = Like.find_by(user_id: user.id, post_id: post.id)
      if like.nil?
        return false
      else
        return like.delete
      end
    end

    def convert_likes current_user_id=nil, likes
      sp_likes = []
      likes.each do |like|
        sp_likes.push(self.convert_like(current_user_id, like))
      end
      sp_likes
    end

    def convert_like current_user_id=nil, like
      attributes = {}
      if !(like.nil? or like.new_record?)
        attributes[:user_display_id] = like.user.display_id
        attributes[:post_display_id] = like.post.display_id
        attributes[:liked]           = like.user_id == current_user_id
      end
      self.new(attributes)
    end
  end
end

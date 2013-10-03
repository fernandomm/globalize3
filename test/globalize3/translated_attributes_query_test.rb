# encoding: utf-8
require File.expand_path('../../test_helper', __FILE__)

class TranslatedAttributesQueryTest < MiniTest::Spec
  describe '.where' do
    it 'finds records with matching attribute value in translation table' do
      post = Post.create(:title => 'title 1')
      Post.create(:title => 'title 2')
      assert_equal Post.where(:title => 'title 1').load, [post]
    end

    it 'only returns translations in this locale' do
      Globalize.with_locale(:ja) { Post.create(:title => 'タイトル') }
      assert Post.where(:title => 'タイトル').empty?
    end

    it 'chains relation' do
      post = Post.create(:title => 'a title', :published => true)
      Post.create(:title => 'another title', :published => false)
      assert_equal Post.where(:title => 'a title', :published => true).load, [post]
    end

    it 'returns record with all translations' do
      post = Post.create(:title => 'a title')
      Globalize.with_locale(:ja) { post.update_attributes(:title => 'タイトル') }
      post_by_where = Post.where(:title => 'a title').first
      skip 'is this even possible?'
      assert_equal post.translations, post_by_where.translations
    end

    it 'can be called with no argument' do
      user = User.create(:email => 'foo@example.com', :name => 'foo')
      assert_equal User.where.not(:email => 'foo@example.com').load, []
      assert_equal User.where.not(:email => 'bar@example.com').load, [user]
    end

    it 'can be called with multiple arguments' do
      user = User.create(:email => 'foo@example.com', :name => 'foo')
      assert_equal User.where("email = :email", { :email => 'foo@example.com' }).first, user
    end
  end

  describe '.find_by' do
    it 'finds first record with matching attribute value in translation table' do
      Post.create(:title => 'title 1')
      post = Post.create(:title => 'title 2')
      assert_equal Post.find_by(:title => 'title 2'), post
    end
  end
end

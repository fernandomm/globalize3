# encoding: utf-8
require File.expand_path('../../test_helper', __FILE__)

class TranslatedAttributesQueryTest < MiniTest::Spec
  describe '.where' do
    it 'finds record with matching attribute value in translation table' do
      post = Post.create(:title => 'a title')
      assert_equal Post.where(:title => 'a title').first, post
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
  end
end

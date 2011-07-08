# encoding: UTF-8
require File.dirname(__FILE__) + '/acceptance_helper'
require File.dirname(__FILE__) + '/translations_management'

feature "Translations management with Redis", %q{
  In order to show user app in different translate
  As a app admin
  I want to 
} do

  background do
    REDIS ||= Redis.new(:db => "development")
    Translator.current_store = Translator::RedisStore.new(REDIS)
    I18n.locale = :cs
    I18n.backend = Translator.setup_backend(I18n.backend)
    Translator.current_store.clear_database
    visit translations_path
  end

  it_should_behave_like "translations_management"
end


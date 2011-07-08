require 'spec_helper'

describe Translator do
  before :all do
    REDIS ||= Redis.new(:db => "development")
    Translator.current_store = Translator::RedisStore.new(REDIS)
    I18n.backend = Translator.setup_backend(I18n.backend)
  end
  
  it "should be possible to delete key" do
    Translator.keys_for_strings.del("hello.world")
    Translator.keys_for_strings.should_not include("hello.world")
  end

  it "should list non-framework keys by default" do
    Translator.keys_for_strings.should include("hello.world")
    Translator.keys_for_strings.should_not include("helpers.submit.update")
  end

  it "should list only keys that their values are Strings in Yaml files" do
    Translator.keys_for_strings.should_not include("date.month_names")
  end

  it "should be possible to list framework keys with option" do
    Translator.keys_for_strings(:show => :framework).should_not include("hello.world")
    Translator.keys_for_strings(:show => :framework).should include("helpers.submit.update")
  end

  it "should be possible to list all keys with option" do
    Translator.keys_for_strings(:show => :all).should include("hello.world")
    Translator.keys_for_strings(:show => :all).should include("helpers.submit.update")
  end
  
  it "should be possible to list application keys with option" do
    Translator.keys_for_strings(:show => :application).should_not include("helpers.submit.update")
    Translator.keys_for_strings(:show => :application).should include("hello.world")
  end
end

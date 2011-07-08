# encoding: UTF-8
if Rails.env.development?
#  conn = Mongo::Connection.new.db("translator_test").collection("translations")
#  Translator.current_store = Translator::MongoStore.new(conn)
  Translator.current_store = Translator::RedisStore.new(Redis.new)

  I18n.backend = Translator.setup_backend(I18n::Backend::Simple.new)
end


LANGUAGES = [
  ["English",             'en'],
  ["Čeština",             'cs'],
  ["Slovenština",         'sk'],
  ['Deutsch',             'de'],
  ['Polština',            'pl'],
]

LANGUAGES_STR = {:en => 'English', :cs => 'Čeština', :sk => 'Slovenština', :de => "Deutsch", :pl => 'Polština'}

#Translator.auth_handler = proc {
#  authenticate_or_request_with_http_basic do |user_name, password|
#    user_name == 'some' && password == 'user'
#  end
#}


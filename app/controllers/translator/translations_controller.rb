module Translator
  class TranslationsController < ApplicationController
    before_filter :auth

    def index
      @all_keys = Translator.keys_for_strings(:show => params[:show]).collect {|k| k.sub(/\.[a-z0-9\-_]*$/, "")}.uniq
      @keys = Translator.keys_for_strings(:show => params[:show], :filter => params[:key])
      if params[:search]
        @keys = @keys.select do |k|
          Translator.locales.any? {|locale| I18n.translate("#{k}", :locale => locale).to_s.downcase.include?(params[:search].downcase)}
        end
      end
      @keys = paginate(@keys)
      render :layout => Translator.layout_name
    end

    def create
      Translator.current_store[params[:key]] = params[:value]
      redirect_to translations_path unless request.xhr?
    end
    
    def new
    end

    private

    def auth
      Translator.auth_handler.bind(self).call if Translator.auth_handler.is_a? Proc
    end

    def paginate(collection)
      @page = params[:page].to_i
      @page = 1 if @page == 0
      @total_pages = (collection.count / 50.0).ceil
      collection[(@page-1)*50..@page*50]
    end
  end
end


module Translator
  class TranslationsController < ApplicationController
    before_filter :auth

    def index
      section = params[:key].present? && params[:key] + '.'
      @sections = Translator.keys_for_strings(:show => params[:show])
      .map {|k| k = k.scan(/^[a-z0-9\-_]*\./)[0]; k ? k.gsub('.', '') : false}.select{|k| k}.uniq.sort
      @keys = Translator.keys_for_strings(:show => params[:show], :filter => section)
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
      redirect_to translations_path(:search => params[:value]) unless request.xhr?
    end
    
    def new
      render :layout => Translator.layout_name
    end

    def destroy
      Translator.locales.each do |locale|
        Translator.current_store.del(locale.to_s+"."+params[:key])
      end
      redirect_to translations_path
    end

    private

    def auth
      Translator.auth_handler.bind(self).call if Translator.auth_handler.is_a? Proc
    end

    def paginate(collection)
      @page = params[:page].to_i
      @page = 1 if @page == 0
      @total_pages = (collection.count / 10.0).ceil
      collection[(@page-1)*10..@page*10]
    end
  end
end


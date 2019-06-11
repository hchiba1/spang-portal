module Api
  class LibraryController < ApplicationController
    def index
      render json: Library.all.map(&:to_h)
    end

    def show
      render json: Library.new(params[:id]).to_h(true)
    end

    def search_template
      @query = params[:search]
      @template_groups = Template.search(@query)
      puts @template_groups.map{ |l, t| t.map(&:to_h) }
      render json: @template_groups.map{ |l, t| [l.name, t.map(&:to_h)] }.to_h
    end
  end
end
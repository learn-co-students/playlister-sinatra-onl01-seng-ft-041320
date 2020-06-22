require 'sinatra/base'
require 'rack-flash'

class SongsController < ApplicationController
    enable :sessions
    use Rack::Flash

    get '/songs/new' do
        erb :"songs/new"
    end

    get '/songs/:slug/edit' do
        @song = Song.find_by_slug(params[:slug])

        erb :'songs/edit'
    end

    get '/songs/:slug' do
        @song = Song.find_by_slug(params[:slug])

        erb :'songs/show'
    end
    
    get '/songs' do
        @songs=Song.all
        erb :'songs/index'
    end

    post '/songs' do
        @song = Song.create(params[:song])
        @song.artist = Artist.find_or_create_by(params[:artist])
        @song.genres = Genre.find(params[:genres])
        @song.save

        flash[:message] = "Successfully created song."
        redirect "/songs/#{@song.slug}"
        
    end

    patch '/songs/:slug' do
   
        song=Song.find_by_slug(params[:slug])
        song.update(params[:song])
        song.genres=[]
        params[:genres].each do |genre|
            song.genres << Genre.find(genre)
        end
        
        unless params[:song][:name].empty?
            song.artist = Artist.find_or_create_by(params[:artist])
            song.save
          end

        song.save
        slug = song.slug
        flash[:message] = "Successfully updated song."
        redirect :"/songs/#{slug}"
    end
end
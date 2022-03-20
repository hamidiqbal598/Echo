class EndpointsController < ApplicationController

  #Used for authentication of User. For Authentication pls send token and username in Headers
  before_action :authenticate_user
  before_action :set_endpoint, only: %i[ show edit update destroy ]

  def index
    @endpoints = Endpoint.includes(:response).all
  end

  def show
  end

  def new
    @endpoint = Endpoint.new
  end

  def edit
  end

  def create
    #Creating new Endpoint
    @endpoint = Endpoint.new(endpoint_params)
    if @endpoint.save
      render :show, status: 201, location: @endpoint
    else
      render json: return_error_formatted_json(create_error_message(@endpoint.errors.details)), status: 404
    end
  end

  def update
    #Updating the existing Endpoint
    if @endpoint.update(endpoint_params)
      render :show, status: :ok, location: @endpoint
    else
      render json: return_error_formatted_json(create_error_message(@endpoint.errors.details)), status: 404
    end
  end

  def created_endpoint
    #Main Function related to created endpoint
    # This Function will give the message on the basis of verb and path that already created in the respective endpoint.
    requested_path = "/"+params[:anything_else]
    requested_verb = request.env["REQUEST_METHOD"]
    endpoint = Endpoint.includes(:response).all.get_with_verb(requested_verb).get_with_path(requested_path)
    if endpoint.any?
      body = endpoint.first.response.body[1...-1]
      render json: body
    else
      render json: return_error_formatted_json("Requested page `" + requested_path +"` does not exist"), status: 404
    end
  end

  def destroy
    # To Destroy the existing Endpoint
    # @endpoint.response.destroy!
    @endpoint.destroy
    head :no_content
  end

  private

  def set_endpoint
    #Here we setting the Endpoint on the basis of id receive in the URL param
    # And use try catch concept if we did not find any endpoint on the basis of id
    begin
      @endpoint = Endpoint.find(params[:id])
    rescue
      render json: return_error_formatted_json("Requested Endpoint with ID `" + params[:id] +"` does not exist"), status: 404
    end
  end

  def endpoint_params
    #Normally we use permit function to set the attributes but as per document we are receiving raw body so i just modify it.
    # params.require(:data).permit(:verb, :type, :path, response_attributes: [:requested_code, :requested_body])
    hash = Hash.new{}
    data = JSON.parse(request.raw_post)["data"]
    if data
      hash.merge!(requested_type: data["type"]) unless data["type"].nil?
      hash.merge!(requested_verb: data["attributes"]["verb"].upcase) unless (data["attributes"].nil? or data["attributes"]["verb"].nil?)
      hash.merge!(requested_path: data["attributes"]["path"]) unless data["attributes"].nil?
      hash.merge!(response_attributes: data["attributes"]["response"]) unless (data["attributes"].nil? or data["attributes"]["response"].nil?)
    end
    #After creating the manual hash of object from raw body
    hash
  end

  def authenticate_user
    #Please send tokens and username in Headers to set the user
    @current_user = User.get_user(request.headers['username'],request.headers['tokens'])
    if @current_user.empty?
      # return error message with 403 HTTP status if there's no such user
      return render(json: return_error_formatted_json('Invalid User' ), status: 404)
    end
  end

  def create_error_message(error)
    # Here we have different edge cases for errors
    # For example we receive endpoint without verb or without path or without code
    if error.keys[0].to_s == "requested_verb"
      if error.values[0][0].values[0].to_s == "inclusion"
        message = "Requested Endpoint must contain verb which include in the list of HTTP methods"
      else
        message = "Requested Endpoint must contain verb which take one of the HTTP method name"
      end
    elsif error.keys[0].to_s == "requested_path"
      if error.values[0][0].values[0].to_s == "invalid"
        message = "Requested Endpoint must start with path character '/'"
      else
        message = "Requested Endpoint must contain path having value part of a URL"
      end
    elsif error.keys[0].to_s == "response"
      message = "Requested Endpoint must contain response object having multiple attributes"
    elsif error.keys[0].to_s == "response.code"
      message = "Requested Endpoint must contain an integer status code returned by Endpoint"
    else
      message = "Requested Endpoint must have an error"
    end
    message
  end

  def return_error_formatted_json(data)
    #That's our error response as per document
    { errors: [{code: "not_found", detail: data}] }
  end

end

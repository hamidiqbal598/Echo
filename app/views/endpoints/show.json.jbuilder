json.data do
  json.type @endpoint.requested_type.to_s
  json.id @endpoint.id.to_s
  json.attributes do
    json.verb @endpoint.requested_verb.to_s
    json.path @endpoint.requested_path.to_s
    unless @endpoint.response.nil?
      json.response do
        json.code @endpoint.response.code
        json.headers @endpoint.response.headers
        json.body @endpoint.response.body
      end
    end
  end
end
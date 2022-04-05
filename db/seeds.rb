# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   Here we are creating dummy users
    users = User.create([
                          { username: 'Usman' , authentication_token: '1btoken' },
                          { username: 'Shoaib' , authentication_token: '2btoken' },
                          { username: 'Hamid' , authentication_token: '3btoken' }
                        ])
    endpoints = Endpoint.create([
     {:requested_type=>"endpoints", :requested_verb=>"GET", :requested_path=>"/hello", :response_attributes=>{"code"=>200, "headers"=>{}, "body"=>"\"{ \"message\": \"Get Hello, world\" }\""}},
     {:requested_type=>"endpoints", :requested_verb=>"POST", :requested_path=>"/hello", :response_attributes=>{"code"=>200, "headers"=>{}, "body"=>"\"{ \"message\": \"POST Hello, world\" }\""}}
                            ])

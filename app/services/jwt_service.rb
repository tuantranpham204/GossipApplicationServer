# frozen_string_literal: true
# app/services/jwt_service.rb
require 'jwt'

module JwtService
  # The secret key used to sign the tokens.
  # Use Rails credentials or an ENV variable in production.
  SECRET_KEY = ENV["SYSTEM_JWT_SECRET_KEY"]

  def encode_token(payload, exp = 24.hours.from_now)
    # Add expiration to the payload
    payload[:exp] = exp.to_i

    # Sign the token with the secret key
    JWT.encode(payload, SECRET_KEY)
  end

  def decode_token(token)
    # Decode the token
    # "true" checks the signature matches our SECRET_KEY
    decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })

    # Return the payload (the first element of the array)
    HashWithIndifferentAccess.new(decoded[0])
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end
end

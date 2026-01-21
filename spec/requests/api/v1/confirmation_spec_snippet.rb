
  path '/api/v1/users/confirmation' do
    get('Confirm Account') do
      tags 'Authentication'
      produces 'text/html'
      parameter name: :confirmation_token, in: :query, type: :string, required: true

      response(302, 'redirected') do
        run_test!
      end

      response(422, 'invalid token') do
        run_test!
      end
    end
  end

require 'habitica_cli/api'

RSpec.describe HabiticaCli::Api do
  def response_headers
    { 'content-type' => 'application/json' }
  end

  it 'attaches user name and token to request' do
    stub_request(:get, /.*habitica.com.*/)
    api = HabiticaCli::Api.new('test_user', 'test_key')

    api.get('test')

    expect(WebMock).to have_requested(:get, 'https://habitica.com/api/v2/test')
      .with(headers: { :'X-Api-Key' => 'test_key', :'X-Api-User' => 'test_user' }) # rubocop:disable Metrics/LineLength
  end

  it 'returns json' do
    stub_request(:get, /.*habitica.com.*/).to_return(
      body: JSON.dump(key: 'value'),
      headers: response_headers
    )
    api = HabiticaCli::Api.new('test_user', 'test_key')

    response = api.get('test')
    expect(response.body['key']).to eql('value')
  end
end

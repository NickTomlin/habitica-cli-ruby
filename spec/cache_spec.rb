require 'habitica_cli/cache'

RSpec.describe HabiticaCli::Cache do
  FILE_PATH = File.expand_path('./support/temp', __dir__)

  let(:cache) { HabiticaCli::Cache.new(FILE_PATH) }

  after(:each) do
    File.delete(FILE_PATH)
  end

  describe '#store_tasks' do
    it 'stores items in cache' do
      items = cache.store_tasks(
        [
          { 'id' =>  'long-id-1', text: 'text1' },
          { 'id' =>  'long-id-2', text: 'text2' },
          { 'id' =>  'long-id-3', text: 'text3' }
        ]
      )

      expect(items).to eq(%w(l1 l2 l3))
    end

    it 'enables items to be retrieved by short id' do
      cache.store_tasks(
        [
          { 'id' =>  'long-id-1', text: 'text1' },
          { 'id' =>  'long-id-2', text: 'text2' },
          { 'id' =>  'long-id-3', text: 'text3' }
        ]
      )

      expect(cache.get('l1')).to eq('id' => 'long-id-1', text: 'text1')
    end
  end
end

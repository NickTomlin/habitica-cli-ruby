require 'habitica_cli/cache'

RSpec.describe HabiticaCli::Cache do
  FILE_PATH = File.expand_path('./support/temp', __dir__)

  let(:cache) { HabiticaCli::Cache.new(FILE_PATH) }

  after(:each) do
    File.delete(FILE_PATH)
  end

  describe '#store_tasks' do
    it 'returns an array of items with a cache-id' do
      items = cache.store_tasks(
        [
          { 'id' => 'long-id-1', text: 'text1' },
          { 'id' => 'long-id-2', text: 'text2' },
          { 'id' => 'long-id-3', text: 'text3' }
        ]
      )

      expect(items).to eq(
        [
          { 'id' => 'long-id-1', text: 'text1', 'cid' => 'l1' },
          { 'id' => 'long-id-2', text: 'text2', 'cid' => 'l2' },
          { 'id' => 'long-id-3', text: 'text3', 'cid' => 'l3' }
        ]
      )
    end

    it 'enables items to be retrieved by short id' do
      cache.store_tasks(
        [
          { 'id' =>  'long-id-1', text: 'text1' },
          { 'id' =>  'long-id-2', text: 'text2' },
          { 'id' =>  'long-id-3', text: 'text3' }
        ]
      )

      expect(cache.get('l1')).to eq(
        'id' => 'long-id-1', text: 'text1', 'cid' => 'l1'
      )
    end
  end

  describe '#destroy!' do
    it 'removes all items in cache' do
      cache.store_tasks(
        [
          { 'id' =>  'long-id-1', text: 'text1' },
          { 'id' =>  'long-id-2', text: 'text2' },
          { 'id' =>  'long-id-3', text: 'text3' }
        ]
      )

      expect(cache.get('l1')).to eq(
        'id' => 'long-id-1', text: 'text1', 'cid' => 'l1'
      )

      cache.destroy!
      expect(cache.get('l1')).to be_nil
      expect(cache.get('l2')).to be_nil
      expect(cache.get('l3')).to be_nil
    end
  end
end

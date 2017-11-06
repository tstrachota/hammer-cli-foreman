require File.join(File.dirname(__FILE__), '../test_helper')

describe HammerCLIForeman::Output::Formatters::ReferenceFormatter do

  let(:formatter) { HammerCLIForeman::Output::Formatters::ReferenceFormatter.new }
  let(:reference) do
    {
      :id => 1,
      :another_id => 2,
      :name => 'Server',
      :another_name => 'SERVER',
      :url => "URL",
      :desc => "Description"
    }
  end

  it "recovers when the resource is missing" do
    formatter.format(nil).must_equal ''
  end

  context "with symbol keys" do
    let(:reference_sym_keys) do
      reference
    end

    it "formats name by default" do
      formatter.format(reference_sym_keys, {}).must_equal 'Server'
    end

    it "can override name key" do
      options = {:display_field_key => :another_name}
      formatter.format(reference_sym_keys, options).must_equal 'SERVER'
    end

    it "renders additional details" do
      options = {:details => [:url, :desc]}
      formatter.format(reference_sym_keys, options).must_equal 'Server (URL, Description)'
    end

    it "renders additional details with labels" do
      options = {:details => [{:label => 'Url label', :key => :url}, :desc]}
      formatter.format(reference_sym_keys, options).must_equal 'Server (Url label: URL, Description)'
    end

    describe 'ids' do
      it "hides ids by default" do
        options = {:details => [{:id => true, :key => :id}]}
        formatter.format(reference_sym_keys, options).must_equal 'Server'
      end

      it "renders id when show_ids is true" do
        options = {:details => [{:id => true, :key => :id}], :context => {:show_ids => true}}
        formatter.format(reference_sym_keys, options).must_equal 'Server (1)'
      end

      it "hides id when show_ids is false" do
        options = {:details => [{:id => true, :key => :id}], :context => {:show_ids => false}}
        formatter.format(reference_sym_keys, options).must_equal 'Server'
      end
    end
  end

  context "with string keys" do
    let(:reference_str_keys) do
      reference.inject({}) do |new_ref, (key, value)|
        new_ref.update(key.to_s => value)
      end
    end

    it "formats name by default" do
      formatter.format(reference_str_keys, {}).must_equal 'Server'
    end

    it "can override name key" do
      options = {:display_field_key => :another_name}
      formatter.format(reference_str_keys, options).must_equal 'SERVER'
    end

    it "renders additional details" do
      options = {:details => [:url, :desc]}
      formatter.format(reference_str_keys, options).must_equal 'Server (URL, Description)'
    end

    it "renders additional details with labels" do
      options = {:details => [{:label => 'Url label', :key => :url}, :desc]}
      formatter.format(reference_str_keys, options).must_equal 'Server (Url label: URL, Description)'
    end

    describe 'ids' do
      it "hides ids by default" do
        options = {:details => [{:id => true, :key => :id}]}
        formatter.format(reference_str_keys, options).must_equal 'Server'
      end

      it "renders id when show_ids is true" do
        options = {:details => [{:id => true, :key => :id}], :context => {:show_ids => true}}
        formatter.format(reference_str_keys, options).must_equal 'Server (1)'
      end

      it "hides id when show_ids is false" do
        options = {:details => [{:id => true, :key => :id}], :context => {:show_ids => false}}
        formatter.format(reference_str_keys, options).must_equal 'Server'
      end
    end
  end
end

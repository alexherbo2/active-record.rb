require 'active-record'
require 'json'

data = File.open('spec/data/inflections.json') do |file|
  JSON.parse(file.read, symbolize_names: true)
end

describe ActiveRecord::Support::Inflector do
  let(:inflector) { ActiveRecord::Support::Inflector }

  describe '#pluralize' do
    data[:singular_to_plural].each do |singular, plural|
      it { expect(inflector.pluralize(singular)).to eq plural }
    end
  end

  describe '#singularize' do
    data[:plural_to_singular].each do |plural, singular|
      it { expect(inflector.singularize(plural)).to eq singular }
    end
  end

  describe '#camelize' do
    data[:underscore_to_camelcase].each do |underscore, camelcase|
      it { expect(inflector.camelize(underscore)).to eq camelcase }
    end
  end

  describe '#underscorize' do
    data[:camelcase_to_underscore].each do |camelcase, underscore|
      it { expect(inflector.underscorize(camelcase)).to eq underscore }
    end
  end

  describe '#demodulize' do
    data[:module_name_to_constant_name].each do |module_name, constant_name|
      it { expect(inflector.demodulize(module_name)).to eq constant_name }
    end
  end

  describe '#tableize' do
    data[:class_name_to_table_name].each do |class_name, table_name|
      it { expect(inflector.tableize(class_name)).to eq table_name }
    end
  end

  describe '#classify' do
    data[:table_name_to_class_name].each do |table_name, class_name|
      it { expect(inflector.classify(table_name)).to eq class_name }
    end
  end

  describe '#constantize' do
    it { expect(inflector.constantize('Object')).to eq Object }
  end

  describe '#foreign_key' do
    data[:class_name_to_foreign_key].each do |class_name, foreign_key|
      it { expect(inflector.foreign_key(class_name)).to eq foreign_key }
    end
  end
end

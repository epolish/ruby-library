[
  'active_support/hash_with_indifferent_access'
].each {|resource| require resource}
[
  './book',
  './order',
  './reader',
  './author',
  './resource/application',
  './resource/data_provider'
].each {|resource| require_relative resource}

class LibraryManager < Application
  include DataProvider

  attr_accessor :library

  def initialize(library)
    @library = library
  end

  def load_data(data=nil)
    data ||= self.read

    data['readers'].each do |value|
      @library.readers.push Reader.new value.symbolize_keys
    end

    data['authors'].each do |value|
      author = Author.new name: value['name']
      
      value['biography'].each do |book_name|
        book = Book.new title: book_name, author: author

        author.biography.push book
        @library.books.push book
      end

      @library.authors.push author
    end

    data['orders'].each do |value|
      @library.orders.push Order.new \
        book: @library.books.select {|book| book.title == value['book']}.first, 
        reader: @library.readers.select {|reader| reader.name == value['reader']}.first, 
        date: value['date']
    end
  end

  def save_data
    data = {readers: [], authors: [], orders: []}

    @library.readers.each do |reader|
      data[:readers].push \
        name: reader.name,
        email: reader.email,
        city: reader.city,
        street: reader.street,
        house: reader.house
    end

    @library.authors.each do |author|
      data[:authors].push \
        name: author.name,
        biography: author.biography.map {|book| book.title}
    end
    
    @library.orders.each do |order|
      data[:orders].push \
        book: order.book.title,
        reader: order.reader.name,
        date: order.date
    end

    self.write data
  end
  
  def get_most_popular(options={})
    if options[:key]
      data = @library.orders.each_with_object(Hash.new(0)) do |order, hash| 
        hash[order.public_send(options[:key])] += 1
      end

      if !options[:limit]
        data.max_by{|_, v| v}.first
      else
        data.sort_by{|_, v| -v}.first(options[:limit]).map{|k, v| {item: k, count: v}}
      end
    end
  end
end
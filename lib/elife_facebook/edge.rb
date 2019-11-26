module Edge
  include Enumerable
  attr_reader :parent, :client, :id

  def initialize id, data: nil, cursor: nil, client: nil, parent: nil
    @id = id
    @parent = parent
    @data = data
    @cursor = cursor
    @client = client
    client.bulk.add(bulk_payload) if data.nil?
  end

  def relative_url_base
    self.class.name.singularize.underscore
  end

  def other_query_args
    []
  end

  def bulk_payload cursor: nil, limit: nil
    query = [
      "fields=#{edge_klass.default_fields.join(',')}",
      "limit=#{limit || self.limit(0)}",
    ]

    if cursor
      query << "after=#{cursor}"
    end

    query = query.concat(other_query_args)

    {
      method: 'GET',
      relative_url: "#{@id}/#{relative_url_base}?#{query.join('&')}"
    }
  end

  def edge_klass
    singular_class_name = self.class.name.singularize
    begin
      singular_class_name.constantize
    rescue NameError => e
      raise %{
        As name of your edge is #{self.class.name}, we tried to load #{singular_class_name}
        automatically, but probably doesn't exists. Provide an edgeclass by overriding #{self.class.name}#edge_klass
        method or create #{singular_class_name} itself
      }
    end
  end

  def request_in_client
    client.edge_loop(self)
  end

  def extract_response resp
    first = (resp["data"] || []).first || {}

    if first["created_at"].present? || first["updated_time"].present?
      resp["data"] = resp["data"].sort_by {|i|
        DateTime.parse(i["created_at"] || i["updated_time"])
      }.reverse
    end

    resp
  end

  def limit_provider
    @limit_provider ||= begin
      LimitProvider.new
    end
  end

  def reduce_amount
    limit_provider.reduce_amount
  end

  def limit i
    limit_provider.is_a?(Numeric) ? limit_provider : limit_provider.limit(i)
  end

  def next
    each.next
  end

  def peek
    each.peek
  end

  def take_and_move(count)
    buffer = []
    begin
      count.times.each {|t|
        next_item = self.peek

        break if block_given? and not yield next_item
        
        buffer << self.next

        if t + 1 == count
          break
        end
      }
    rescue StopIteration => exception
    end

    buffer
  end

  def each &block
    if not block_given?
      @enum_for_each ||= enum_for(:each)
      return @enum_for_each
    end
    
    (@data || []).each {|d|
      yield edge_klass.new(d["id"], json: d, client: client, parent: parent)
    }
    
    # data.nil é o caso quando essa classe é inicializada diretamente
    # algo do tipo Edge.new(id)
    # quando o dado não é nil, quer dizer que ele veio como filho.
    # em caso de array vazio, é porque o filho não retornou nada
    if @data.nil? || @cursor
      request_in_client.each {|d|
        yield edge_klass.new(d["id"], json: d, client: client, parent: parent)
      }
    end
  end
end
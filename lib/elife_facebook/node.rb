module ElifeFacebook
  module Node
    attr_reader :id, :parent, :fields, :client

    def initialize id, client:, json: nil, parent: nil, fetch: true, fields: self.class.default_fields
      @id = id
      @json = json
      @client = client
      @parent = parent
      @fields = fields
      client.bulk.add(bulk_payload) if fetch && @json.nil?
    end

    def method_missing(m, *args, &block)
      is_set = m.to_s.ends_with?("=")
      field = is_set ? m.gsub("=", "") : m
      field = field.to_s

      if not fields.include? field
        ElifeFacebook.logger.debug("#{m} doesn't include into #{fields}, calling super")
        return super(m, *args, &block)
      end

      if is_set
        if args.size != 1
          raise ArgumentError, "You must pass 1 value to be set"
        end
        key = json.has_key?(field) ? field : field.to_sym
        json[key] = args.first
      else
        (json[field] || json[field.to_sym])
      end
    end

    def real_id
      @id
    end

    def inspect
      "<#{self.class.name}##{self.object_id} #{inspect_data}>"
    end

    def inspect_data
      r = [
        "id=#{self.id}"
      ]

      if parent
        r << "parent=#{parent.class.name}##{parent.id}"
      end

      if real_id != @id
        r << "real_id=#{real_id}"
      end

      r.join(' ')
    end

    def handle_exception e
      raise e
    end

    def request_in_client
      begin
        client.fetch_node(self)["body"]
      rescue => exception
        handle_exception exception
      end
    end

    def valid?
      ! json.is_a?(StandardError)
    end

    def json
      @json ||= request_in_client
    end

    def bulk_payload
      query = [
        "fields=#{fields.join(',')}",
      ]

      {
        method: 'GET',
        relative_url: "#{real_id}?#{query.join('&')}"
      }
    end

    module ClassMethods

      def default_fields
        klass_singular = final_path(name).underscore
        ElifeFacebook.default_fields_for(klass_singular)
      end

      # define a edge
      # 
      # example: if you call 
      # edge :comments, Comments
      # 
      # is the same of 
      # 
      # attr_writer :comments
      # def comments
      #   @comments ||= begin
      #     Comments.new(
      #       self.id,
      #       client: client,
      #       data: json.dig("comments", "data") || [],
      #       cursor: json.dig("comments", "paging", "cursors", "next")
      #     )
      #   end
      # end
      
      def edge name, klass
        attr_writer name
        instance_var = "@#{name}".to_sym

        if self.respond_to? name
          ElifeFacebook.logger.warn "warning: you're overriding method #{name} with edge #{klass}"
        end

        ElifeFacebook.logger.debug "#{self.name} => defining #{name} with edge #{klass}"

        define_method name do
          if not instance_variable_defined?(instance_var)
            args = {
              client: client,
              parent: self
            }

            if @json
              args.merge!({
                data: @json.dig(name.to_s, "data"),
                cursor: @json.dig(name.to_s, "paging", "cursors", "after")
              })
            end
      
            conn = klass.new(
              self.real_id,
              args
            )

            # Nodet deveria funcionar com um cliente do tipo GraphClient
            # mas agora ta acessando um método do InstameterGraphClient. Isso é ruim. Talvez
            # Fazer o que eu pensei, algo na linha de chamar um after edge created hook
            # e permitir sobrescrever a Node em algo como ApplicationNode, em que ela lida com funcionalidades
            # da aplicação, fazendo com que essa classe tenha menos responsabilidades.
            # mas acho que isso é tranquilo de mudar e vou deixar isso aqui

            instance_variable_set(instance_var, conn)
          end

          instance_variable_get(instance_var)
        end
      end

      # define an node
      # 
      # example: if you call 
      # node :owner, Owner
      # 
      # is the same of 
      # 
      # attr_writer :owner
      # def owner
      #   @owner ||= begin
      #     Owner.new(
      #       json.dig('owner', id),
      #       client: client
      #     )
      #   end
      # end
      
      def node name, klass, options = {}
        attr_writer name
        instance_var = "@#{name}".to_sym

        if self.respond_to? name
          ElifeFacebook.logger.warn "warning: you're overriding method #{name} with node #{klass}"
        end

        ElifeFacebook.logger.debug "#{self.name} => defining #{name}#{options[:multiple] && "(multiple)"} with node #{klass}"

        define_method name do |*args, **kwargs|
          id = args.shift

          if id.nil? && options[:multiple]
            raise ArgumentError, "as #{name} node is a multiple node, you must pass an id in initialization as first argument"
          end

          if not instance_variable_defined?(instance_var)
            instance_variable_set(instance_var, {})
          end

          nodes = instance_variable_get(instance_var)

          json_field = (options[:json_field] || name).to_s

          nodes[id] ||= begin
            kwargs.reverse_merge!({
              client: client,
              parent: self,
            })
            
            if options[:fields]
              kwargs.reverse_merge!({
                fields: options[:fields]
              })
            end

            if options[:pass_json_in_instanciating]
              kwargs.merge!(json: self.json.dig(json_field))
            end

            final_id = id || self.json.dig(json_field, 'id') || self.json.dig("#{json_field}_id")

            if final_id
              klass.new(
                final_id,
                *args,
                **kwargs
              )
            end
          end
        end
      end
    end

    def self.included base
      base.extend GemHelpers
      base.extend ClassMethods
    end
  end
end
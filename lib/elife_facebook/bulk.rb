module ElifeFacebook
  class Bulk
    def initialize
      @last_group = []
      @map_payload_group = {}
      @map_payload_response = {}
      @map_group_responses = {}
      @payload_per_group = 50
    end

    def inspect
      "<#{self.class.name}##{self.object_id} @payload_per_group=#{@payload_per_group}>"
    end

    def has_payload? payload
      json = payload.is_a?(String) ? payload : payload.to_json
      @map_payload_group.has_key? json
    end

    def remove payload
      json = payload.is_a?(String) ? payload : payload.to_json
      ElifeFacebook.logger.debug "removing payload #{json}"
      if group = @map_payload_group[json]
        group.delete json
      end
      @map_payload_group.delete json
      @map_payload_response.delete json
    end

    def add payload
      json = payload.is_a?(String) ? payload : payload.to_json
      return if has_payload? json

      if @last_group.size == @payload_per_group
        @last_group = []
      end

      if @map_group_responses.has_key? @last_group
        @last_group = []
      end

      @last_group << json
      @map_payload_group[json] = @last_group
      # ElifeFacebook.logger.debug "added payload #{json} to #{@last_group.object_id}"
    end

    def execute payload, client
      json = payload.is_a?(String) ? payload : payload.to_json
      add json

      if not @map_payload_response[json].present?
        group = @map_payload_group[json]

        group_response = group_request(group, client)
        group_response.zip(group).each {|response, json|
          @map_payload_response[json] = response.merge({
            "body" => JSON.parse(response["body"])
          })
        }

        if not @map_payload_response.has_key? json
          raise %{
            Something got wrong.
            bulk Collect
            request=#{group}
            response=#{group_response}
          }
        end
      end

      begin
        client.validate_bulk_item!(@map_payload_response[json])
      rescue Exception => exception
        ElifeFacebook.logger.fatal("error in bulk request, payload #{json}, token #{client.token} #{exception.message}")
        raise exception
      end

      return @map_payload_response[json]
    end

    def group_request group, client
      @map_group_responses[group] ||= begin
        payload = group.map {|p| JSON.parse(p) }
        # ap "making bulk request with #{group.size} size"
        # ap payload
        client.bulk(payload).parsed_response
      end
    end
  end
end
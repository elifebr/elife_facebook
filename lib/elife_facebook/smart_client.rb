# recebe um token provider
# principal responsabilidade é fazer retornar um interator
# responsavel por chamar o GraphClient com o token vindo do provider
# retorna cada item do json de forma "bruta"
# essa classe lida com tokens da aplicação, incremento de limite

module ElifeFacebook
  class SmartClient
    class ExecutionsMaxException < StandardError ; end

    attr_reader :bulk, :token_provider

    def initialize token_provider:, max_executions: 5, bulk: Bulk.new
      @token_provider = token_provider
      @max_executions = max_executions
      @bulk = bulk
    end

    def client
      @client ||= begin
        GraphClient.new(token_provider.token)
      end
    end

    # simple delegate
    def user_id
      token_provider.user_id
    end

    # coloque uma chamada ao cliente do instagram em volta disso
    def handling edge_or_node
      executions = 0
      begin
        yield
      rescue => e
        executions += 1

        if e.is_a?(GraphClient::RequestAbortedException) or e.is_a?(GraphClient::UnexpectedErrorRetryLaterException)
          if executions <= @max_executions
            sleep 20
            retry
          else
            raise ExecutionsMaxException.new e.message
          end
        elsif e.is_a?(GraphClient::ReduceAmountOfDataException)
          if edge_or_node.respond_to? :reduce_amount
            edge_or_node.reduce_amount
            retry
          else
            raise e
          end
        elsif token_provider.invalidate e
          @client = nil
          if executions <= @max_executions
            retry
          else
            raise ExecutionsMaxException.new e.message
          end
        else
          raise e
        end
      end
    end

    # make validations!
    def validate_resp_and_get_body! resp
      if resp.is_a?(Hash) and resp["body"].present? and resp["headers"].present?
        # bulk resp
        return resp["body"]
      end
      resp.respond_to?(:parsed_response) ? resp.parsed_response : resp
    end

    def fetch_node node
      bulk_execute(node) do
        node.bulk_payload
      end
    end

    def bulk_execute edge_or_node, &block
      previous_payload = nil

      handling(edge_or_node) do
        bulk_payload = yield
        bulk_payload = bulk_payload.is_a?(String) ? bulk_payload : bulk_payload.to_json
        remove_from_bulk(previous_payload) if previous_payload
        previous_payload = bulk_payload
        @bulk.execute(bulk_payload, client)
      end
    end

    def remove_from_bulk payload
      @bulk.remove(payload)
    end

    def edge_loop edge
      cursor = nil
      
      Enumerator.new {|y|
        i = 0
        
        loop {
          limit = edge.limit(i)

          resp = bulk_execute(edge) do
            edge.bulk_payload(cursor: cursor, limit: limit)
          end

          resp = validate_resp_and_get_body! resp
          resp = edge.extract_response resp

          cursor = resp.dig("paging", "cursors", "after")

          if @bulk && cursor
            bulk_payload = edge.bulk_payload(cursor: cursor, limit: edge.limit(i + 1))
            @bulk.add(bulk_payload)
          end
    
          (resp.dig("data") || []).each {|m|
            y << m
          }
          
          break unless cursor

          i += 1
        }
      }
    end
  end
end
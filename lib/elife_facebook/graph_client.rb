module ElifeFacebook
  class GraphClient
    include HTTParty

    class ApplicationDoesntHasPermistionToPerformThisActionException < StandardError ; end
    class HashtagCanNotBeFetchedByUserException < StandardError ; end
    class InvalidUserIdException < StandardError ; end
    class MediaPostedBeforeBusinessAccountConversionException < StandardError ; end
    class NotEnoughViewersToShowInsightsException < StandardError ; end
    class ObjectDoesNotExistsOrCantBeLoadedException < StandardError ; end
    class PermissionError < StandardError ; end
    class RequestAbortedException < StandardError ; end
    class ResourceDoesntExistsException < StandardError ; end
    class ResourceLimitException < StandardError ; end
    class TokenInvalidException < StandardError ; end
    class UnexpectedErrorRetryLaterException < StandardError ; end
    class UnhandledException < StandardError ; end
    class ReduceAmountOfDataException < StandardError ; end

    attr_reader :token

    def initialize token, version: 'v4.0'
      @token = token
      @version = version
    end

    def base_url
      "https://graph.facebook.com/#{@version}/"
    end

    def raise_error body
      message = body.dig("error", "message")
      code = body.dig("error", "code")
      error_subcode = body.dig("error", "error_subcode")

      message = message == "Invalid parameter" ? body.dig("error", "error_user_title") || message : message 

      if /Application does not have permission for this action/ =~ message
        raise ApplicationDoesntHasPermistionToPerformThisActionException, body.to_json
      end

      if /The requested resource does not exist/ =~ message
        raise ResourceDoesntExistsException, body.to_json
      end

      if message.include? "does not exist, cannot be loaded due to missing permissions, or does not support this operation"
        raise ObjectDoesNotExistsOrCantBeLoadedException, body.to_json
      end

      if "This API call could not be completed due to resource limits" == message
        raise ResourceLimitException, body.to_json
      end

      if /There have been too many calls to this Instagram account/ =~ message
        raise ResourceLimitException, body.to_json
      end

      if "Request aborted. This could happen if a dependent request failed or the entire request timed out." == message
        raise RequestAbortedException, body.to_json
      end
      
      if "(#10) Not enough viewers for the media to show insights" == message
        raise NotEnoughViewersToShowInsightsException, body.to_json
      end
      
      if "Invalid user id" == message
        raise InvalidUserIdException, body.to_json
      end

      if "An unexpected error has occurred. Please retry your request later." == message
        raise UnexpectedErrorRetryLaterException, body.to_json
      end

      if "(#200) Permissions error" == message
        raise PermissionError, body.to_json
      end

      if "Media Posted Before Business Account Conversion" == message
        raise MediaPostedBeforeBusinessAccountConversionException, body.to_json
      end

      if /reduce the amount of data/ =~ message
        raise ReduceAmountOfDataException, body.to_json
      end
      
      if code == 100 && error_subcode == 2108006
        raise MediaPostedBeforeBusinessAccountConversionException, body.to_json
      end

      token_exception = [
        "Error validating access token: The session has been invalidated because the user changed their password or Facebook has changed the session for security reasons.",
        "Error validating access token: The user has not authorized application",
        "Error validating access token: The user is enrolled in a blocking, logged-in checkpoint",
        "Error validating access token: Sessions for the user are not allowed because the user is not a confirmed user.",
      ].any? {|msg|
        message.include? msg
      }

      raise TokenInvalidException, body.to_json if token_exception
      raise UnhandledException, body.to_json
    end

    def validate! resp
      if resp.success?
        return
      end

      raise_error(resp.parsed_response)
    end

    def validate_bulk_item! bulk_item_response
      if bulk_item_response["code"] >= 200 && bulk_item_response["code"] < 300
        return
      end

      raise_error(bulk_item_response.dig("body"))
    end

    def bulk payload
      Instameter.config.logger.debug "bulk with #{payload} and #{@token}"

      self.class.post(
        base_url,
        query: {
          access_token: @token
        },
        body: {
          batch: payload.to_json
        },
        headers: {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
        },
        # debug_output: STDOUT
      ).tap {|resp| validate!(resp)}
    end
  end
end
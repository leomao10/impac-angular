#=======================================
# This provider service is designed to provide impac-angular with all it's vital methods & data,
# while internally keeping it's concerns as focused as possible.
# TODO: when this gets less varied.. split out into multiple, more specific providers.
#=======================================
angular
  .module('impac.services.linking', [])
  .provider('ImpacLinking', () ->
    provider = @
    #=======================================
    # Private Defaults
    #=======================================
    # Required data:
    links = {
      user: null, # @params Function -> returns Promise
      organizations: null # @params Function -> return Promise
    }
    #=======================================
    # Public methods available in config
    #=======================================
    # Iterates over default links object and assigns values from configData with strict checking.
    provider.linkData = (configData)  ->
      _.forIn(links, (value, key) ->
        link = configData[key]
        unless link?
          throw new Error("impac-angular linking.svc: Missing core data (#{key}) to run impac-angular.")
        if typeof link != 'function'
          throw new TypeError("impac-angular linking.svc: #{key} should be a Function.")
        links[key] = link
      )

    #=======================================
    _$get = ($q) ->
      service = @
      #=======================================
      # Public methods available as service
      #=======================================
      service.getUserData = ->
        return links.user().then(
          (success) ->
            return success
          (err) ->
            return $q.reject(err)
      )

      service.getOrganizations = ->
        return links.organizations().then(
          (success) ->
            return success
          (err) ->
            return $q.reject(err)
        )

      return service
    # inject service dependencies here, and declare in _$get function args.
    _$get.$inject = ['$q'];
    # attach provider function onto the provider object
    provider.$get = _$get

    return provider

  )

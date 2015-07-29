module DeterLab
  module Resources

    # returns the list of realizations
    def view_resources(uid, options = nil)
      options ||= {}
      cl = client("Resources", uid)

      msg = { uid: uid }
      msg[:realization]  = options[:realization] if options[:realization]
      msg[:persist]      = options[:persist] if options[:persist]
      response = cl.call(:view_resources, message: msg)

      return parse_resources(response.to_hash[:view_resources_response][:return])
    rescue Savon::SOAPFault => e
      process_error e
    end

    private

    def parse_resources(ret)
      [ ret || [] ].flatten.map { |r| parse_resource(r) }
    end

    def parse_resource(res)
      facets = [ res[:facets] || [] ].flatten.map { |f| parse_facet(f) }
      perms  = [ res[:perms] || [] ].flatten
      tags   = [ res[:tags] || [] ].flatten.map { |t| parse_tag(t) }

      ResourceDescription.new({
        name:         res[:name],
        type:         res[:type],
        description:  res[:description],
        facets:       facets,
        perms:        perms,
        tags:         tags
      })
    end

    def parse_facet(f)
      ResourceFacet.new({
        name:   f[:name],
        type:   f[:type],
        units:  f[:units],
        value:  f[:value],
        tags:   [ f[:tags] || [] ].flatten.map { |t| parse_tag(t) }
      })
    end

    def parse_tag(t)
      ResourceTag.new({
        name:   t[:name],
        value:  t[:value]
      })
    end
  end
end

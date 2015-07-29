module DeterLab
  module Realizations

    # returns the list of realizations
    def view_realizations(uid, options = nil)
      options ||= {}
      cl = client("Realizations", uid)

      msg = { uid: uid }
      msg[:regex]  = options[:regex] if options[:regex]
      msg[:offset] = options[:offset] if options[:offset]
      msg[:count]  = options[:count] if options[:count]
      response = cl.call(:view_realizations, message: msg)

      return parse_descriptions(response.to_hash[:view_realizations_response][:return])
    rescue Savon::SOAPFault => e
      process_error e
    end

    # starts the realization of an experiment
    def realize_experiment(uid, eid, cid, options = nil)
      options ||= {}
      cl = client("Experiments", uid)

      msg = { uid: uid, eid: eid, cid: cid }
      response = cl.call(:realize_experiment, message: msg)

      return parse_descriptions(response.to_hash[:realize_experiment_response][:return])
    rescue Savon::SOAPFault => e
      process_error e
    end

    # releases realization resources
    def release_realization(uid, name)
      options ||= {}
      cl = client("Realizations", uid)

      msg = { name: name }
      response = cl.call(:release_realization, message: msg)

      return response.to_hash[:release_realization_response][:return]
    rescue Savon::SOAPFault => e
      process_error e
    end

    # removes the realization
    def remove_realization(uid, name)
      options ||= {}
      cl = client("Realizations", uid)

      msg = { name: name }
      response = cl.call(:remove_realization, message: msg)

      return response.to_hash[:remove_realization_response][:return]
    rescue Savon::SOAPFault => e
      process_error e
    end

    private

    def parse_descriptions(ret)
      [ ret ].flatten.reject(&:blank?).map { |d| parse_description(d) }
    end

    def parse_description(ret)
      containments = [ ret[:containment] || [] ].flatten.map do |c|
        RealizationContainment.new(inner: c[:inner], outer: c[:outer])
      end

      mappings = [ ret[:mapping] || [] ].flatten.map do |m|
        RealizationMap.new(resource: m[:resource], topology_name: m[:topology_name])
      end

      RealizationDescription.new({
        circle:       ret[:circle],
        experiment:   ret[:experiment],
        name:         ret[:name],
        status:       ret[:status],
        containments: containments,
        mappings:     mappings
      })
    end
  end
end

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

      return response.to_hash[:view_realizations_response][:return] || []
    rescue Savon::SOAPFault => e
      process_error e
    end

    # starts the realization of an experiment
    def realize_experiment(uid, eid, cid, options = nil)
      options ||= {}
      cl = client("Experiments", uid)

      msg = { uid: uid, eid: eid, cid: cid }
      response = cl.call(:realize_experiment, message: msg)

      return response.to_hash[:realize_experiment_response][:return] || []
    rescue Savon::SOAPFault => e
      process_error e
    end

    # releases realization resources
    def release_realization
      raise "Not implemented"
    end

    # removes the realization
    def remove_realization
      raise "Not implemented"
    end

  end
end

# encoding: utf-8

require 'puppet/type'
require 'puppet_x/eos/provider'
Puppet::Type.type(:radius_server).provide(:eos) do
  # Create methods that set the @property_hash for the #flush method
  mk_resource_methods

  # Mix in the api as instance methods
  include PuppetX::Eos::EapiProviderMixin
  # Mix in the api as class methods
  extend PuppetX::Eos::EapiProviderMixin

  def self.instances
    api = eapi.Radius
    servers = api.servers
    servers.map do |api_attributes|
      puppet_attributes = { name: namevar(api_attributes), ensure: :present, }
      new(api_attributes.merge(puppet_attributes))
    end
  end

  def initialize(resource = {})
    super(resource)
    @property_flush = {}
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    @property_flush = resource.to_hash
  end

  def destroy
    @property_flush = resource.to_hash
  end

  def hostname=(value)
    @property_flush[:hostname] = value
  end

  def auth_port=(value)
    @property_flush[:auth_port] = value
  end

  def acct_port=(value)
    @property_flush[:acct_port] = value
  end

  def key=(value)
    @property_flush[:key] = value
  end

  def key_format=(value)
    @property_flush[:key_format] = value
  end

  def retransmit_count=(value)
    @property_flush[:retransmit_count] = value
  end

  def timeout=(value)
    @property_flush[:timeout] = value
  end

  def flush
    api = eapi.Radius
    desired_state = @property_hash.merge(@property_flush)
    validate_identity(desired_state)
    case desired_state[:ensure]
    when :present
      api.update_server(desired_state)
    when :absent
      api.remove_server(desired_state)
    end
    @property_hash = desired_state
  end

  ##
  # validate_identity checks to make sure there are enough options specified to
  # uniquely identify a radius server resource.
  def validate_identity(opts = {})
    errors = false
    missing = [:hostname, :auth_port, :acct_port].reject { |k| opts[k] }
    errors = !missing.empty?
    msg = "Invalid options #{opts.inspect} missing: #{missing.join(', ')}"
    fail Puppet::Error, msg if errors
  end
  private :validate_identity

  def self.namevar(opts)
    hostname  = opts[:hostname] or fail ArgumentError, 'hostname required'
    auth_port = opts[:auth_port] || 1812
    acct_port = opts[:acct_port] || 1813
    "#{hostname}/#{auth_port}/#{acct_port}"
  end
end

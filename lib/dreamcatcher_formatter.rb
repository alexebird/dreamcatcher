require 'httparty'

class DreamcatcherFormatter
  include HTTParty
  base_uri 'http://localhost:9393'

  RSpec::Core::Formatters.register self,
    :start,
    :example_group_started,
    :example_started, :example_passed, :example_passed, :example_failed, :example_pending,
    :message,
    :stop,
    :dump_summary,
    :seed,
    :close

  attr_reader :failures

  def initialize(output)
  end

  #def start(StartNotification)
  def start(notification)
    post(__method__, notification.to_h)
 end

  #Once per example group
  #def example_group_started(GroupNotification)
  def example_group_started(notification)
    metadata = metadata_hash(notification.group.metadata)
    metadata.delete(:execution_result)
    hsh = {
      description: notification.group.description,
      metadata: metadata,
    }
    post(__method__, hsh)
  end

  # @api private
  def metadata_hash(metadata)
    metadata = metadata.clone
    er = metadata[:execution_result].to_h
    metadata.delete(:block)
    metadata[:execution_result] = er
    metadata
  end

  #Once per example
  #def example_started(ExampleNotification)
  def example_started(notification)
    metadata = metadata_hash(notification.example.metadata)
    metadata.delete(:example_group)
    hsh = {
      description: notification.example.description,
      metadata: metadata,
    }
    post(__method__, hsh)
  end

  #One of these per example, depending on outcome
  #def example_passed(ExampleNotification)
  def example_passed(notification)
    metadata = metadata_hash(notification.example.metadata)
    metadata.delete(:example_group)
    hsh = {
      description: notification.example.description,
      metadata: metadata,
    }
    post(__method__, hsh)
  end

  #def example_failed(FailedExampleNotification)
  def example_failed(notification)
    post(__method__, notification.to_h)
    #example = notification.example
    #error_hash = format_example(example).tap do |hash|
      #e = example.exception
      #if e
        #hash[:exception] =  {
          #:class => e.class.name,
          #:message => e.message,
          #:backtrace => e.backtrace,
        #}
      #end
    #end
  end

  #def example_pending(ExampleNotification)
  def example_pending(notification)
    metadata = metadata_hash(notification.example.metadata)
    metadata.delete(:example_group)
    hsh = {
      description: notification.example.description,
      metadata: metadata,
    }
    post(__method__, hsh)
  end

  #Optionally at any time
  #def message(MessageNotification)
  def message(notification)
    post(__method__, notification.to_h)
  end

  #At the end of the suite
  #def stop(ExamplesNotification)
  def stop(notification)
  end

  #def start_dump(NullNotification)
  #def start_dump(notification)
  #end

  #def dump_pending(ExamplesNotification)
  #def dump_pending(notification)
  #end

  #def dump_failures(ExamplesNotification)
  #def dump_failures(notification)
  #end

  #def dump_summary(SummaryNotification)
  def dump_summary(notification)
  end

  #def seed(SeedNotification)
  def seed(notification)
    return unless notification.seed_used?
    post(__method__, {seed: notification.seed})
  end

  #def close(NullNotification)
  def close(_notification)
    # do nothing since parent class writes to an IO here and we dont want that
  end

  # @api private
  def post(rspec_method, data)
    ap rspec_method
    ap data
    self.class.post("/dreamcatcher/rspec_hook_event/#{rspec_method}.json", { body: JSON.dump(data) })
  end
end

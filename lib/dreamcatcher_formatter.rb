require 'net/http'
require 'json'

class DreamcatcherFormatter
  RSpec::Core::Formatters.register self,
    :example_passed,
    :example_failed
    #:start,
    #:example_group_started,
    #:example_started, :example_passed, :example_passed, :example_failed, :example_pending,
    #:message,
    #:stop,
    #:dump_summary,
    #:seed,
    #:close

  def initialize(output)
  end

  # StartNotification
  #def start(notification)
    #post(__method__, notification.to_h)
  #end

  # Once per example group
  # GroupNotification
  #def example_group_started(notification)
    #metadata = metadata_hash(notification.group.metadata)
    #metadata.delete(:execution_result)
    #hsh = {
      #description: notification.group.description,
      #metadata: metadata,
    #}
    #post(__method__, hsh)
  #end

  #private def metadata_hash(metadata)
    #metadata = metadata.clone
    #er = metadata[:execution_result].to_h
    #metadata.delete(:block)
    #metadata[:execution_result] = er
    #metadata
  #end

  # Once per example
  # ExampleNotification
  #def example_started(notification)
    #metadata = metadata_hash(notification.example.metadata)
    #metadata.delete(:example_group)
    #hsh = {
      #description: notification.example.description,
      #metadata: metadata,
    #}
    #post(__method__, hsh)
  #end

  #private def format_notification(notification)
    #metadata = metadata_hash(notification.example.metadata)
    #metadata.delete(:example_group)
    #{
      #description: notification.example.description,
      #metadata: metadata,
    #}
  #end

  private def notification_to_document(notification)
    metadata = notification.example.metadata
    ex_res = metadata[:execution_result]
    {
      full_description: metadata[:full_description],
      status: ex_res.status,
      file_path: metadata[:file_path],
      line_number: metadata[:line_number],
      #exception: ex_res.exception ? ex_res.exception.message.strip.split("\n") : nil,
      exception: ex_res.exception,
      started_at: ex_res.started_at,
      finished_at: ex_res.finished_at,
      run_time: ex_res.run_time.to_s,
    }
  end

  # One of these per example, depending on outcome
  # ExampleNotification
  def example_passed(notification)
    post(__method__, notification_to_document(notification))
  end

  # FailedExampleNotification
  def example_failed(notification)
    post(__method__, notification_to_document(notification))
  end

  # ExampleNotification
  #def example_pending(notification)
    #metadata = metadata_hash(notification.example.metadata)
    #metadata.delete(:example_group)
    #hsh = {
      #description: notification.example.description,
      #metadata: metadata,
    #}
    #post(__method__, hsh)
  #end

  #Optionally at any time
  # MessageNotification
  #def message(notification)
    #post(__method__, notification.to_h)
  #end

  #At the end of the suite
  # ExamplesNotification
  #def stop(notification)
  #end

  # NullNotification
  #def start_dump(notification)
  #end

  # ExamplesNotification
  #def dump_pending(notification)
  #end

  # ExamplesNotification
  #def dump_failures(notification)
  #end

  # SummaryNotification
  #def dump_summary(notification)
  #end

  # SeedNotification
  def seed(notification)
    return unless notification.seed_used?
    post(__method__, {seed: notification.seed})
  end

  # NullNotification
  def close(_notification)
    # do nothing since parent class writes to an IO here and we dont want that
  end

  # @api private
  def post(rspec_method, data)
    #ap rspec_method
    #ap data

    #self.class.post("/dreamcatcher/rspec_hook_event/#{rspec_method}.json", { body: JSON.dump(data) })
    #base_uri 'http://localhost:9393'

    http = Net::HTTP.new('localhost', 9393)
    resp = http.post("/dreamcatcher/rspec_hook_event/#{rspec_method}.json", JSON.dump(data))
    puts resp
  end
end

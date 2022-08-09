require 'nokogiri'
require 'fileutils'
app_files = File.expand_path('../../../app/models/*.rb', __FILE__)
Dir.glob(app_files).each { |file| require(file) }

class GenFeedbackXmlService
  class << self
    def generate_feedback_xml
      content = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.root {
          xml.feedbacks {
            Feedback.find_each do |feedback|
              xml.widget {
                xml.id_ feedback.id
                xml.owner_login feedback.owner_login
                xml.comment feedback.comment
                xml.feedback_type feedback.feedbackable_type
                if feedback.feedbackable_type == 'Post'
                  xml.rating feedback.feedbackable.average_rating
                end
              }
            end
          }
        }
      end
      File.write('feedbacks.xml', content.to_xml)
    end
  end
end

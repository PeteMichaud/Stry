class BlockDecorator < Draper::Base
  decorates :block
  decorates_association :attachments

end

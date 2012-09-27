class SceneDecorator < Draper::Base
  decorates :scene
  decorates_association :blocks

end

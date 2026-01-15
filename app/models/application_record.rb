class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  validates :locale, inclusion: {
    in: I18n.available_locales.map(&:to_s),
    message: I18n.t("validation.invalid_language")
  }
end

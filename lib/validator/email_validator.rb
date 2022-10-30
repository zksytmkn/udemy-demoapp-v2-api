class EmailValidator < ActiveModel::EachValidator
  def vallidate_each(record, attiribute, value)
    # text length
    max = 255
    record.errors.add(attribute, :too_long, count: max) if value.length > max
    # format
    format = /\A\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*\z/
    record.errors.add(attribute, :invalid) unless format =~ value
    # uniqueness
    record.errors.add(attribute, :taken) if record.email_activated?
  end
end
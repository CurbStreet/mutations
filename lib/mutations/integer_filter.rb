module Mutations
  class IntegerFilter < InputFilter
    @default_options = {
      nils: false,       # true allows an explicit nil to be valid. Overrides any other options
      # TODO: add strict
      min: nil,          # lowest value, inclusive
      max: nil           # highest value, inclusive
    }

    def filter(data)

      # Handle nil case
      if data.nil?
        return [nil, nil] if options[:nils]
        return [nil, :nils]
      end

      # Ensure it's the correct data type (Fixnum)
      if !data.is_a?(Fixnum)
        if data.is_a?(String) && data =~ /^-?\d/
          data = data.to_i
        else
          return [data, :integer]
        end
      end

      return [data, :min] if options[:min] && data < options[:min]
      return [data, :max] if options[:max] && data > options[:max]

      # We win, it's valid!
      [data, nil]
    end
  end
end
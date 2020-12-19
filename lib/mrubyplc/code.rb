module MRubyPlc
class Code

  attr_reader :no, :address, :opecode, :operands, :comments

  def initialize line
    @operands = []
    @comments = []
    comment = false
    a = line.strip.split(/\s+/)
    a.each_with_index do |e, i|
      case i
      when 0
        @no = e.to_i
      when 1
        @address = e.to_i
      when 2
        @opecode = e
      else
        case e
        when ";"
          comment = true
        else
          unless comment
            @operands << e
          else
            @comments << e
          end
        end
      end
    end
  end

end
end

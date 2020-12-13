module MRubyPlc

  NONE_SEG    = 0
  NODE_SEG    = 1
  IREP_SEG    = 2
  LOCAL_SEG   = 3
  CODE_SEG    = 4


  def load path
    s = `mrbc -v #{path}`
    irep = nil
    segment = NONE_SEG
    s.each_line do |l|
      case l
      when /^irep(.+)/
        irep = IREP.new
        $1.split(/\s/).each do |kv|
          case kv
          when /^0x/
            irep.id = kv
          when /\=/
            a = kv.split('=')
            irep.send("#{a.first}=", a.last.to_i)
          when "", nil
            next
          end
        end
      when /^local/
        segment = LOCAL_SEG
      when /^file:/
        segment = CODE_SEG
      else
        case segment
        when LOCAL_SEG
          /\s+(R\d+):(.+)/ =~ l
          irep.locals[$1] = $2
        when CODE_SEG
          irep.codes << Code.new(l)
        end
      end
    end
    irep
  end
  module_function :load

end

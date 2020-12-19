module MRubyPlc

  NONE_SEG    = 0
  NODE_SEG    = 1
  IREP_SEG    = 2
  LOCAL_SEG   = 3
  CODE_SEG    = 4


  def load path
    s = `mrbc -v #{path}`
    irep = IREP.new.tap{|i| i.no = 0 }
    segment = NONE_SEG
    s.each_line do |l|
      case l

      # load variables
      # lhs
      when /NODE_SCOPE/
        segment = NODE_SEG
      when /^(\d+)\s+NODE_LVAR\s+(.+)/
        name = $2
        no = $1.to_i
        irep.variables[no] = {name: name, variable_type: :local}
      when /^(\d+)\s+NODE_IVAR\s+(.+)/
        name = $2
        no = $1.to_i
        irep.variables[no] = {name: name, variable_type: :instance}
      when /^(\d+)\s+NODE_CVAR\s+(.+)/
        name = $2
        no = $1.to_i
        irep.variables[no] = {name: name, variable_type: :class}
      when /^(\d+)\s+NODE_GVAR\s+(.+)/
        name = $2
        no = $1.to_i
        irep.variables[no] = {name: name, variable_type: :global}

      # rhs
      when /^(\d+)\s+(NODE_TRUE|NODE_FALSE)/
        no = $1.to_i
        v = /TRUE/ =~ $2
        irep.variables[no].tap do |h|
          h[:value_type] = :boolean
          h[:value] = v
        end
      when /^(\d+)\s+NODE_INT\s+([1-9a-f]+)\s+base\s+(\d+)/
        no = $1.to_i
        v = $2
        b = $3
        irep.variables[no].tap do |h|
          h[:value_type] = :integer
          h[:base] = b.to_i
          h[:value] = v.to_i(h[:base])
        end
      when /^(\d+)\s+NODE_FLOAT\s+(.+)/
        no = $1.to_i
        v = $2
        irep.variables[no].tap do |h|
          h[:value_type] = :float
          h[:value] = v.to_f
        end
      when /^(\d+)\s+NODE_STR\s+"(.+)"\s+len\s+(\d+)/
        no = $1.to_i
        v = $2
        s = $3.to_i
        irep.variables[no].tap do |h|
          h[:value_type] = :string
          h[:value] = v
          h[:size] = s
        end
      when /^(\d+)\s+NODE_SYM\s+(.+)\s+\((\d+)\)/
        no = $1.to_i
        v = $2
        id = $3.to_i
        irep.variables[no].tap do |h|
          h[:value_type] = :string
          h[:value] = v
          h[:id] = id
        end

      
      when /^irep(.+)/
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
          register = $1
          name = $2
          irep.variables.find{|v| v && v[:variable_type] == :local && v[:name] == name}.tap do |v|
            v[:register] = register
          end
        when CODE_SEG
          irep.codes << Code.new(l)
        end
      end
    end
    irep
  end
  module_function :load

end

require "./spinner/*"

class Spin
  property delay
  property chars : Array(String) | Array(Colorize::Object(String))
  property text : String | Colorize::Object(String)

  CL    = STDOUT.tty? ? "\u001b[0G" : "\u000d \u000d"
  CLEAR = STDOUT.tty? ? "\u001b[2K" : "\u000d"

  def initialize(@delay = 0.1, chars = Spinner::Charset[:pipe], @text = "", output = STDOUT)
    @state = true
    @chars = chars.to_a
    @output = output
  end

  def stop
    @state = false
    @output.print CLEAR
    @output.flush
  end

  private def clear(count)
    @output.print CL * count
    @output.flush
  end

  def start
    spawn do
      i = 0
      while @state
        chars = @chars[i % @chars.size]

        @output.print "#{chars} #{text}"
        @output.flush
        # to_s for colorize
        clear(chars.to_s.size)

        sleep @delay

        i += 1
      end
    end
  end
end

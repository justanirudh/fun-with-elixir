#http://benjamintan.io/blog/2013/06/25/elixir-for-the-lazy-impatient-and-busy-part-2-processes-101/
defmodule Helloer do
    def hola do
      receive do
        {sender, msg} -> 
          send sender, "Received: '#{msg}'. Thank you!"
      end
    end
end
  
  helloer_pid = spawn(Helloer, :hola, [])
  send helloer_pid,  {self, "Here's a message for you!"}
  
  receive do
    msg -> IO.puts msg
  end
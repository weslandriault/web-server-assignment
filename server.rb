require 'socket'                                    # Require socket from Ruby Standard Library (stdlib)

host = 'localhost'
port = 2000

server = TCPServer.open(host, port)                 # Socket to listen to defined host and port
puts "Server started on #{host}:#{port} ..."        # Output to stdout that server started

def read_request(client)
   lines = []

   while (line = client.gets)                        # Read the request and collect it until it's empty
       break if !line
       line = line.chomp
       break if line.empty?
       lines << line
   end

   return lines
end

def parse_file_name(request)
   parsed_file_name = request.first.gsub(/GET \//, '').gsub(/\ HTTP.*/, '')
end

def get_content_type(filename)
   if filename =~ /.css/
         content_type = "text/css"
   elsif filename =~ /.html/
      content_type = "text/html"
   else
      content_type = "text/plain"
   end
end

def redirect

end
   

loop do                                             # Server runs forever
   client = server.accept                            # Wait for a client to connect. Accept returns a TCPSocket
   # loop do
   #    line = client.gets
   #    break if !line
   #    line.chomp
   #    break if line.empty?
   #    lines << line.chomp
   # end

   # while (line = client.gets.chomp) && line && !line.chomp.empty? # Read the request and collect it until it's empty   
   #    lines << line.chomp
   # end

   request = read_request(client)
  
   puts request

   filename = parse_file_name(request)
   # if lines.first =~ %r{^GET /(.*) HTTP.*$}
   #    filename = $1 
   #    filename = "index.html" if filename == ""
   
   headers = []

   if filename == "" 
      filename = "index.html"
   end

   if File.exists?(filename)
      body = File.read(filename)
      headers << "HTTP/1.1 200 OK"
      content_type = get_content_type(filename)
      headers << "Content-Type = #{content_type}"

   else
      body = "Couldn't locate your file bro!!"
      headers << "HTTP/1.1 404 Not Found"
   end

   headers << "Content-Length: #{body.size}"
   headers << "Connection: close"
   headers = headers.join("\r\n")

   response = [headers, body].join("\r\n\r\n")

   client.print(response)
   client.close
end

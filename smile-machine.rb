#!/usr/bin/env ruby

require 'base64'
require 'json'

def measure(tag)
  start = Time.now.to_f
  result = yield
  puts("#{tag}: #{Time.now.to_f - start}s")

  result
end

def load_image
  `raspistill -w 320 -h 240 --nopreview -t 1 -o current.jpg`
  Base64.encode64(File.read('current.jpg'))
end

def format_request(image)
  <<-HEREDOC
  {
    "requests":
    [
      {
        "image":
        {
      "content": "#{image}"
        },
            
        "features":
        [
          {
            "type": "FACE_DETECTION",
            "maxResults": 1
          }
        ]
      }
    ]
  }
  HEREDOC
end

def store_request(request)
  File.open('request.json', 'w+') do |io|
    io.puts(request)
  end
end

def joy_likelihood
  apikey = File.read('/home/pi/google-api-key.txt').strip
  result = `curl -s -H "Content-Type: application/json" --data-binary @request.json "https://vision.googleapis.com/v1/images:annotate?key=#{apikey}"`
  File.write 'response.json', result
  responses = JSON.parse(result)["responses"]
  response = responses.first if responses
  annotations = response["faceAnnotations"] if response
  annotation = annotations.first if annotations
  annotation["joyLikelihood"] if annotation
end

def smile?(joy_likelihood)
  ['VERY_LIKELY', 'LIKELY'].include?(joy_likelihood)
end


def init_balloon_stabber
  `gpio -g mode 18 pwm`
  `gpio pwm-ms`
  `gpio pwmc 192`
  `gpio pwmr 2000`

  deactivate_stab
end

def stab_balloon_repeatedly
  4.times do
    activate_stab
    sleep 0.2

    deactivate_stab
    sleep 0.2
  end
end

def activate_stab
  `gpio -g pwm 18 150`
end

def deactivate_stab
  `gpio -g pwm 18 100`
end


init_balloon_stabber

while true
  store_request(format_request(load_image))

  begin
    joy = joy_likelihood
    puts "joy: #{joy}, smile: #{smile?(joy)}"
  rescue StandardError => e
    puts "Error: #{e}"
    puts e.backtrace
  end

  if smile?(joy)
    stab_balloon_repeatedly
  end
end


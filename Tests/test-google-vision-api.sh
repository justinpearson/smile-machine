#!/bin/bash

read -p "This test verifies that we can send pictures to the Google Vision API 
and have it send back a JSON response that classifies the \"joyLikelihood\" in the picture.
Note that it assumes you have the API key in /home/pi/google-api-key.txt.
Press enter to continue."

cat > request.json << EOF
{"requests":[{
  "image":{"content": "$(base64 -w 0 from-raspi-cam.JPG)"},
  "features":[{"type": "FACE_DETECTION","maxResults": 1}]
}]}
EOF

echo "Sending base64-encoded image to Google Vision API..."

rm -f response.json

curl -s -H "Content-Type: application/json" -o response.json --data-binary @request.json "https://vision.googleapis.com/v1/images:annotate?key=$(cat /home/pi/google-api-key.txt)"

echo "Now check out response.json. There should be a line like 
    \"joyLikelihood\": \"VERY_LIKELY\"
somewhere in this response.    
"
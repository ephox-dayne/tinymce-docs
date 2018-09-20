#! /bin/sh

outDir=/tmp/codepens
mkdir -p $outDir

findPens() {
  find . -name \*.md -or -name \*.html | while read filename; do
    cat $filename | grep "codepen.html" | sed -E 's/.*id=\"([0-9a-zA-Z]+)\"+.*/\1/g' | while read penid; do
      echo $filename $penid
    done
  done
}

downloadZip() {
  penId=$1

  # This URL has a cookie in it from a browser session. It probably won't work by the time you get it.
  # To get the updated URL:
  # - log in to codepen
  # - open a new tab
  # - open network tools
  # - open https://codepen.io/tinymce/share/zip/XPxYjr/
  # - copy as curl
  # - replace XPxYjr with $penId

  outZip="$outDir/$penId.zip"
  curl "https://codepen.io/tinymce/share/zip/$penId/" -H 'User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Cookie: __cfduid=d5c8b0f72d32ce18deb28e8df40f662be1536235517; ahoy_visitor=45e35eed-8876-4547-8997-2eb41f74496d; codepen_session=RmNVUkFNZkx6YlUwQUlERXdLdUJXNHJQZ2ZJVkVNb1R1MEtqRUkwWkhLb2RYTDM4VFB0Y21FeTd0OHAwd2Q4WUdDZlRWci9zNm8zVG1uNGhXTUJDckxNQ1RtaE96RHhZNDZ4cms4M1pwSW50eUMvNjR5emQzcmZuN0kva0I1eDZjSjRlcXBLTGc4N2p2eGI2T3NWVDJjdEdYdkFoN1JDTW1nTThVS0t0cElsZU5wRURKWCs3bjZ4WkNISFZ6ZVFHaDJXYnVWWlJVODcvb2RqT3VjNTN3OGhpblVrSi9UL2IzbVJpay9VOXVaUkhWY0d4RkVidGYvdCs1cTZhS0Z1YjNKdHRMY3RpcDM4Tm9zd09vV09MbFE9PS0tcXlmSGVPNHVhVmJoQ1J4c2ZNS1RGUT09--a96b287ad895c035e76a417d1f9a3992e5853b8f; ahoy_visit=8001bc89-d89c-40f7-877f-d07508c7c04f; screen_width=3200' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' --output "$outZip"


  outPenDir="_includes/codepens/$penId"
  mkdir -p "$outPenDir"
  unzip -n "$outZip" -x license.txt README.txt -d "$outPenDir"
}

downloadPens() {
  findPens | while read docId penId; do
    downloadZip $penId
  done
}


downloadPens
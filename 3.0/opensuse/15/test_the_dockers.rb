%w(15.3 15.4 15.5 15.6).each do |version|
  puts version
  dockerfile=File.read("Dockerfile").each_line.to_a
  dockerfile[0]="FROM opensuse/leap:#{version}\n"
  File.open("Dockerfile", "wt") do |f|
    f.puts dockerfile.join
  end

  %x(
    docker build . --platform linux/amd64 -t localsuse
    printf "opensuse/leap version: %s " #{version} >> output.txt
    docker run --platform linux/amd64 -it localsuse ruby -e 'require "openssl"'
    if [ $? -eq 0 ]
    then
      echo "PASS" >> output.txt
    else
      echo "FAIL" >> output.txt
    fi
  )
end


$DockerOS = docker version -f "{{ .Server.Os }}"
write-host DockerOs:$DockerOS 
%{ if length(ssh_keys) > 0 ~}
ssh_authorized_keys:
%{ for keys in ssh_keys ~}
- ${keys}
%{ endfor ~}
%{ endif ~}

k3os:
%{ if length(data_sources) > 0 ~}
  data_sources:
%{ for sources in data_sources ~}
  - ${sources}
%{ endfor ~}
%{ endif ~}
%{ if length(kernel_modules) > 0 ~}
  modules:
%{ for module in kernel_modules ~}
  - ${module}
%{ endfor ~}
%{ endif ~}
%{ if length(sysctls) > 0 ~}
  sysctl:
%{ for sysctl in sysctls ~}
    ${sysctl}
%{ endfor ~}
%{ endif ~}
%{ if length(dns_nameservers) > 0 ~}
  dns_nameservers:
%{ for dns in dns_nameservers ~}
  - ${dns}
%{ endfor ~}
%{ endif ~}
%{ if length(ntp_servers) > 0 ~}
  ntp_servers:
%{ for ntp in ntp_servers ~}
  - ${ntp}
%{ endfor ~}
%{ endif ~}
  server_url: https://${k3s_server_ip}:6443
  token: ${k3s_cluster_secret}

atchbox_http_endpoint = "http://{{ groups.jupyterhub[0] }}:8080"
matchbox_rpc_endpoint = "{{ groups.jupyterhub[0] }}:8081"
ssh_authorized_key = "{{ ssh_public_key }}"
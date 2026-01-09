#/bin/bash
PUBLIC_IP=$(yc vpc address create --external-ipv4 zone=ru-central1-a --deletion-protection --format json | jq -r '. | .external_ipv4_address | .address')
SUBNET_ID=e9bob6nrd5t4rleaqulj
yc compute instance create \
 --name microtik-gw \
 --description "MicroTik CHR IPsec ikev2 firewall instance" \
 --zone ru-central1-a \
 --ssh-key /home/gipopo_admin/.ssh/microtik_gw_key.pub \
 --create-boot-disk name=microtic-gw-disk,size=20,type=network-ssd,family-id=mikrotik-chr,auto-delete=1 \
 --network-interface subnet-id=$SUBNET_ID,nat-address=$PUBLIC_IP \
 --memory 2 \
 --cores 2 \
 --core-fraction 5

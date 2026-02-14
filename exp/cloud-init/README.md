```bash
virt-install \
  --memory 2048 --noreboot \
  --os-variant detect=on \
  --cloud-init user-data="$(pwd)/data/user-data,meta-data=$(pwd)/data/meta-data,network-config=$(pwd)/data/network-config" \
  --disk=size=10,backing_store="$(pwd)/debian" \
  --name debian-001
```
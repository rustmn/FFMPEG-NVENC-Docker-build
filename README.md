#### Hardware accelerated AV1 encoding (av1_nvenc) requires an Ada Lovelace Architecture GPU (nvidia L40 for datacenters not included in this list but has required architecture): https://developer.nvidia.com/video-encode-and-decode-gpu-support-matrix-new

1. Download and install CUDA: https://developer.nvidia.com/cuda-downloads  
  Note: There will be prompt during installation asking about installable components, select Driver there besides default selected components.

2. Install Nvidia Container Toolkit: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#install-guide  
  Note: in Ubuntu apt may not be able to find repository for nvidia-container-toolkit-base, if so setup repository manually:
	```
	distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
  	```

3. Install Docker.

4. Build image.

5. Run container: `sudo docker run --runtime=nvidia --gpus all -e NVIDIA_DRIVER_CAPABILITIES=video,compute,utility <IMAGE_NAME> <COMMAND>`
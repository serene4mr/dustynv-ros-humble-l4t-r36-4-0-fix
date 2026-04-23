# dustynv-ros-humble-l4t-r36-x-x-fix

Temporary bridge image that patches ROS 2 apt repository signing for Jetson L4T R36 Humble images.

This image refreshes the ROS apt keyring and rewrites `ros2.list` using `signed-by` to fix:

- `EXPKEYSIG F42ED6FBAB17C654 Open Robotics`
- OpenCV package conflicts with downstream Ubuntu `libopencv-*-dev` installs (by removing prebundled `opencv-*` packages)
- pip index/mirror issues in downstream builds (by setting `/etc/pip.conf` to use `https://pypi.org/simple`)
- inherited pip environment overrides from upstream image (by setting `PIP_INDEX_URL`, clearing `PIP_EXTRA_INDEX_URL`, and clearing `PIP_TRUSTED_HOST`)
- distutils-managed Python package conflicts during downstream pip installs (by removing distro `python3-sympy`/`python3-mpmath`)

## Build

Build for `dustynv/ros:humble-desktop-l4t-r36.4.0`:

```bash
docker build \
  --build-arg BASE_IMAGE=dustynv/ros:humble-desktop-l4t-r36.4.0 \
  -t ghcr.io/serene4mr/ros:humble-desktop-l4t-r36.4.0-fix .
```

Build for `dustynv/ros:humble-ros-core-l4t-r36.2.0`:

```bash
docker build \
  --build-arg BASE_IMAGE=dustynv/ros:humble-ros-core-l4t-r36.2.0 \
  -t ghcr.io/serene4mr/ros:humble-ros-core-l4t-r36.2.0-fix .
```

## Verify

```bash
docker run --rm ghcr.io/serene4mr/ros:humble-desktop-l4t-r36.4.0-fix bash -lc 'apt-get update && echo OK'
docker run --rm ghcr.io/serene4mr/ros:humble-ros-core-l4t-r36.2.0-fix bash -lc 'apt-get update && echo OK'
```

## Use downstream

Set your ARM64 base image to one of:

- `ghcr.io/serene4mr/ros:humble-desktop-l4t-r36.4.0-fix`
- `ghcr.io/serene4mr/ros:humble-ros-core-l4t-r36.2.0-fix`

## Notes

- This is a temporary compatibility image.
- Remove/retire once upstream base images include a valid ROS apt key setup.

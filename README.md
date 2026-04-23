# dustynv-ros-humble-l4t-r36-4-0-fix

Temporary bridge image that patches ROS 2 apt repository signing on top of:

- `dustynv/ros:humble-ros-base-l4t-r36.4.0`

This image refreshes the ROS apt keyring and rewrites `ros2.list` using `signed-by` to fix:

- `EXPKEYSIG F42ED6FBAB17C654 Open Robotics`

## Build

```bash
docker build -t ghcr.io/serene4mr/ros:humble-ros-base-l4t-r36.4.0-fix .
```

## Verify

```bash
docker run --rm ghcr.io/serene4mr/ros:humble-ros-base-l4t-r36.4.0-fix bash -lc 'apt-get update && echo OK'
```

## Use downstream

Set your ARM64 base image to:

- `ghcr.io/serene4mr/ros:humble-ros-base-l4t-r36.4.0-fix`

## Notes

- This is a temporary compatibility image.
- Remove/retire once upstream base images include a valid ROS apt key setup.

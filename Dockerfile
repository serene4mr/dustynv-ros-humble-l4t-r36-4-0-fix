ARG BASE_IMAGE=dustynv/ros:humble-desktop-l4t-r36.4.0
FROM ${BASE_IMAGE}
ARG ROS_DISTRO=humble

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV PIP_INDEX_URL=https://pypi.org/simple \
    PIP_EXTRA_INDEX_URL= \
    PIP_TRUSTED_HOST=
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

RUN rm -f /etc/apt/sources.list.d/ros*.list /etc/apt/sources.list.d/*ros* || true \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg2 \
    lsb-release \
    python3-pip \
    python3-venv \
 && curl -fsSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
    | gpg --batch --yes --dearmor -o /usr/share/keyrings/ros-archive-keyring.gpg \
 && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo ${UBUNTU_CODENAME}) main" \
    > /etc/apt/sources.list.d/ros2.list \
 && apt-get update \
 && python3 -m pip install --no-cache-dir colcon-mixin \
 && colcon mixin add default https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml || true \
 && colcon mixin update default || true \
 && (opencv_pkgs="$(dpkg-query -W -f='${Package}\n' '*opencv*' 2>/dev/null || true)" \
    && if [ -n "${opencv_pkgs}" ]; then DEBIAN_FRONTEND=noninteractive apt-get purge -y ${opencv_pkgs}; fi \
    && DEBIAN_FRONTEND=noninteractive apt-get purge -y python3-sympy python3-mpmath || true) \
 && rm -rf /usr/local/lib/python3.10/dist-packages/cv2 /usr/lib/python3.10/dist-packages/cv2 \
 && apt-get -y autoremove \
 && printf "[global]\nindex-url = https://pypi.org/simple\n" > /etc/pip.conf \
 && echo '[ -f /opt/ros/'"${ROS_DISTRO}"'/setup.bash ] && source /opt/ros/'"${ROS_DISTRO}"'/setup.bash || source /opt/ros/'"${ROS_DISTRO}"'/install/setup.bash' >> /root/.bashrc \
 && rm -rf /var/lib/apt/lists/*
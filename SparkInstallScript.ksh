#!/bin/bash

# This script installs Apache Spark on a Linux system.

# Define Spark and Hadoop versions
SPARK_VERSION="4.0.1"
HADOOP_VERSION="3"
SPARK_PACKAGE="spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}"
SPARK_TGZ="${SPARK_PACKAGE}.tgz"
DOWNLOAD_URL="https://downloads.apache.org/spark/spark-${SPARK_VERSION}/${SPARK_TGZ}"

# Step 1: Download Apache Spark
echo "Downloading Apache Spark ${SPARK_VERSION}..."
wget -q --show-progress "${DOWNLOAD_URL}"
if [ $? -ne 0 ]; then
    echo "Error: Failed to download Spark. Please check the URL and your internet connection."
    exit 1
fi

# Step 2: Extract the archive
echo "Extracting ${SPARK_TGZ}..."
tar -xzf "${SPARK_TGZ}"
if [ $? -ne 0 ]; then
    echo "Error: Failed to extract Spark archive."
    rm "${SPARK_TGZ}"
    exit 1
fi

# Step 3: Move Spark to a standard location
echo "Moving Spark to /opt/spark..."
sudo mv "${SPARK_PACKAGE}" /opt/spark
if [ $? -ne 0 ]; then
    echo "Error: Failed to move Spark directory. Check permissions."
    rm -rf "${SPARK_PACKAGE}" "${SPARK_TGZ}"
    exit 1
fi

# Step 4: Set up environment variables for all users
echo "Setting up environment variables..."
PROFILE_FILE="/etc/profile.d/spark.sh"
sudo bash -c "cat > ${PROFILE_FILE}" <<EOF
export SPARK_HOME=/opt/spark
export PATH=\$PATH:\$SPARK_HOME/bin:\$SPARK_HOME/sbin
EOF

# Step 5: Clean up the downloaded archive
echo "Cleaning up..."
rm "${SPARK_TGZ}"

echo "Apache Spark installation completed successfully."
echo "Please run 'source /etc/profile.d/spark.sh' or log out and log back in to apply the changes."
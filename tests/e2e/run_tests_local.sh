#!/bin/bash
CUR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

OPERATOR_VERSION="${OPERATOR_VERSION:-"dev"}"
OPERATOR_DOCKER_REPO="${OPERATOR_DOCKER_REPO:-"altinity/clickhouse-operator"}"
OPERATOR_IMAGE="${OPERATOR_IMAGE:-"${OPERATOR_DOCKER_REPO}:${OPERATOR_VERSION}"}"
METRICS_EXPORTER_DOCKER_REPO="${METRICS_EXPORTER_DOCKER_REPO:-"altinity/metrics-exporter"}"
METRICS_EXPORTER_IMAGE="${METRICS_EXPORTER_IMAGE:-"${METRICS_EXPORTER_DOCKER_REPO}:${OPERATOR_VERSION}"}"
IMAGE_PULL_POLICY="${IMAGE_PULL_POLICY:-"IfNotPresent"}"
OPERATOR_NAMESPACE="${OPERATOR_NAMESPACE:-"test"}"
OPERATOR_INSTALL="${OPERATOR_INSTALL:-"yes"}"
ONLY="${ONLY:-"*"}"

# replace | apply
KUBECTL_MODE="${KUBECTL_MODE:-"replace"}"

EXECUTABLE="${EXECUTABLE:-"run_tests_operator.sh"}"
# EXECUTABLE="run_tests_metrics.sh" ./run_tests_local.sh
#EXECUTABLE="${EXECUTABLE:-"run_tests_metrics.sh"}"


echo "Build" && \
${CUR_DIR}/../../dev/image_build_all_dev.sh && \
echo "Load images" && \
minikube image load "${OPERATOR_IMAGE}" && \
minikube image load "${METRICS_EXPORTER_IMAGE}" && \
echo "Images prepared" && \
OPERATOR_DOCKER_REPO="${OPERATOR_DOCKER_REPO}" \
METRICS_EXPORTER_DOCKER_REPO="${METRICS_EXPORTER_DOCKER_REPO}" \
OPERATOR_VERSION="${OPERATOR_VERSION}" \
IMAGE_PULL_POLICY="${IMAGE_PULL_POLICY}" \
OPERATOR_NAMESPACE="${OPERATOR_NAMESPACE}" \
OPERATOR_INSTALL="${OPERATOR_INSTALL}" \
ONLY="${ONLY}" \
KUBECTL_MODE="${KUBECTL_MODE}" \
"${CUR_DIR}/${EXECUTABLE}"

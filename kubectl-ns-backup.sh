for ns in $(kubectl get ns --no-headers | cut -d " " -f1); do
  if { [ "$ns" != "kube-system" ]; }; then
  kubectl --namespace="${ns}" get --export -o=json svc,rc,rs,deployments,cm,secrets,ds,petsets | \
jq '.items[] |
    select(.type!="kubernetes.io/service-account-token") |
    del(
        .spec.clusterIP,
        .metadata.uid,
        .metadata.selfLink,
        .metadata.resourceVersion,
        .metadata.creationTimestamp,
        .metadata.generation,
        .status,
        .spec.template.spec.securityContext,
        .spec.template.spec.dnsPolicy,
        .spec.template.spec.terminationGracePeriodSeconds,
        .spec.template.spec.restartPolicy
    )' >> "./my-cluster.json"
  fi
done

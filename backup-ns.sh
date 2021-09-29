//snapshot.storage.k8s.io/v1alpha1
//snapshot.storage.k8s.io/v1beta1

#!/usr/bin/bash

SECRET=$(kubectl get sc -o=jsonpath='{.items[?(@.metadata.annotations.storageclass\.kubernetes\.io\/is-default-class=="true")].parameters.csi\.storage\.k8s\.io\/provisioner-secret-name}') 
DRIVER=$(kubectl get sc -o=jsonpath='{.items[?(@.metadata.annotations.storageclass\.kubernetes\.io\/is-default-class=="true")].provisioner}') 

cat <<EOF | kubectl apply -f - 
apiVersion: snapshot.storage.k8s.io/v1beta1 
kind: VolumeSnapshotClass 
metadata: 
   name: default-snapshotclass 
driver: csi.nutanix.com 
parameters: 
   storageType: NutanixVolumes 
   csi.storage.k8s.io/snapshotter-secret-name: $SECRET 
   csi.storage.k8s.io/snapshotter-secret-namespace: kube-system 
deletionPolicy: Delete 
EOF

import os
import sys
import argparse
import boto3

def get_clusters(ecs):
    paginator = ecs.get_paginator('list_clusters')
    cluster_arns = []
    for page in paginator.paginate():
        cluster_arns.extend(page.get('clusterArns', []))
    return cluster_arns

def main():
    parser = argparse.ArgumentParser(description="Manage Dynatrace OneAgent on ECS Clusters")
    parser.add_argument('--observe', action='store_true', help="Collect clusters and observe OneAgent status (installed / not installed)")
    parser.add_argument('--install', action='store_true', help="Install OneAgent in clusters who don't have it")
    parser.add_argument('--cluster', help="Specify a target ECS cluster name to restrict action to")
    args = parser.parse_args()

    ecs = boto3.client('ecs')
    
    environment = os.environ.get('ENVIRONMENT', 'production')
    oneagent_arn = os.environ.get('ONEAGENT_TASK_DEFINITION_ARN')
    service_name = f"dynatrace-oneagent-{environment}"

    # Retrieve and parse monitored clusters whitelist
    monitored_clusters_raw = os.environ.get('MONITORED_CLUSTERS', '*')
    monitored_clusters = [c.strip() for c in monitored_clusters_raw.split(',') if c.strip()]

    if args.observe:
        print("=== [STAGE] COLLECTING CLUSTERS & OBSERVING INSTALLED STATUS ===")
        try:
            cluster_arns = get_clusters(ecs)
            print(f"[INFO] Scanning {len(cluster_arns)} ECS cluster(s).\n")
        except Exception as e:
            print(f"[ERROR] Failed to obtain ECS clusters: {e}")
            sys.exit(1)

        for cluster_arn in cluster_arns:
            cluster_name = cluster_arn.split('/')[-1]
            if args.cluster and cluster_name != args.cluster:
                continue
            
            # Check whitelist matching
            if '*' not in monitored_clusters and cluster_name not in monitored_clusters:
                print(f"[SKIP] Cluster '{cluster_name}' is not in MONITORED_CLUSTERS whitelist.")
                continue

            try:
                srv_paginator = ecs.get_paginator('list_services')
                service_arns = []
                for srv_page in srv_paginator.paginate(cluster=cluster_arn):
                    service_arns.extend(srv_page.get('serviceArns', []))
                
                has_oneagent = any(arn.split('/')[-1] == service_name for arn in service_arns)
                if has_oneagent:
                    print(f"[*] Cluster Name: '{cluster_name}' -> STATUS: Dynatrace OneAgent INSTALLED")
                else:
                    print(f"[*] Cluster Name: '{cluster_name}' -> STATUS: Dynatrace OneAgent NOT INSTALLED")
            except Exception as e:
                print(f"[ERROR] Failed to inspect cluster '{cluster_name}': {e}")

    elif args.install:
        print("=== [STAGE] INSTALLING ONEAGENT IN CLUSTERS LACKING IT ===")
        if not oneagent_arn:
            print("[ERROR] ONEAGENT_TASK_DEFINITION_ARN environment variable is missing.")
            sys.exit(1)

        try:
            cluster_arns = get_clusters(ecs)
        except Exception as e:
            print(f"[ERROR] Failed to obtain ECS clusters: {e}")
            sys.exit(1)

        for cluster_arn in cluster_arns:
            cluster_name = cluster_arn.split('/')[-1]
            if args.cluster and cluster_name != args.cluster:
                continue
            
            # Check whitelist matching
            if '*' not in monitored_clusters and cluster_name not in monitored_clusters:
                print(f"[SKIP] Cluster '{cluster_name}' is not in MONITORED_CLUSTERS whitelist.")
                continue
            try:
                srv_paginator = ecs.get_paginator('list_services')
                service_arns = []
                for srv_page in srv_paginator.paginate(cluster=cluster_arn):
                    service_arns.extend(srv_page.get('serviceArns', []))
                
                has_oneagent = any(arn.split('/')[-1] == service_name for arn in service_arns)
                if not has_oneagent:
                    print(f"[ACTION] Cluster '{cluster_name}' lacks OneAgent. Installing...")
                    ecs.create_service(
                        cluster=cluster_arn,
                        serviceName=service_name,
                        taskDefinition=oneagent_arn,
                        schedulingStrategy='DAEMON',
                        launchType='EC2'
                    )
                    print(f"[SUCCESS] Scheduled Dynatrace OneAgent daemon service on cluster '{cluster_name}'")
                else:
                    print(f"[SKIP] Cluster '{cluster_name}' already has OneAgent. Skipping installation.")
            except Exception as e:
                print(f"[ERROR] Failed to deploy on cluster '{cluster_name}': {e}")

    else:
        parser.print_help()

if __name__ == '__main__':
    main()

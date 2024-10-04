output "instance_ips" {
  description = "The public IPs of the compute instances"
  value       = google_compute_instance.app_instance[*].network_interface[0].access_config[0].nat_ip
}

output "bucket_name" {
  description = "The name of the cloud storage bucket"
  value       = google_storage_bucket.my_bucket.name
}

output "sql_instance_connection_name" {
  description = "The connection name of the Cloud SQL instance"
  value       = google_sql_database_instance.my_sql_instance.connection_name
}

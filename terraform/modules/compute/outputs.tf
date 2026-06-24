output "alb_dns_name" { value = aws_lb.main.dns_name }
output "cluster_name" { value = aws_ecs_cluster.main.name }

output "tg_transaction_arn" { value = aws_lb_target_group.transaction.arn }
output "tg_fraud_arn"       { value = aws_lb_target_group.fraud.arn }
output "tg_wallet_arn"      { value = aws_lb_target_group.wallet.arn }
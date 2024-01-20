resource "aws_route53_zone" "private" {
  name = var.private_domain_name

  vpc {
    vpc_id = aws_vpc.vpc.id
  }
}

resource "aws_route53_record" "app_server" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "app.${var.private_domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.app_server.private_ip]
}

resource "aws_route53_record" "db" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "db.${var.private_domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.db.private_ip]
}

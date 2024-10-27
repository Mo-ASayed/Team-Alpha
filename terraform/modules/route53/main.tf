data "aws_route53_zone" "tm_lab_zone" {
  name = var.zone_name
}

resource "aws_route53_record" "tm_alias_record" {
  zone_id = data.aws_route53_zone.tm_lab_zone.id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = false
  }

}


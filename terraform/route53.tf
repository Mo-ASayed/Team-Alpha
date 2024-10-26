# route53
data "aws_route53_zone" "lab_zone" {
  name = "tm.teamalpha.abdelhakimyusuf.net"
}
resource "aws_route53_record" "tm_alias_record" {
  zone_id = data.aws_route53_zone.lab_zone.id  
  name    = "tm.teamalpha.abdelhakimyusuf.net"
  type    = "A"
  alias {
    name                   = aws_lb.tm_lb.dns_name  
    zone_id                = aws_lb.tm_lb.zone_id   
    evaluate_target_health = false
  }
}
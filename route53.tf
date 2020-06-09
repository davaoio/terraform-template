resource "aws_route53_zone" "example" {
  name = "example"
}

output "name_servers_example" {
  value = "${aws_route53_zone.example.name_servers}"
}

/*
resource "aws_route53_record" "googleauth" {
  zone_id = aws_route53_zone.example.zone_id
  name    = ""
  type    = "TXT"

  records = ["google-site-verification=123...xyz"]

  ttl = "3600"
}

resource "aws_route53_record" "gmail" {
  zone_id = aws_route53_zone.example.zone_id
  name    = ""
  type    = "MX"
  records = [
    "1 ASPMX.L.GOOGLE.COM",
    "5 ALT1.ASPMX.L.GOOGLE.COM",
    "5 ALT2.ASPMX.L.GOOGLE.COM",
    "10 ALT3.ASPMX.L.GOOGLE.COM",
    "10 ALT4.ASPMX.L.GOOGLE.COM"
  ]
  ttl = "3600"

}

resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.example.zone_id
  name    = "www"
  type    = "CNAME"

  records = [
    "www.google.com"
  ]

  ttl = "3600"
}

*/
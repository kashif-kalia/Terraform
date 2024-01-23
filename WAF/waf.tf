****TO Create a Terraform Code For WebApplicationFirewall ON IP Based And Geometry Based.*****

# Create an IPSet for the specified IP address range
resource "aws_wafv2_ip_set" "ipset" {
  name        = "ipset"
  description = "IP Set to allow specific IP address"
  scope       = "REGIONAL" 
  ip_address_version = "IPV4"
  addresses = [
    "122.161.50.7/32"   # office ip
    # Add more IP addresses as needed by adding coma[,]
  ]
}

# Create a Web ACL with IPSet and GeoMatch rules
resource "aws_wafv2_web_acl" "waf" {
  name        = "waf"
  description = "WAF ACL for CloudFront"
  scope       = "REGIONAL"  

  default_action {
    block {}  
  }

  rule {
    name     = "ipset"
    priority = 1

    action {
      allow {}  
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ipset.arn  
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "WAFMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AllowUKRule"
    priority = 2

    action {
      allow {}  
    }

    statement {
      geo_match_statement {
        country_codes = ["GB"] 
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "WAFMetric"
      sampled_requests_enabled   = true
    }

  }
  
visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "WAFMetric"
      sampled_requests_enabled   = true
    }
 tags = {
  owner       = var.owner
  project     = var.project
  environment = var.environment
  resource    = "waf"
  }

}

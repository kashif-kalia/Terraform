**** WebApplicationFirewall based on Regional****

resource "aws_wafv2_rule_group" "waf" {
  capacity = 10
  name     = "waf"
  scope    = "REGIONAL"

  rule {
    name     = "rule-1"
    priority = 1

    action {
      count {}
    }

    statement {
      geo_match_statement {   
        country_codes = ["GB"]   
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "UK-metric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "rule-to-exclude-a"
    priority = 10

    action {
      allow {}
    }

    statement {
      geo_match_statement {
        country_codes = ["IN"]
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "India-metrics"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "metrics"
    sampled_requests_enabled   = true
  }

  tags = {
  owner       = var.owner
  project     = var.project
  environment = var.environment
  resource    = "waf"
  }
}




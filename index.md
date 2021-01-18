---
---

{% assign past_launches = site.data.launches | where: "upcoming", "false" | sort: "date_unix" %}
{% assign upcoming = site.data.launches | where: "upcoming", "true" | sort: 'flight_number' %}
{% assign last_launch = past_launches | sort: "flight_number" | last %}

## Last

{% assign launchpad = site.data.launchpads | where: "id", last_launch.launchpad | first %}
{% include spx/last_launch.html %}

## Upcoming

{% include spx/upcoming_launches.html %}

## Data

<div markdown=1 style="display:flex;">
{% assign difference = site.data.launches.size | minus: past_launches.size %}
| Launches | |
|:---|---:|
| Past | {{ past_launches.size }} |
| Upcoming | {{ upcoming.size }}{% if upcoming.size != difference %}*{% endif %} |
{: style="min-width:12em;margin-right:1em"}

{% assign failures = site.data.launches | where: "success", "false" %}
{% assign rockets = site.data.rockets | sort: "success_rate_pct" %}
| Success | | % |
|:---|---:|---:|{% for r in rockets reversed %}{% assign past_launches_rocket = past_launches | where: "rocket", r.id %}{% if past_launches_rocket.size == 0 %}{% assign past_launches_rocket = "" | split: "" | push: "1" %}{% endif %}
| {{ r.name }} | {{ past_launches | where: "rocket", r.id | group_by: "success" | where: "name", "true" | map: "items" | first | size }}-{{ past_launches | where: "rocket", r.id | group_by: "success" | where: "name", "false" | map: "items" | first | size }} | {{ past_launches | where: "rocket", r.id | group_by: "success" | where: "name", "true" | map: "items" | first | size | times: 100 | divided_by: past_launches_rocket.size }} |{% endfor %}
|----
| Total | {{ past_launches | where: "success", "true" | size }}-{{ failures.size }} | {{ past_launches | where: "success", "true" | size | times: 100 | divided_by: past_launches.size }} | 
{: style="min-width:12em;margin-right:1em"}

{% assign landpads = site.data.landpads | sort: "landing_attempts" %}
{% assign landing_attempts = 0 %}
{% assign landing_successes = 0 %}
| Landings | |
|:---|---:|{% for l in landpads reversed %}{% assign landing_successes = landing_successes | plus: l.landing_successes %}{% assign landing_attempts = landing_attempts | plus: l.landing_attempts %}
| <span title="{{ l.full_name }}">{{ l.name }}</span> | {{ l.landing_successes }}-{{ l.landing_attempts | minus: l.landing_successes }} |{% endfor %}
|----
| Total | {{ landing_successes }}-{{ landing_attempts | minus: landing_successes }} |
{: style="min-width:12em;margin-right:1em"}

| Data | |
|:---|---:|
| Payloads | {{ site.data.payloads.size }} |
| Launches | {{ site.data.launches.size }} |
| Cores | {{ site.data.cores.size }} |
| Capsules | {{ site.data.capsules.size }} |
| Landpads | {{ site.data.landpads.size }} |
| Launchpads | {{ site.data.launchpads.size }} |
| Rockets | {{ site.data.rockets.size }} |
| Dragons | {{ site.data.dragons.size }} |
|----
| Total | {{ site.data.payloads.size | plus: site.data.launches.size | plus: site.data.cores.size | plus: site.data.capsules.size | plus: site.data.landpads.size | plus: site.data.launchpads.size | plus: site.data.rockets.size | plus: site.data.dragons.size }}
{: style="min-width:12em;margin-right:1em"}
</div>
---
---

{% assign past_launches = site.data.launches | where: "upcoming", "false" %}
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
{% assign failures = site.data.launches | where: "success", "false" %}
| Launches | |
|---|---:|
| Past | {{ past_launches.size }} |
| Upcoming | {{ upcoming.size }}{% if upcoming.size != difference %}*{% endif %} |
| Failures | {{ failures.size }} |
{: style="min-width:12em;margin-right:1em"}

| Success | |
|---|---:|{% for r in site.data.rockets %}
| {{ r.name }} | {{ past_launches | where: "rocket", r.id | group_by: "success" | where: "name", "true" | map:"items" | first | size }}-{{ past_launches | where: "rocket", r.id | group_by: "success" | where: "name", "false" | map:"items" | first | size }} |{% endfor %}
{: style="min-width:12em;margin-right:1em"}

| Data | |
|---|---:|
| Payloads | {{ site.data.payloads.size }} |
| Cores | {{ site.data.cores.size }} |
| Capsules | {{ site.data.capsules.size }} |
| Landpads | {{ site.data.landpads.size }} |
| Launchpads | {{ site.data.launchpads.size }} |
| Rockets | {{ site.data.rockets.size }} |
| Dragons | {{ site.data.dragons.size }} |
{: style="min-width:12em;margin-right:1em"}
</div>
---
---

{% assign past_launches = site.data.launches | where: "upcoming", "false" | sort: "date_unix" %}
{% assign upcoming = site.data.launches | where: "upcoming", "true" | sort: 'flight_number' %}
{% assign last_launch = past_launches | sort: "flight_number" | last %}

**Last**

{% include spx/last_launch.html %}

**Upcoming**

{% include spx/upcoming_launches.html %}

**Data**

<div markdown=1 style="justify-content: right;" class="flex">
<div markdown=1>
{% comment %} -------------------- MISSIONS -------------------- {% endcomment %}
{% assign difference = site.data.launches.size | minus: past_launches.size %}
| Missions | |
|:---|---:|
| Past | {{ past_launches.size }} |
| Upcoming | {{ upcoming.size }}{% if upcoming.size != difference %}*{% endif %} |
{: style="min-width:12em;margin-right:1em"}
{% comment %} -------------------- DATA -------------------- {% endcomment %}
| Data | |
|:---|---:|
| Payloads | {{ site.data.payloads.size }} |
| Launches | {{ site.data.launches.size }} |
| Cores | {{ site.data.cores.size }} |
| Crew | {{ site.data.crew.size }} |
| Capsules | {{ site.data.capsules.size }} |
| Landpads | {{ site.data.landpads.size }} |
| Launchpads | {{ site.data.launchpads.size }} |
| Rockets | {{ site.data.rockets.size }} |
| Dragons | {{ site.data.dragons.size }} |
|----
| Total | {{ site.data.payloads.size | plus: site.data.launches.size | plus: site.data.cores.size | plus: site.data.crew.size | plus: site.data.capsules.size | plus: site.data.landpads.size | plus: site.data.launchpads.size | plus: site.data.rockets.size | plus: site.data.dragons.size }}
{: style="min-width:12em;margin-right:1em"}
</div>
<div markdown=1>
{% assign cores_reuse = site.data.cores | group_by: "reuse_count" | sort: "name" %}
| Cores reuse | |
|:---|---:|{% for cr in cores_reuse %}
| Reused {{ cr.name }} times | {{ cr.items.size }} |{% endfor %}
|----
| Cores reused | {{ site.data.cores | where_exp: "item", "item.reuse_count > 0" | size }} |
{: style="min-width:12em;margin-right:1em"}
{% comment %} -------------------- CREWS -------------------- {% endcomment %}
{% assign crewed_launches = past_launches | where_exp: "item", "item.crew.size > 0" %}
| Crews | |
|:---|---:|
| Crewed launches | {% include spx/crewed_launches.html crewed_launches=crewed_launches %} |
| Astronauts | {% include spx/astronauts.html %} |
{: style="min-width:12em;margin-right:1em"}
</div>
<div markdown=1>
{% comment %} -------------------- LAUNCHES -------------------- {% endcomment %}
{% assign failures = site.data.launches | where: "success", "false" %}
{% assign rockets = site.data.rockets | sort: "success_rate_pct" %}
| Launches | | % |
|:---|---:|---:|{% for r in rockets reversed %}{% assign past_launches_rocket = past_launches | where: "rocket", r.id %}{% if past_launches_rocket.size == 0 %}{% assign past_launches_rocket = "" | split: "" | push: "1" %}{% endif %}
| <span {% if r.active != true %}class="fg-secondary" {% endif %}>{{ r.name }}</span> | {{ past_launches | where: "rocket", r.id | group_by: "success" | where: "name", "true" | map: "items" | first | size }} / {{ past_launches | where: "rocket", r.id | group_by: "success" | where: "name", "false" | map: "items" | first | size }} | {{ past_launches_rocket | group_by: "success" | where: "name", "true" | map: "items" | first | size | times: 100 | divided_by: past_launches_rocket.size }} |{% endfor %}
|----
| Total | {{ past_launches | where: "success", "true" | size }} / {{ failures.size }} | {{ past_launches | where: "success", "true" | size | times: 100 | divided_by: past_launches.size }} | 
{: style="min-width:15em;margin-right:1em"}
{% comment %} -------------------- LANDINGS -------------------- {% endcomment %}
{% assign landpads = site.data.landpads | sort: "landing_attempts" %}
{% assign landing_attempts = 0 %}
{% assign landing_successes = 0 %}
| Landings | | % |
|:---|---:|---:|{% for l in landpads reversed %}{% assign landing_successes = landing_successes | plus: l.landing_successes %}{% assign landing_attempts = landing_attempts | plus: l.landing_attempts %}{% assign attempts = l.landing_attempts %}{% if attempts == 0 %}{% assign attempts = 1 %}{% endif %}
| <span {% if l.status != "active" %}class="fg-secondary" {% endif %}title="{{ l.full_name }}">{{ l.name }}</span> | {{ l.landing_successes }} / {{ l.landing_attempts | minus: l.landing_successes }} | {{ l.landing_successes | times: 100 | divided_by: attempts }} |{% endfor %}
|----
| Total | {{ landing_successes }} / {{ landing_attempts | minus: landing_successes }} | {{ landing_successes | times: 100 | divided_by: landing_attempts }} |
{: style="min-width:15em;margin-right:1em"}
</div>
<div markdown=1>
{% comment %} -------------------- YEARS -------------------- {% endcomment %}
{% assign years = past_launches | group_by_exp: "item", "item.date_local | truncate: 4, ''" %}
| Year | &uarr; | Tons |
|:---|---:|---:|{% for y in years reversed %}{% assign kg = 0 %}{% for l in y.items %}{% for p in l.payloads %}{% assign payload = site.data.payloads | where: 'id', p %}{% assign kg = kg | plus: payload[0].mass_kg %}{% endfor %}{% endfor %}
| {{ y.name }} | {{ y.items.size }} | {{ kg | divided_by: 907.18474 | round: 1 }} |{% endfor %}
{: style="min-width:12em;margin-right:1em"}
</div>
</div>
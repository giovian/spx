---
---

{% assign past_launches = site.data.launches | where: "upcoming", "false" %}
{% assign upcoming = site.data.launches | where: "upcoming", "true" | sort: 'flight_number' %}
{% assign last_launch = past_launches | sort: "flight_number" | last %}

## Last

{% assign launchpad = site.data.launchpads | where: "id", last_launch.launchpad | first %}
<table>
  <thead>
    <tr style="text-align:left;">
      <th></th>
      <th></th>
      <th style="min-width: 9.75em">Name</th>
      <th style="min-width: 8em">Launch</th>
      <th>Datetime</th>
      <th style="min-width: 8em">From</th>
      <th style="min-width: 5em">To</th>
      <th style="min-width: 5em">Flight</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>{{ last_launch.flight_number }}</td>
      <td>{% include spx/rocket.html id=last_launch.rocket %}</td>
      <td title="{% include spx/payloads.html payloads=last_launch.payloads %}">{{ last_launch.name }}</td>
      <td>{% include widgets/datetime.html datetime=last_launch.date_unix replace=true %}</td>
      <td><code title="{{ last_launch.date_local | date: "%a %d %b %T" }}">{{ last_launch.date_unix | date: "%a %d %b %T" }}</code></td>
      <td title="{{ launchpad.launch_successes }}-{{ launchpad.launch_attempts | minus: launchpad.launch_successes }} launches">{{ launchpad.name }}</td>
      <td>{%- for core in last_launch.cores -%}
        {%- assign exp = "item.id == '" | append: core.landpad | append: "'" -%}
        {%- assign landpad = site.data.landpads | where_exp: "item", exp | first -%}
        <span title="{{ landpad.landing_successes }}-{{ landpad.landing_attempts | minus: landpad.landing_successes }} landings">{{ landpad.name }}{%- unless forloop.last -%} {%- endunless -%}</span>
      {%- endfor -%}</td>
      <td style="text-align:center;">{%- for core in last_launch.cores -%}{{ core.flight }}{%- unless forloop.last -%}&nbsp;{%- endunless -%}{%- endfor -%}</td>
    </tr>
  </tbody>
</table>

## Upcoming

<table>
  <thead>
    <tr style="text-align:left;">
      <th></th>
      <th></th>
      <th style="min-width: 9.75em">Name</th>
      <th style="min-width: 8em">T - minus</th>
      <th>Datetime</th>
      <th style="min-width: 8em">From</th>
      <th style="min-width: 5em">To</th>
      <th style="min-width: 5em">Flight</th>
    </tr>
  </thead>
  <tbody>
{%- for launch in upcoming -%}
{%- assign launchpad = site.data.launchpads | where: "id", launch.launchpad | first -%}
{% include spx/precision.html launch=launch %}
<tr class="{{ precision_class }}" apply-if-children="mode-opposite:.past">
  <td>{{ launch.flight_number }}</td>
  <td>{% include spx/rocket.html id=last_launch.rocket %}</td>
  <td title="{% include spx/payloads.html payloads=launch.payloads %}">{{ launch.name }}</td>
  <td>{{ datetime }}</td>
  <td><code title="{{ launch.date_local | date: "%a %d %b %T" }}">{{ launch.date_unix | date: "%a %d %b %T" }}</code></td>
  <td title="{{ launchpad.launch_successes }}-{{ launchpad.launch_attempts | minus: launchpad.launch_successes }} launches">{{ launchpad.name }}</td>
  <td>{%- for core in launch.cores -%}
    {%- assign exp = "item.id == '" | append: core.landpad | append: "'" -%}
    {%- assign landpad = site.data.landpads | where_exp: "item", exp | first -%}
    <span title="{{ landpad.landing_successes }}-{{ landpad.landing_attempts | minus: landpad.landing_successes }} landings">{{ landpad.name }}{%- unless forloop.last -%} {%- endunless -%}</span>
  {%- endfor -%}</td>
  <td style="text-align:center;">{%- for core in launch.cores -%}{{ core.flight }}{%- unless forloop.last -%}&nbsp;{%- endunless -%}{%- endfor -%}</td>
</tr>
{%- endfor -%}
  </tbody>
</table>

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
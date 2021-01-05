---
---

## Upcoming

{% assign upcoming = site.data.launches | where: "upcoming", "true" | sort: 'flight_number' %}
<table>
  <thead>
    <tr style="text-align:left;">
      <th></th>
      <th>Name</th>
      <th>T - minus</th>
      <th>Datetime</th>
      <th>From</th>
      <th>To</th>
      <th>Flight</th>
    </tr>
  </thead>
  <tbody>

{%- for launch in upcoming -%}
{%- assign launchpad = site.data.launchpads | where: "id", launch.launchpad | first -%}
{%- case launch.date_precision -%}
  {%- when 'hour' -%}
    {%- assign precision_class = '' -%}
    {%- capture datetime -%}{% include widgets/datetime.html datetime=launch.date_unix replace=true %}{%- endcapture -%}
  {%- when 'day' -%}
    {%- assign precision_class = 'color-green' -%}
    {%- assign datetime = launch.date_unix | date: '%B %e' -%}
  {%- when 'month' -%}
    {%- assign precision_class = 'color-blue' -%}
    {%- assign datetime = launch.date_unix | date: '%B' -%}
  {%- when 'quarter' -%}
    {%- assign precision_class = 'color-orange' -%}
    {%- assign month = launch.date_unix | date: '%m' | plus: 0 -%}
    {%- if month < 4  -%}{%- assign datetime = 'Q1' -%}
    {%- elsif month < 7 -%}{%- assign datetime = 'Q2' -%}
    {%- elsif month < 10 -%}{%- assign datetime = 'Q3' -%}
    {%- else -%}{%- assign datetime = 'Q4' -%}
    {%- endif -%}
  {%- when 'half' -%}
    {%- assign precision_class = 'color-red' -%}
    {%- assign month = launch.date_unix | date: '%m' | plus: 0 -%}
    {%- if month < 7  -%}{%- assign datetime = 'H1' -%}
    {%- else -%}{%- assign datetime = 'H2' -%}
    {%- endif -%}
  {%- else -%}
    {%- assign precision_class = '' -%}
    {%- assign datetime = launch.date_unix -%}
{%- endcase -%}
<tr class="{{ precision_class }}">
  <td>{{ launch.flight_number }}</td>
  <td>{{ launch.name }}</td>
  <td>{{ datetime }}</td>
  <td><code title="{{ launch.date_local | date: "%a %d %b %T" }}">{{ launch.date_unix | date: "%a %d %b %T" }}</code></td>
  <td title="{{ launchpad.launch_successes }}/{{ launchpad.launch_attempts }} launches">{{ launchpad.name }}</td>
  <td>{%- for core in launch.cores -%}
    {%- assign exp = "item.id == '" | append: core.landpad | append: "'" -%}
    {%- assign landpad = site.data.landpads | where_exp: "item", exp | first -%}
    <span title="{{ landpad.landing_successes }}/{{ landpad.landing_attempts }} landings">{{ landpad.name }}{%- unless forloop.last -%} {%- endunless -%}</span>
  {%- endfor -%}</td>
  <td style="text-align:center;">{%- for core in launch.cores -%}{{ core.flight }}{%- unless forloop.last -%}&nbsp;{%- endunless -%}{%- endfor -%}</td>
</tr>
{%- endfor -%}
  </tbody>
</table>

{% assign past_launches = site.data.launches | where: "upcoming", "false" | size %}
- Past launches {{ past_launches }} (remains {{ site.data.launches.size | minus: past_launches }})
- Upcoming launches {{ upcoming | size }}
- Cores {{ site.data.cores.size }}
- Launchpads {{ site.data.launchpads.size }}
- Landpads {{ site.data.landpads.size }}
- Payloads {{ site.data.payloads.size }}
- Capsules {{ site.data.capsules.size }}
- Dragons {{ site.data.dragons.size }}

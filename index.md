---
---
{% assign past_launches = site.data.launches | where_exp: "item", "item.upcoming == false" | size %}
- Past launches {{ past_launches }} (remains {{ site.data.launches.size | minus: past_launches }})
- Upcoming launches {{ site.data.launches | where_exp: "item", "item.upcoming == true" | size }}
- Cores {{ site.data.cores.size }}
- Launchpads {{ site.data.launchpads.size }}
- Landpads {{ site.data.landpads.size }}
- Payloads {{ site.data.payloads.size }}

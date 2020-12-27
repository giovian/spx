---
---
leading_0 = (number) -> "0#{number}".slice -2

$('html').addClass 'loading'
upcoming = $.get "https://api.spacexdata.com/v4/launches/upcoming"
upcoming.done (data, status) ->
  $('html').removeClass 'loading'
  parse_array = 'name,flight_number,date_precision,date_local'.split(',')
  for launch, index in data
    template = $ $("#template").clone().prop "content"
    for property in parse_array
      template.find("[data-launch='#{property}']").text launch[property]
    countdown_seconds = launch.date_unix - (new Date().getTime()/1000)
    countdown_days = ~~(countdown_seconds / (60*60*24))
    countdown_days_remainder = countdown_seconds % (60*60*24)
    countdown_hours = ~~(countdown_days_remainder / (60*60))
    countdown_hours_remainder = countdown_days_remainder % (60*60)
    countdown_minutes = ~~(countdown_hours_remainder / 60)
    template.find("[data-launch='countdown_days']").text countdown_days
    template.find("[data-launch='countdown_hours']").text leading_0(countdown_hours)
    template.find("[data-launch='countdown_minutes']").text leading_0(countdown_minutes)
    template.find(".local").text new Date(launch.date_unix*1000).toLocaleTimeString("it-IT",{ weekday: "short", day: "2-digit", month: "short", hour: '2-digit', minute: '2-digit' })
    template.find('[data-launch="cores[0].flight"]').text(launch.cores[0].flight || '-')
    template.find('[data-launch="cores[0].landing_type"]').text(launch.cores[0].landing_type || '-')
    template.find('article').addClass launch.date_precision
    template.find('.index').text index+1
    div = if (index < ((data.length)/2)) then "1" else "2"
    $(".grid div:nth-child(#{div})").append template
  return
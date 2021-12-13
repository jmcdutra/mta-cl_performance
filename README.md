# mta-cl_performance
cl_drawperf (Fivem) for MTA and resource monitoring

### cl_drawperf [input]
[1]: Performance similar ao FiveM, [2]: Performance de desenvolvedor (mais completa)
- Exemplo: /cl_drawperf 1

[Time: realTime], [FPS: currentFPS], [Ping: msPing], [CPU Usage (All resources)], [Memory Usage (All Resources)]
![Print_1](https://media.discordapp.net/attachments/740000568751292496/919760098635706459/unknown.png)

- Exemplo: /cl_drawperf 2

{Performance + dados} - TABLE

![Print_2](https://media.discordapp.net/attachments/740000568751292496/919760233126064148/unknown.png)

### res_perf [resource]

/res_perf [resource] -- Monitora um resource específico (CPU & Memory)
- Exemplo: /res_perf ajax

![Print_3](https://media.discordapp.net/attachments/740000568751292496/919764884336554014/unknown.png)

### get_perf
Copia a tabela com os dados e performance atual para o seu clipboard
- Exemplo: /get_perf

Retorno:
```lua
{
  localTime = "12/12/2021 - 22:40:04",
  localplayer = "Dutra",
  matrix = {
    dimension = 0,
    interior = 0,
    position = { "2116.53320", "-1218.29443", "23.80469" },
    rotation = { "-0.00000", "0.00000", "115.61491" }
  },
  perfomance = {
    fps = 100,
    ping = 139
  },
  resources = {
    cpu_usage = "6.27%",
    memory_usage = "9.80 MB's"
  }
}
```

### Out of memory

if you see

```
Process killed by signal: signal number 9
```

in the logs, that means the srb2kart service ran out of memory. Increase the memory limit in your docker setup, lower the amount of mods, or upgrade your system.

### Asking for help

If your server isn't running smoothly, share the output of

```bash
docker stats srb2kart
```


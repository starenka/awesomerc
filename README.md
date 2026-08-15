My config files & scripts for [Awesome](http://awesome.naquadah.org/)

- configure your battery settings via battery.settings.... in rc.lua (overrides defaults in battery.lua)
- `opt` dir contains some scripts used in conf

## Notifications

Dunst is supervised by the systemd user service in `systemd/dunst.service`.
Install and start it with:

```sh
systemctl --user link ~/.config/awesome/systemd/dunst.service
systemctl --user enable --now dunst.service
```


Here's a screenshot of current setup, if you care:

![screenshot](/awesome4.png "My current setup")

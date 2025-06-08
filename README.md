# modern911

A FiveM resource for handling 911 emergency calls, allowing players to send emergency messages to on-duty law enforcement.

## Features

- Players can send 911 calls using `/911a <message>`.
- On-duty law enforcement receive emergency call notifications.
- Includes support for nearest postal codes.
- Notifies players if no law enforcement is on duty.

## Credits

- Script by pookiedev.

## Installation

1. Place the `911call` folder in your server's `resources` directory.
2. Ensure any dependencies (such as `okokNotify` and a postal script with `getNearestPostal` export) are installed.
3. Add `ensure 911call` to your `server.cfg`.
4. Restart your server.

## Usage

- Players: `/911a <your emergency>` to send a 911 call.
- Law enforcement: Go on duty to receive calls.

## Notes

- Commands like `/911_clear`, `/911_nextcall`, and `/911_setwaypoint` are not present or accessible to players.
- Only `/911a` is intended for player use.

## Support

If you need help check out our Discord: https://discord.gg/dCXRG2PDnP

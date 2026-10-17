# Mimi's DW Hub — GitHub loader starter

Files:
- `hub.lua`: the current v0.2.9f hub, using outline/fill colours, transparency, and smooth wheel
- `wheel.png`: the smooth colour-wheel texture
- `loader.lua`: the tiny Madium loader (edit YOUR_GITHUB_USERNAME)
- `run_local.lua`: optional local test before GitHub setup

## Make the loadstring work
1. Create a PUBLIC repository at github.com/new named `Mimis-DW-Hub` (branch `main`).
2. Upload `hub.lua`, `loader.lua`, and `wheel.png` to the repository ROOT (not in a subfolder).
3. Open `loader.lua` and replace `YOUR_GITHUB_USERNAME` with your actual username.
4. Paste the following one-line loader into Madium and execute (replace `YOUR_GITHUB_USERNAME`):

   loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/Mimis-DW-Hub/main/loader.lua"))()

   This runs loader.lua, which creates your Madium workspace folder, downloads the PNG on first use, and fetches the current hub. Or paste the contents of loader.lua into Madium directly if you want to test it before using the one-liner.

## Workspace folder
`workspace/MimisDWHub/` is a folder on your PC managed by Madium; it's different from Roblox's `game.Workspace` object. The loader creates the folder and stores `wheel.png`, a copy of `hub.lua`, and the hub stores `esp-settings.json` when you adjust an ESP style. Local config is kept when you upload new GitHub versions.

If Madium cannot download or write the PNG, manually copy wheel.png to the `MimisDWHub` folder. The hub also falls back to a public Roblox image when the PNG is unavailable.

## Notes
This is a packaging change, not an anti-cheat bypass. It was checked for source-level consistency but cannot be executed within Madium here. The loader runs remote code, so only use your own repository or sources you trust. Your repository must be public for raw.githubusercontent.com without authentication.

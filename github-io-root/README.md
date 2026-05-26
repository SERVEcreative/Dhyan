# app-ads.txt at GitHub root (required for AdMob)

AdMob crawls **`https://servecreative.github.io/app-ads.txt`**, not `/Dhyan/app-ads.txt`.

## One-time setup (5 minutes)

1. On GitHub, create a **new public repository** named exactly:
   **`SERVEcreative.github.io`**
   (must match your GitHub username `SERVEcreative`)

2. Upload **`app-ads.txt`** from this folder to the **root** of that repo
   (not inside any subfolder).

3. **Settings → Pages** → Source: **Deploy from branch** → branch **main** → folder **/ (root)** → Save.

4. Wait 2–5 minutes, then open in browser:
   **https://servecreative.github.io/app-ads.txt**
   You must see one line starting with `google.com, pub-6827778613476055...`

5. In **Play Console → Store settings → Website** you can keep:
   `https://servecreative.github.io/Dhyan/` (privacy policy)

6. In **AdMob → Apps → app-ads.txt → Check for updates** (wait up to 24–72 hours).

Privacy policy stays at `/Dhyan/`; only `app-ads.txt` must be at the **github.io root**.

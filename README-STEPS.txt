DEV GENERAL STORE POS - DEPLOY STEPS
====================================

Files in this zip
  index.html           the POS app (Supabase URL + anon key already embedded)
  sw.js                network-first service worker
  manifest.json        PWA manifest
  supabase-setup.sql   database tables, policies, starter products
  README-STEPS.txt     this file

STEP 1 - Set up the database (Supabase)
  1. Open your Supabase project -> SQL Editor -> New query.
  2. If you used an older script before, run this first:
       drop table if exists public.sales; drop table if exists public.products;
  3. Open supabase-setup.sql, paste everything, press Run.
  4. Table Editor -> products should show 4 starter items.

STEP 2 - Clean the old app off the shop device
  1. Open your old site, press F12 -> Console, paste and press Enter:
       navigator.serviceWorker.getRegistrations().then(r => r.forEach(x => x.unregister()));
       caches.keys().then(k => k.forEach(n => caches.delete(n)));
       indexedDB.deleteDatabase('retail_pos_local');
       indexedDB.deleteDatabase('retail_pos_db');
       Object.keys(localStorage).filter(k => k.startsWith('pos_')).forEach(k => localStorage.removeItem(k));
  2. Close the tab.

STEP 3 - Replace the files in your GitHub repo
  1. Open your repo folder on your computer.
  2. Delete every old file in it (index.html, udhaar.html, manage.html, common.js,
     style.css, icon.svg, old sw.js, old manifest.json, etc.).
  3. Copy the 3 files from this zip into the repo folder:
       index.html, sw.js, manifest.json
     (supabase-setup.sql and this README are optional; do not need to be in the repo.)
  4. In a terminal inside the repo folder:
       git add -A
       git commit -m "Fresh Dev General Store POS"
       git push

STEP 4 - Turn on GitHub Pages (first time only)
  1. GitHub repo -> Settings -> Pages.
  2. Source: Deploy from a branch. Branch: main (or master), folder: / (root). Save.
  3. Wait about 1 minute. Your address is shown at the top of that page.

STEP 5 - First launch
  1. Open the site address. Press Ctrl+Shift+R (hard reload).
  2. Badge top right should say Online. Type "gold" in the search box:
     Gold Flake Lights should appear.
  3. Keep it open online for a few seconds so the scripts are cached for offline use.

STEP 6 - Test everything
  1. Add an item with Enter, press Ctrl+Enter -> bill is saved and the print dialog opens.
  2. Supabase -> Table Editor -> sales: the bill should appear.
  3. Turn Wi-Fi off. Badge turns red. Make another sale: "1 bill(s) waiting to sync".
  4. Turn Wi-Fi on. The bill uploads by itself within seconds.
  5. Test all three payment modes. Khata needs a customer name.

STEP 7 - Printer setup (58mm)
  1. In the print dialog choose the 58mm printer.
  2. Margins: None. Headers and footers: off. Scale: 100%.
  3. If paper is too wide or narrow, set the printer's paper size to 58mm in the
     operating system's printer settings.

STEP 8 - Install as an app
  Chrome / Edge: click the install icon in the address bar (or menu -> Install).
  Android: menu -> Add to Home screen / Install app.

Adding or changing products
  Supabase -> Table Editor -> products. Edit price/name or insert rows (sku, name, price).
  The POS pulls changes automatically every 30 seconds, or on reload.

Updating the app later
  Change sw.js: const VERSION = 'v2'; (any new value), then git push.
  Reload twice on the shop device.

Troubleshooting
  - Search shows nothing: open the browser console (F12). If you see a Supabase error,
    re-run supabase-setup.sql (policies missing).
  - Old screen keeps showing: run the Step 2 console commands again, then Ctrl+Shift+R.
  - Bills stay "waiting to sync": check the internet and the sales table policy.

Security note
  The policies let anyone holding your anon key read and change these tables. This matches
  the setup you asked for. Do not store sensitive data in these tables.

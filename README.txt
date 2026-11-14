UJJWAL'S PICKS — FEATURE UPDATE

WHAT'S INCLUDED
- Click tracking for every Buy button.
- Admin analytics: total clicks, estimated unique browser/device IDs, last-7-day clicks and product-wise report.
- Trending products: mark/unmark products from Admin; trending products appear first by default.
- Search, category filters and sorting by newest, most clicked and top rated.
- Wishlist saved on the visitor's current browser/device (no account required; it does not sync across devices).
- Public product reviews with star ratings. New reviews are pending until the admin approves them.

IMPORTANT: KEEP YOUR EXISTING SETUP
- Keep your existing Supabase project, Netlify site, GitHub repository and config.js.
- Do NOT rerun setup.sql; it is the original setup and is not needed for this feature update.
- Run analytics-migration.sql ONE TIME in Supabase. It adds new tables/columns/functions and does not delete existing products, settings, images or accounts.

1) SUPABASE MIGRATION — REQUIRED FIRST
Open: https://supabase.com/dashboard/project/kblkhtfpuztedzhlvfcp/sql/new
Open analytics-migration.sql, copy the complete contents into a new Supabase SQL Editor query, then click RUN.
Do not run setup.sql again. Do not paste any service_role/secret key into the website.

2) UPDATE GITHUB FILES
Extract this ZIP on your Mac. In your existing repository, replace these files at the repository root:
- index.html
- admin.html
- style.css
- README.txt
Add this new file at the repository root:
- analytics-migration.sql
Keep config.js and setup.sql unchanged. Do not upload only the ZIP file; upload the extracted files.
Commit the changes to the connected GitHub repository. Netlify should automatically deploy the commit.

3) TEST THE WEBSITE
- Open the public website and check product cards, search, category filters and sort options.
- Tap a product's heart to save it to this browser's wishlist.
- Open a product's review panel and submit a test review. It will not show publicly until approved.
- Click a Buy button. A click should be recorded in Supabase.

4) TEST ADMIN
Open your existing /admin.html page and sign in with the configured admin account.
- Check total clicks, estimated unique browser/device IDs, last-7-day clicks and product-wise clicks.
- Use Refresh report to update analytics.
- In Add/Edit Product, tick “Mark as Trending product” to feature it.
- Approve or reject reviews in Review moderation.

NOTES & LIMITATIONS
- A click is a Buy-button click, not a confirmed purchase. Amazon/Flipkart sales and commissions must be checked in their affiliate dashboards.
- Unique visitors are estimated using a random ID stored in the visitor's browser. They are not verified people; clearing browser storage or switching devices can count again.
- Wishlist is stored only on the current browser/device and does not sync between devices.
- Reviews are public only after admin approval. The display name and review text are visible publicly after approval; do not submit sensitive personal information.
- Basic client-side click tracking can be affected by blockers or network interruptions. It is not fraud-proof analytics.
- The public site can read aggregate click totals only; raw visitor IDs remain restricted to the admin analytics function.

SECURITY
- config.js contains the Supabase publishable key, which is designed for browser use.
- Never expose a Supabase service_role/secret key, admin password or email OTP.
- Existing admin email authorization remains vv0303747@gmail.com.

UJJWAL'S PICKS — SETUP GUIDE

FILES
index.html = public website
admin.html = admin dashboard
config.js = project URL, publishable key, admin email
style.css = design
setup.sql = database and image-storage security setup

1) SUPABASE DATABASE
Open https://supabase.com/dashboard/project/kblkhtfpuztedzhlvfcp/sql/new
Open setup.sql, copy all its contents into SQL Editor and click RUN.
This creates the products table, product-images storage bucket and access policies.

2) SUPABASE AUTH URLS
In Supabase open Authentication > URL Configuration.
Set Site URL to your Netlify URL (https://YOUR-SITE.netlify.app).
Add these Redirect URLs:
https://YOUR-SITE.netlify.app
https://YOUR-SITE.netlify.app/**
Keep Email provider enabled. Email confirmation may remain enabled.

3) DEPLOY WEBSITE
Extract this ZIP on your computer. The folder contains index.html.
In the correct Netlify account, open your site and use Deploys > Add new deploy > Deploy manually (or the Drop area).
Drag the extracted folder containing index.html, admin.html, config.js and style.css into Netlify.
This updates the site's published files. Keep the existing Netlify site to keep its URL.

4) CREATE ADMIN LOGIN
Open https://YOUR-SITE.netlify.app/admin.html
Use vv0303747@gmail.com and choose Create account. Choose a password of at least 8 characters.
Check the email inbox and confirm the account if asked. Return to admin.html and log in.
Only the configured email is allowed to make database changes by the SQL policies.

5) ADD PRODUCTS
Enter product name, category, price, description, Amazon/Flipkart/Other, shopping URL and optional photo. Save.
Visitors see the product on the public homepage and the Buy button opens the shopping URL.

SECURITY
The publishable key in config.js is intended for browser use. Do not add any Supabase secret/service_role key.
The SQL uses Row Level Security to restrict product edits and image uploads/deletes to vv0303747@gmail.com.
Never share your admin password or email OTP.


Polished design update: refreshed dark gradient background, improved product cards and mobile spacing. Affiliate disclosure is shortened but retained for transparency. Website Settings remains editable from the admin dashboard and saves to Supabase.

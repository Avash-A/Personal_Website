# Portfolio

A static HTML/CSS/JavaScript portfolio. No framework or backend is required to serve it.

## Preview

From the repository root, run `python3 -m http.server 8765 --bind 127.0.0.1`, then open `http://127.0.0.1:8765`.

## Styles

Edit `styles/styles.scss` and its responsive mixin in `styles/_media.scss`.
The SCSS was reconciled from the previously served CSS to preserve the existing design.
Do not edit `styles/styles.css` or `styles/styles.css.map` directly: they are generated output.

Install the locked development dependency with `npm ci`, then run:

```sh
npm run build:css
# Or rebuild when SCSS changes:
npm run watch:css
```

Commit both the SCSS sources and generated CSS/map together. Sass is a development dependency only;
the deployed website needs no Node.js runtime. Serve `index.html`, `app.js`, `styles/`, and `img/`.

## Navigation and contact

Sections use `#home`, `#about`, `#portfolio`, `#blogs`, and `#contact`.
Unknown hashes are replaced with `#home`. Navigation supports browser history and moves focus to the selected heading.

Contact submission is intentionally unconfigured. The form always prevents submission and displays a notice;
its fieldset stays disabled if JavaScript does not load. No EmailJS scripts or credentials are included.
When a real service is configured, replace the temporary submit handler, remove `novalidate` (or implement equivalent validation),
and add loading, success, and failure handling before enabling delivery.

CV, project, and social URLs remain unconfigured. Their links are marked `data-placeholder` and `aria-disabled="true"`
and do not navigate when JavaScript is running. When adding verified URLs, update their labels/titles and remove those attributes.
Placeholder copy, contact details, blog articles, image optimization, and SEO metadata still need follow-up work.

## Manual checks after changes

- Rebuild styles and run `node --check app.js` and `git diff --check`.
- Inspect Home, About, Portfolio, Blogs, and Contact at 1440, 1280, 768, 375, and 320 CSS pixels.
- Check both themes, visible keyboard focus, direct hashes, refresh, and browser Back/Forward.
- Check project actions with keyboard and touch/coarse-pointer emulation, reduced motion, and no horizontal overflow.
- Confirm Submit displays the unconfigured notice without making a network request or changing the URL.

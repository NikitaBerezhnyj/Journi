# Journi Website

This directory contains the source code for the **Journi website**, including the landing page and privacy policy. The website is a static site generated with **Eleventy (11ty)**.

## Technologies

- [Eleventy (11ty)](https://www.11ty.dev/) — static site generator.
- [Nunjucks](https://mozilla.github.io/nunjucks/) — templating engine.
- HTML/CSS/JavaScript — website frontend.

## Running the Website

### Install dependencies

```bash
npm install
```

### Start development server

```bash
npm run serve
```

The website will be available at:

```text
http://localhost:8080
```

The development server automatically rebuilds the website when files are changed.

### Build for production

```bash
npm run build
```

The generated static website will be placed in the `_site/` directory.

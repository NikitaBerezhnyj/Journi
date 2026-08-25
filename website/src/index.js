(function () {
  const stored = localStorage.getItem("journi-theme");
  const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches;
  const theme = stored || (prefersDark ? "dark" : "light");

  document.documentElement.setAttribute("data-theme", theme);

  window.addEventListener("DOMContentLoaded", () => {
    const toggle = document.getElementById("theme-toggle");

    if (toggle) {
      toggle.addEventListener("click", () => {
        const current = document.documentElement.getAttribute("data-theme");
        const next = current === "dark" ? "light" : "dark";

        document.documentElement.setAttribute("data-theme", next);
        localStorage.setItem("journi-theme", next);
      });
    }

    const languageSelect = document.getElementById("language-select");

    if (languageSelect) {
      languageSelect.addEventListener("change", () => {
        const selected = languageSelect.options[languageSelect.selectedIndex];
        const lang = selected.dataset.lang;

        if (lang) {
          localStorage.setItem("journi-lang", lang);
        }

        window.location.href = languageSelect.value;
      });
    }

    const header = document.getElementById("site-header");

    if (header) {
      const onScroll = () => {
        header.classList.toggle("scrolled", window.scrollY > 24);
      };

      onScroll();
      window.addEventListener("scroll", onScroll, { passive: true });
    }

    const revealEls = document.querySelectorAll(".reveal");

    if (revealEls.length && "IntersectionObserver" in window) {
      const observer = new IntersectionObserver(
        (entries) => {
          entries.forEach((entry) => {
            if (entry.isIntersecting) {
              entry.target.classList.add("is-visible");
              observer.unobserve(entry.target);
            }
          });
        },
        { threshold: 0.15, rootMargin: "0px 0px -60px 0px" },
      );

      revealEls.forEach((el) => observer.observe(el));
    } else {
      revealEls.forEach((el) => el.classList.add("is-visible"));
    }
  });
})();

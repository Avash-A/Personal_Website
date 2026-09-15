(() => {
    const controls = [...document.querySelectorAll('.controls [data-id]')];
    const sections = controls.map(control => document.getElementById(control.dataset.id)).filter(Boolean);
    let currentSection;

    function showSectionFromUrl(moveFocus = true) {
        const requestedId = window.location.hash.slice(1);
        const section = sections.find(item => item.id === requestedId) || document.getElementById('home');
        if (!section) return;

        if (requestedId !== section.id) {
            window.history.replaceState(null, '', `#${section.id}`);
        }
        if (currentSection === section.id) return;

        sections.forEach(item => {
            const active = item === section;
            item.classList.toggle('active', active);
            item.hidden = !active;
        });
        controls.forEach(control => {
            const active = control.dataset.id === section.id;
            control.classList.toggle('active-btn', active);
            if (active) control.setAttribute('aria-current', 'page');
            else control.removeAttribute('aria-current');
        });
        currentSection = section.id;
        if (moveFocus) {
            const heading = section.querySelector('h1, h2');
            if (heading) {
                heading.setAttribute('tabindex', '-1');
                heading.focus({ preventScroll: true });
            }
            window.scrollTo({ top: 0, left: 0, behavior: 'instant' });
        }
    }

    controls.forEach(control => {
        control.addEventListener('click', event => {
            if (event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;
            event.preventDefault();
            if (window.location.hash !== control.hash) {
                window.history.pushState(null, '', control.hash);
            }
            showSectionFromUrl();
        });
    });
    window.addEventListener('popstate', () => showSectionFromUrl());
    window.addEventListener('hashchange', () => showSectionFromUrl());
    showSectionFromUrl(false);

    const themeButton = document.querySelector('.theme-btn');
    themeButton?.addEventListener('click', () => {
        const light = document.body.classList.toggle('light-mode');
        themeButton.setAttribute('aria-pressed', String(light));
    });

    document.querySelectorAll('[data-placeholder]').forEach(link => {
        link.addEventListener('click', event => event.preventDefault());
    });

    const form = document.getElementById('form');
    const status = document.getElementById('form-status');
    const fields = document.getElementById('contact-fields');
    if (form && status && fields) {
        form.addEventListener('submit', event => {
            event.preventDefault();
            status.textContent = 'Your message was not sent. Contact submission is not configured yet.';
        });
        // Keep native submission disabled if this script fails to load.
        fields.disabled = false;
    }
})();

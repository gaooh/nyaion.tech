set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

preview_port := "8787"

default:
    @just --list

setup:
    mise install
    just doctor

doctor:
    @command -v mise >/dev/null
    @command -v just >/dev/null
    @command -v python3 >/dev/null
    @echo "mise: $(mise --version)"
    @echo "just: $(just --version)"
    @echo "python: $(python3 --version)"
    @echo "mise python: $(mise exec -- python --version)"
    @if command -v wrangler >/dev/null; then version="$(wrangler --version 2>/dev/null | head -n 1 || true)"; if [ -n "$version" ]; then echo "wrangler: $version"; else echo "wrangler: installed (version check failed; deploy still requires Wrangler login)"; fi; else echo "wrangler: not found (deploy requires Wrangler login)"; fi

preview port=preview_port:
    python3 -m http.server --bind 127.0.0.1 {{port}}

preview-auto start="8787" end="8899":
    #!/usr/bin/env python3
    import http.server
    import socket
    import socketserver

    host = "127.0.0.1"
    start = int("{{start}}")
    end = int("{{end}}")

    def find_port():
        for port in range(start, end + 1):
            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
                sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
                try:
                    sock.bind((host, port))
                except OSError:
                    continue
                return port
        raise SystemExit(f"no free port found in {start}-{end}")

    class Server(socketserver.TCPServer):
        allow_reuse_address = True

    port = find_port()
    handler = http.server.SimpleHTTPRequestHandler
    with Server((host, port), handler) as httpd:
        print(f"Serving HTTP on http://{host}:{port}/", flush=True)
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nStopped preview server.", flush=True)

check: check-links check-css

check-links:
    #!/usr/bin/env python3
    from html.parser import HTMLParser
    from pathlib import Path

    files = [
        Path("index.html"),
        Path("legal/index.html"),
        Path("legal/privacy/index.html"),
        Path("legal/terms/index.html"),
    ]

    class Parser(HTMLParser):
        def __init__(self):
            super().__init__()
            self.refs = []

        def handle_starttag(self, tag, attrs):
            attrs = dict(attrs)
            for key in ("href", "src"):
                if key in attrs:
                    self.refs.append(attrs[key])

    failures = []
    for file in files:
        parser = Parser()
        parser.feed(file.read_text())
        for ref in parser.refs:
            if ref.startswith(("#", "mailto:", "http://", "https://", "data:")):
                continue
            path = ref.split("#", 1)[0].split("?", 1)[0]
            if not path:
                continue
            target = (file.parent / path).resolve()
            if path.endswith("/") or ref.endswith("/"):
                target = target / "index.html"
            if not target.exists():
                failures.append(f"{file}: missing {ref}")

    if failures:
        raise SystemExit("\n".join(failures))
    print(f"checked {len(files)} html files")

check-css:
    #!/usr/bin/env python3
    import re
    from pathlib import Path

    css = Path("styles.css").read_text()
    defined = {match.strip() for match in re.findall(r"(--[A-Za-z0-9_-]+)\s*:", css)}
    used = set(re.findall(r"var\((--[A-Za-z0-9_-]+)", css))
    missing = sorted(used - defined)
    if missing:
        raise SystemExit("missing CSS vars: " + ", ".join(missing))
    print(f"checked {len(used)} CSS vars")

build:
    ./build.sh

deploy: check
    ./deploy.sh

status:
    git status --short

log:
    git log --oneline -5

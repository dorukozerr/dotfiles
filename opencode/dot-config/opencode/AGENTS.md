## Behavior

- Be concise: no filler, no recaps of unchanged context.
- Explain before acting: read files first, show diffs or content, and let the user approve.
- Batch independent questions into one message; prefer elicitation forms.
- Executables — shell and standalone scripts — get a shebang and no file extension; the
  shebang, not a suffix, decides the interpreter (e.g. `#!/usr/bin/env bash`).
- In JS/TS projects, drive everything through viteplus: `vp` / `vpr` for tasks, `vpx <pkg>`
  for one-off executables. viteplus redirects package-manager commands to pnpm, or to whatever
  package manager `package.json` configures; never run `pnpm`, `npm`, or `npx` directly.

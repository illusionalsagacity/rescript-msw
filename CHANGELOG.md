# @illusionalsagacity/rescript-msw

## 0.3.0

### Minor Changes

- b330304: Adds ~options named argument to the GraphQL and Http bindings, deprecates the \*WithOptions bindings.

  This is a breaking change for Rescript v10.

### Patch Changes

- e2bcae8: docs: Adds doc comments for most bindings
- e402233: Fixes `listHandlers` binding
- b330304: Fixes the binding signature of MSW.GraphQL.operation taking a sync callback instead of async like the rest

## 0.2.2

### Patch Changes

- dec2706: fixes the serviceWorkerOptions type being incorrect and not including the `scope` or other registration options

## 0.2.1

### Patch Changes

- a8875de: Fixes the binding for `MSW.setupWorker` to import from "msw/browser" instead of "msw"
- a8875de: Fixes the binding signature of MSW.GraphQL.operation taking a sync callback instead of async like the rest

## 0.2.0

### Minor Changes

- ba3e115: BREAKING: support MSW v2

## 0.1.3

### Patch Changes

- Fixes formatting for uncurried projects

## 0.1.2

### Patch Changes

- fix: npm publishing mistake

## 0.1.1

### Patch Changes

- 10f31bc: Upgrades to ReScript 10.1 and @rescript/react v0.11.0
- 20b5459: Fixes tests, and clarifies peer dependencies

## 0.1.0

### Minor Changes

- Initial release

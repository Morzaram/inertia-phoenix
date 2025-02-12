# Changelog

## 1.0.0-beta.1

### Breaking Changes

The errors serializer (for `Ecto.Changeset` structs) has been adjusted to better align with the behavior in the Laravel adapter in cases when there are **multiple validation errors for a single field**.

**Old Behavior**

Previously, the serializer would include each error under a separate key, with a `[0]` index suffix, like this:

```javascript
{
  "name[0]": "is too long",
  "name[1]": "is not real"
}
```

While this retains maximal information about all the errors for a field, in practice it's difficult to target the right error records for display in the UI.

**New Behavior**

Now, the serializer simply takes the _first error message_ and returns it under the field name, without any added suffix:

```javascript
{
  "name": "is too long"
}
```

### Bug Fixes

- Allow for external redirects from `PUT` / `PATCH` / `DELETE` requests ([#22](https://github.com/inertiajs/inertia-phoenix/pull/22))

### Features

Support new Inertia v2 mechanics 🎉. There are no breaking changes required to support v2, only new features:

- Add `encrypt_history` function to instruct the client-side to encrypt the history entry.
- Add `clear_history` function to instruct the client-side to clear history.
- Add `inertia_optional` function, to replace the now-deprecated `inertia_lazy` function.
- Add `inertia_merge` function to instruct the client-side to merge the prop value with existing data.
- Add `inertia_defer` function to instruct the client-side to fetch the prop value immediately after initial page load.

This version also includes some new features:

- Helpers for testing Inertia-based controller responses via the `Inertia.Testing` module.
- Added a `camelize_props` global config option and a `camelize_props` function (to use on a per-request basis) to automatically convert prop keys from snake case to camel case.

### Deprecations

- The `inertia_lazy/1` function has been deprecated in favor of `inertia_optional/1`

## 0.10.0

### Bug Fixes

- Remove unsupported dot-notation in partial requests (related to [inertiajs/inertia-laravel#641](https://github.com/inertiajs/inertia-laravel/pull/641))

## 0.9.0

### Bug Fixes

- Fix improper elimination of nested props when using only partials

## 0.8.0

### Features

- Support unicode props (by using the `binary` flag on Node function calls)

## 0.7.0

### Bug Fixes

- Fix exception when assigning structs as prop values (like `DateTime`)

## 0.6.0

### Bug Fixes

- Prevent overly greedy empty object elimination ([#14](https://github.com/inertiajs/inertia-phoenix/pull/14))

## 0.5.0

- Assign errors via an `assign_errors` helper ([#10](https://github.com/inertiajs/inertia-phoenix/issues/10))
- Preserve assigned errors across redirects ([#10](https://github.com/inertiajs/inertia-phoenix/issues/10))
- Set up external redirects properly for Inertia requests ([#11](https://github.com/inertiajs/inertia-phoenix/issues/11))
- Pass CSRF tokens via cookies ([#12](https://github.com/inertiajs/inertia-phoenix/issues/12)) 
- Forward flash contents across forced refreshes ([#13](https://github.com/inertiajs/inertia-phoenix/issues/13))
- Automatically pass Phoenix flash data via the `flash` prop

## 0.4.0

- Support for partial reloads ([#6](https://github.com/inertiajs/inertia-phoenix/issues/6))
- Support lazy data evaluation ([#7](https://github.com/inertiajs/inertia-phoenix/issues/7))

## 0.3.0

- Add `raise_on_ssr_failure` configuration

## 0.2.0

- Add SSR support
- Add `<.inertia_head>` component for rendering head elements provided by SSR

## 0.1.0

- Initial release

# Repository for commonly used actions that are shared between multiple projects

Place your action in a dedicated folder, and refer to it similar to:

```yml
- uses: swacedigital/actions/sentry-release@master
  with:
    SENTRY_ORG: ${{ secrets.SENTRY_ORG }}
    SENTRY_AUTH_TOKEN: ${{ secrets.SENTRY_AUTH_TOKEN }}
    SENTRY_PROJECT: ${{ secrets.SENTRY_PROJECT }}
```

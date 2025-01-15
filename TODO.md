# TODO

We need to use ENTRYPOINT instead of CMD because otherwise our process is not spawned as PID 1 which makes it not working with `podman stop`.
Because of that we cannot exec into container shell. Attach still works
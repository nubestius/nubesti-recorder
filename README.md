<p align="center">
  <p align="center">
   <img width="150" height="150" src="./apps/desktop/src-tauri/icons/Square310x310Logo.png" alt="Logo">
  </p>
	<h1 align="center"><b>Nubesti Recorder</b></h1>
	<p align="center">
		Beautiful screen recordings, owned by you.
    <br />
    <a href="https://recorder.nubesti.com"><strong>Nubesti Recorder »</strong></a>
    <br />
    <br />
    <b>Downloads for </b>
		<a href="https://recorder.nubesti.com/download">macOS & Windows</a>
    <br />
  </p>
</p>
<br/>

Nubesti Recorder is a powerful video messaging tool that allows you to record, edit and share videos in seconds.

# Self Hosting

Nubesti Recorder Web is available to self-host using Docker. See our self-hosting docs to learn more.

Nubesti Recorder Desktop can connect to your self-hosted instance regardless of if you build it yourself or download from our website.

# Monorepo App Architecture

We use a combination of Rust, React (Next.js), TypeScript, Tauri, Drizzle (ORM), MySQL, TailwindCSS throughout this Turborepo powered monorepo.

> A note about database: The codebase is currently designed to work with MySQL only. MariaDB or other compatible databases might partially work but are not officially supported.

### Apps:

- `desktop`: A [Tauri](https://tauri.app) (Rust) app, using [SolidStart](https://start.solidjs.com) on the frontend.
- `web`: A [Next.js](https://nextjs.org) web app.

### Packages:

- `ui`: A [React](https://reactjs.org) Shared component library.
- `utils`: A [React](https://reactjs.org) Shared utility library.
- `tsconfig`: Shared `tsconfig` configurations used throughout the monorepo.
- `database`: A [React](https://reactjs.org) and [Drizzle ORM](https://orm.drizzle.team/) Shared database library.
- `config`: `eslint` configurations (includes `eslint-config-next`, `eslint-config-prettier` other configs used throughout the monorepo).

### License:
This project is based on Cap, which is licensed under AGPLv3. See [LICENSE](LICENSE) for details.
  
# Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for more information.

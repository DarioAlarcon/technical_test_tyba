# Tyba Technical Test

A Flutter application that displays a list of universities fetched from a JSON API. Users can toggle between **ListView** and **GridView**, view university details, and upload an image and student count for each university. Built using **Riverpod** for state management and following best practices.

---

## Features

- Fetches universities data from a JSON endpoint.
- Toggle between **list** and **grid** layouts.
- View detailed information for each university:
  - Name, country, domains, web pages.
  - Upload an image from gallery or camera.
  - Enter the number of students with validation.
- Supports **dynamic UI updates** without persisting data.
- Infinite scroll to load universities in batches of 20.

---
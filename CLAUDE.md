# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal growth journal repository structured using the Tome.gg Librarian Protocol. It tracks founder learning journey through daily stand-up reports (DSU) and self-evaluations, with automated visualization and validation.

## Repository Structure

- `training/` - Daily stand-up reports in YAML format (dsu-reports.yaml and quarterly files)
- `evaluations/` - Self-evaluation data structured per Tome.gg protocol
- `src/config.json` - Configuration for report generation (header text, data sources)
- `tome.yaml` - Main Tome.gg protocol configuration defining data structure and metadata
- `record.fish` - Interactive Fish shell script for creating new DSU entries
- `.github/workflows/` - CI/CD automation for validation and report generation

## Key Commands

### Adding New DSU Reports
```bash
./record.fish
```
Interactive script that prompts for daily stand-up information and appends to training/dsu-reports.yaml.

**Note for Claude Code**: When creating new DSU entries, study the structure from `record.fish` to understand the required format, but collect the information manually from the user and add entries directly to the current quarterly file (`training/dsu-reports-q3-2025.yaml`).

### Validation
```bash
tome validate .
```
Validates repository structure against Tome.gg Librarian Protocol (requires tome CLI installed).

### Report Generation
The GitHub Actions workflow automatically generates visual reports using Docker:
```bash
docker run --rm --init --privileged -p 8080:80 \
  -v ./src/config.json:/var/www/html/config.json \
  -v ./:/app/cypress/screenshots/screenshot.cy.js/ \
  darrensapalo/tome-gg-dsu-report:1.0.0-linux-amd64
```

## Data Structure

### Training Data Format
YAML files follow Tome.gg training protocol v0.1.0:
- Each entry has: id (UUID), datetime, done_yesterday, doing_today, optional blockers/remarks
- Multi-line text fields use YAML literal block scalar format

### Evaluation Data Format
YAML files follow Tome.gg evaluations protocol v0.1.0 for self-assessment tracking.

## CI/CD Workflows

1. **validate-commit.yml** - Runs `tome validate .` on every push to main
2. **generate-report.yml** - Creates visual progress report and uploads as artifact

## Important Notes

- All YAML files must conform to Tome.gg protocol schemas
- The record.fish script includes validation and rollback on failure
- Visual reports are generated automatically but not committed to repository
- Repository uses Tome.gg Public Growth License
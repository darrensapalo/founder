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

**Content Guidelines**: When creating or editing DSU entries, strip away work-related specifics and instead focus on self-reflection and growth as a software engineer. Emphasize learning, skill development, and personal insights rather than company-specific details or project names.

**YAML Formatting**: All multi-line text fields using YAML literal block scalar format (|) must be formatted as proper paragraphs with word wrapping at 80 characters. Do not format text as bullet points or artificial sentence breaks - maintain natural paragraph flow when the text is rendered.

### Adding New Self-Evaluations
Self-evaluations track performance against specific dimensions using a 5-point scale. They complement DSU reports by providing reflective assessment of growth and learning.

**Workflow with tome CLI**:
1. **Find missing evaluations**: Use `tome missing-evaluations` to identify DSU entries that need self-evaluations
2. **Get specific DSU details**: Use `tome get-dsu -u <uuid>` to review the DSU entry content
3. **Add evaluation entry**: Append new evaluation to `evaluations/eval-self.yaml`
4. **Validate**: Run `tome validate .` to ensure proper formatting

**Structure**: Self-evaluations follow Tome.gg evaluations protocol v0.1.0:
- Each evaluation has: id (UUID matching the DSU entry), measurements array
- Each measurement has: dimension, score (1-5), optional remarks
- Scores follow this scale:
  - 1 = INTRODUCTION - Completely unfamiliar with the concept
  - 2 = FAMILIAR - Read about concept but not yet practiced
  - 3 = TRAINING - Actively practicing, seeking external validation
  - 4 = POLISHING - Can self-evaluate, focusing on precision
  - 5 = MASTERY - Correctness guaranteed, self-aware of limitations

**Current Dimension**: Focus (alias: focus) - ability to maintain directed attention on growth objectives and avoid distractions.

**Claude Code Role in Self-Evaluations**: Claude Code should NEVER write or generate self-evaluation content. Self-evaluations must be the user's personal reflections. Claude Code's role is to facilitate the reflection process by:

1. Running `tome missing-evaluations` to identify DSU entries needing evaluations
2. Using `tome get-dsu -u <uuid>` to retrieve specific DSU content for review
3. **Prompting thoughtful reflection** by asking questions about focus performance based on the DSU activities
4. **Supporting the user's writing process** by helping format their reflections into proper YAML structure

**Reflection Facilitation Process**:
1. **Process one DSU entry at a time, starting from the most recent**
2. Present the specific DSU entry content to the user
3. **Focus questions on the specific dimensions defined in the evaluations file** (currently: focus - ability to maintain directed attention on growth objectives and avoid distractions)
4. Ask targeted questions about performance in that dimension during the period:
   - What challenged your [dimension] during this time?
   - Which activities required the most sustained [dimension]?
   - How did you handle distractions or competing priorities that affected your [dimension]?
   - What [dimension] strategies worked well or poorly?
   - How would you rate your [dimension] performance on the 1-5 scale using the defined criteria?
5. Help the user structure their personal reflections into the YAML format:

```yaml
- id: [SAME_UUID_AS_DSU_ENTRY]
  measurements:
    - dimension: focus
      score: [USER_PROVIDED_SCORE]
      remarks: |
        [USER'S_OWN_REFLECTION_WITH_80_CHAR_WRAPPING]
```

**Important**: The score and remarks must come from the user's own self-assessment. Claude Code should never generate evaluation content, only facilitate the user's reflection process through thoughtful questioning.

### Tome CLI Commands

The tome CLI tool provides several commands for managing and analyzing your growth journal:

#### Repository Validation
```bash
tome validate .
```
Validates repository structure against Tome.gg Librarian Protocol.

#### Finding Missing Self-Evaluations
```bash
tome missing-evaluations
tome missing                    # Short alias
```
Shows DSU entries that don't have corresponding self-evaluations. By default shows the last 3 entries chronologically sorted.

```bash
tome missing-evaluations --all
tome missing --all              # Show complete list
```

#### Retrieving Specific Entries
```bash
tome get-dsu -u <uuid>         # Get specific DSU entry by UUID
tome get-latest                # Get most recent DSU entry
```

#### Repository Initialization
```bash
tome init                      # Initialize new Tome.gg repository
```

#### Shell Completions
```bash
tome completion fish           # Generate fish shell completions
```

**Installation**: Download the latest release from [GitHub releases](https://github.com/tome-gg/librarian/releases) for your platform (macOS ARM64, Linux AMD64, Windows AMD64).

### Git Pre-Commit Hook

A pre-commit hook is configured to automatically run `tome validate .` before each commit. This ensures all changes comply with the Tome.gg protocol before being committed to the repository.

**Hook Location**: `.git/hooks/pre-commit`

The hook will:
- Check if tome CLI is installed
- Run validation on the repository
- Block commits that fail validation
- Provide helpful error messages for debugging

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
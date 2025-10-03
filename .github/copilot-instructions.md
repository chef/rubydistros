# GitHub Copilot Instructions for rubydistros

---

## 1. Repository Analysis & Structure

### Project Purpose
**rubydistros** provides Docker images for Ruby distributions on Windows Server, integrating with Chef ecosystem automation and CI/CD pipelines.

### Structure Diagram

```
rubydistros/
├── .expeditor/                # Expeditor build automation configs
│   ├── config.yml             # Expeditor pipeline & subscription config
│   └── build-windows-docker.yml # Windows Docker build steps
├── .github/                   # GitHub workflows, instructions, templates
│   └── copilot-instructions.md # This guide
├── 3.1/windows/2019/Dockerfile # Ruby 3.1 on Windows Server 2019 Dockerfile
├── 3.4/windows/2019/Dockerfile # Ruby 3.4 on Windows Server 2019 Dockerfile
└── ...                        # Other Ruby versions and platform Dockerfiles
```

### Technologies Used
- **Docker** (Windows containers)
- **Expeditor** (CI/CD automation)
- **Buildkite** (pipeline runner)
- **Chocolatey** (Windows package manager)
- **Ruby** (RubyInstaller, MSYS2)
- **PowerShell** (Windows scripting)
- **GitHub Actions** (potential, check .github/workflows)
- **Slack** (notifications)

### File Modification Guidelines
- **Safe to modify:** Dockerfiles, .expeditor/build-windows-docker.yml, documentation files.
- **Prohibited:** Do NOT modify `.expeditor/config.yml` subscriptions without approval, nor any files marked as auto-generated.
- **Never modify:** Any files explicitly marked as generated or managed by automation.

### Code Generation Patterns
- Dockerfiles are hand-written, not auto-generated.
- Expeditor configs are manually maintained.
- Do not modify files in `.expeditor/` unless updating build logic.

---

## 2. Development Workflow Integration

### Jira Integration (atlassian-mcp-server MCP)
- When a Jira ID is provided, fetch issue details via MCP server.
- Read story, plan implementation, confirm requirements.

#### Workflow Phases

**Phase 1: Initial Setup & Analysis**
- Prompt: "Provide Jira ID. Fetching details and analyzing repository."
- Approval gate: "Ready to proceed with implementation?"

**Phase 2: Implementation Phase**
- Prompt: "Implementing code changes and updating documentation."
- Approval gate: "Code changes complete. Proceed to testing?"

**Phase 3: Testing Phase**
- Prompt: "Creating and running unit tests. Ensuring >80% coverage."
- Approval gate: "Tests passed. Ready for PR creation?"

**Phase 4: Pull Request Creation**
- Prompt: "Creating branch, committing with DCO, pushing, and opening PR."
- Approval gate: "PR created. Anything else to do?"

---

## 3. Testing Requirements (CRITICAL)

**MANDATORY:**  
- All code must have comprehensive unit tests.
- **>80% test coverage is REQUIRED.**  
- Coverage must be verified before PR creation.

### Testing Frameworks
- **Ruby:** RSpec or Minitest (if Ruby code present)
- **Docker:** Use [testinfra](https://testinfra.readthedocs.io/) or [Goss](https://github.com/aelsabbahy/goss) for image validation.
- **Shell:** Use [Bats](https://github.com/bats-core/bats-core) for shell scripts.

### Test Structure Example (Ruby)
```ruby
# spec/dockerfile_spec.rb
describe 'Dockerfile' do
  it 'installs Ruby' do
    expect(`docker run ... ruby -v`).to include('3.1')
  end
end
```

### Coverage Verification
- **Ruby:** `rspec --format documentation && open coverage/index.html`
- **Shell:** `bats test/`
- **Docker:** Use Goss or custom scripts.

**Test both positive/negative scenarios, edge cases, error conditions.  
Use mocks for external dependencies.  
Tests must be independent and order-agnostic.**

---

## 4. Pull Request Creation Process

- **Branch name:** Use Jira ID (e.g., `PROJ-123`)
- **Commands:**
  ```bash
  git checkout -b <JIRA_ID>
  git add .
  git commit --signoff -m "<JIRA_ID>: description"
  git push origin <JIRA_ID>
  gh pr create --title "<JIRA_ID>: summary" --body "<html>...</html>" --label "<appropriate-label>"
  ```
- **PR Description (HTML):**
  - Summary of changes
  - Link to Jira ticket
  - List of changes
  - Testing performed & coverage results
  - Files modified
  - Screenshots/examples

---

## 5. DCO Compliance

- **ALL commits MUST use `--signoff` or `-s`.**
- Amending:  
  `git commit --amend --signoff --no-edit`
- **Builds will fail without DCO signoff.**

---

## 6. Build System Integration Analysis

### Expeditor
- **Skip labels:**  
  - `Expeditor: Skip All` (skip all automation)
  - `Expeditor: Skip Version Bump` (skip version bump)
  - `Expeditor: Skip Changelog` (skip changelog)
- **Usage:**  
  - Use skip labels for doc/test-only changes.
- **Build channels:**  
  - Pipelines: `docker/build`, `build-windows`
- **Automation triggers:**  
  - On PR merge, triggers builds as per `.expeditor/config.yml`.

### Other Build Systems
- **Docker:**  
  - Build: `docker build . -f <Dockerfile> -t <tag>`
  - Push: `docker push <tag>`
- **No Make/Rake/npm detected.**

---

## 7. Label Management System

- **List labels:**  
  Run: `gh label list`
- **Label usage:**  
  - Docs: `Expeditor: Skip All`
  - Feature: `enhancement`, `feature`
  - Bug: `bug`
  - Test-only: `Expeditor: Skip Version Bump`
- **Decision matrix:**  
  | Change Type   | Label(s)                       |
  |--------------|--------------------------------|
  | Docs         | Expeditor: Skip All            |
  | Feature      | enhancement, feature           |
  | Bug Fix      | bug                            |
  | Test-only    | Expeditor: Skip Version Bump   |

---

## 8. Prompt-Based Execution Protocol

- After each step: summarize completion.
- Before next: state next step, ask for confirmation.
- List remaining steps.
- Wait for approval.
- **Example:**
  ```
  Step 1 complete: Jira analysis done.
  Next: Implementation. Proceed? [y/N]
  Remaining: Implementation, Testing, PR.
  ```

---

## 9. Repository-Specific Guidelines

- **Build system:** Expeditor, Docker.
- **Dependencies:** Chocolatey, RubyInstaller, MSYS2.
- **Environment:** Windows Server 2019, Docker for Windows.
- **Prohibited modifications:** `.expeditor/config.yml` (without approval), auto-generated files.
- **Platform:** Windows containers, macOS for dev, Linux for CI.
- **Special integrations:** Slack, Jira MCP.

---

## 10. Code Quality & Standards

- **Style:** Chefstyle for Ruby, Dockerfile best practices.
- **Linting:** Use `chefstyle` for Ruby, `hadolint` for Dockerfiles.
- **Security:** CVE scanning, FIPS compliance if required.
- **License:** Apache 2.0.
- **Performance:** Optimize Docker layers, minimize image size.
- **Review:** Use CODEOWNERS if present.

---

## 11. Security and Compliance Requirements

- **CVE awareness:** Scan images before release.
- **FIPS:** Ensure compliance if required.
- **License headers:** Add Apache 2.0 headers.
- **Security scanning:** Use Docker Hub or third-party scanners.
- **Auth:** Use Docker Hub credentials via Expeditor.

---

## 12. Build & Development Environment

- **Local setup:**  
  - Docker Desktop (Windows containers enabled)
  - Ruby (for test scripts)
  - VS Code recommended
- **Build commands:**  
  - `docker build . -f <Dockerfile> -t <tag>`
  - `docker push <tag>`
- **Troubleshooting:**  
  - Ensure Docker is running in Windows mode.
  - Check for Chocolatey/MSYS2 install issues.

---

## 13. Integration & Dependencies

- **Chef ecosystem:** Images used for Chef Infra testing.
- **External services:** Docker Hub, Slack, Jira MCP.
- **API:** None detected.
- **Database:** None detected.

---

## 14. Release & CI/CD Awareness

- **Automated builds:** Expeditor triggers on PR merge.
- **Release channels:** Docker Hub tags.
- **Notifications:** Slack channel `chef-infra-notify`.
- **Manual release:** Tag and push images as needed.

---

## 15. Code Ownership & Review Process

- **CODEOWNERS:** Check for file, document review requirements.
- **Team assignments:** Use PR labels for team routing.
- **Special review:** Required for `.expeditor/config.yml` changes.

---

## 16. Important Development Notes

- **Local work:** All changes made locally.
- **Ask for clarification:** If requirements are unclear.
- **Never modify:** Auto-generated or managed files.
- **Troubleshooting:**  
  - Docker build stuck? Check installer interactivity.
  - Chocolatey issues? Use non-interactive flags.

---

## 17. Example Workflow Execution

**Feature Implementation Example:**
1. User: "Add Ruby 3.2 support. Jira: RUBY-321"
2. Copilot: "Phase 1 complete: Jira analyzed. Next: Implementation. Proceed?"
3. User: "Yes."
4. Copilot: "Dockerfile created. Next: Testing. Proceed?"
5. User: "Yes."
6. Copilot: "Tests passed (>80% coverage). Next: PR creation. Proceed?"
7. User: "Yes."
8. Copilot: "PR created with DCO signoff, HTML summary, coverage results. Anything else?"

---

## 18. Technology-Specific Guidelines

### Ruby
- Use Bundler for dependencies.
- RSpec/Minitest for tests.
- Chefstyle for linting.
- Gems: Use official sources.

### Docker
- Use Windows containers.
- Hadolint for linting.
- Testinfra/Goss for image tests.

### Shell/PowerShell
- Use Bats for shell script tests.
- PowerShell scripts must be non-interactive.

---

## 19. Advanced Configuration Management

- **Config files:** `.expeditor/config.yml`, `.expeditor/build-windows-docker.yml`
- **Env vars:** Set in buildkite or Dockerfile as needed.
- **Secrets:** Managed via Expeditor plugins.
- **Database:** Not applicable.

---

## Validation Checklist

- [x] Repository structure diagram
- [x] DCO signoff in all commit examples
- [x] >80% test coverage requirement (multiple mentions)
- [x] Actual repository labels
- [x] Build system integration (Expeditor, Docker)
- [x] Prompt-based workflow examples
- [x] Technology-specific testing patterns
- [x] Complete Git workflow with commands
- [x] Security and compliance requirements
- [x] Troubleshooting section
- [x] Example interaction patterns

---

**Always follow this guide for all contributions.  
Ask for clarification if requirements are unclear.  
Ensure >80% test coverage and DCO signoff for all commits.  
Use prompt-based execution and wait for approval at each phase.**
# essay-helper

A Claude Code agent team for studying, writing, research, communication, and problem solving. It has 21 specialist subagents, each built from one of the prompts in the original prompt collection, and an **orchestrator** that routes your requests to them, chains them together, and checks their output.

## Quick start

```bash
git clone https://github.com/arielleguyyoung/essay-helper && cd essay-helper
claude --agent orchestrator     # the orchestrator runs as your main session
```

Then just ask, e.g. *"Quiz me on the causes of the French Revolution"* or *"Here are my lecture notes: ... make a study guide and flashcards."*

You can also run plain `claude` here: `CLAUDE.md` tells the main session to follow the `orchestrate` skill, and `/orchestrate` invokes it explicitly. To call a single specialist directly, name it: *"Use the flashcard-generator agent on notes.md"*.

> Why the orchestrator runs as the main session: Claude Code subagents cannot launch other subagents, so the manager has to be the top-level session.

## How it works

```
you -> orchestrator (routes, fills placeholders, briefs, sequences, quality-checks)
          |-- parallel:  independent tasks (e.g. explain X + find papers on X)
          |-- chained:   notes -> study-guide-creator -> flashcard-generator -> study-planner
          '-- interactive: runs quizzes one question at a time using quiz-master's hidden answer key
```

Long deliverables (study guides, reports, flashcard decks as `.tsv`) are saved to `output/`.

## Agents -> original prompts

Prompts that were duplicated or near-identical in the collection share one agent.

| Agent | Covers prompt(s) |
|---|---|
| `problem-solver` | "Your job is to solve problems. Give me a step-by-step guide..." |
| `text-summarizer` | Summarise complex texts |
| `community-connector` | Connect with others (forums, groups, communities) |
| `launch-speech-writer` | Write a launch speech |
| `customer-email-responder` | Respond to emails professionally (customer service) |
| `style-mimic-writer` | Personalise your writing style |
| `idea-generator` | Generate new ideas |
| `pareto-learning-coach` | Use the 80/20 principle to learn faster |
| `editor` | Improve your writing with feedback (proofread) · The Editor |
| `report-researcher` | Turn the AI into your intern (research report + step-by-step guide) |
| `prompt-generator` | Train the AI to generate prompts for you |
| `concept-explainer` | The Topic Explainer · Explain a Difficult Concept · Brain-Friendly Explanations |
| `study-guide-creator` | Study Guide Creator · Lecture Note Processor · Textbook Chapter Breakdown · Mind Map Transformer · Real-World Examples Explainer · Storytelling Study Guide |
| `quiz-master` | Exam Prep Buddy · Instant Practice Test · Exam-Style Question Builder |
| `exam-predictor` | Exam Question Predictor |
| `research-librarian` | The Research Assistant (papers + citations) |
| `flashcard-generator` | Flashcard Generator (x2) · Flashcards in 30 Seconds |
| `essay-planner` | Essay & Assignment Planner · Essay Co-Writer |
| `study-planner` | Study Plan That Actually Works · Last-Minute Exam Cram Helper |
| `memory-hacker` | Memory Hack Machine |
| `past-paper-coach` | Crush Past Paper Questions |

## Skills

Skills are preloaded into the agents that need them (the `skills:` field in each agent file) so they work to a consistent method.

| Skill | Source | Used by |
|---|---|---|
| `orchestrate` | written for this repo | orchestrator: routing table, briefing rules, chains, interactive quiz loop, QA |
| `structured-problem-solving` | written for this repo | problem-solver, orchestrator: define -> root cause -> options -> decide -> plan -> pressure-test |
| `learning-science` | written for this repo | all study agents: active recall, spaced repetition, interleaving, dual coding, worked examples, Feynman |
| `unslop` | [asavvin-pixel/unslop](https://github.com/asavvin-pixel/unslop) (MIT), via the `claudeskills` catalog | writing agents: keeps prose from sounding AI-generated |
| `content-research-writer` | [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills) (Apache-2.0), via the `claudeskills` catalog | report-researcher, essay-planner: research, citations, outlining |

Other skills from the catalog that pair well (install separately if wanted): `anthropics/skills` → `docx`/`pdf`/`pptx` (export guides as files), `doc-coauthoring` (long documents); `PleasePrompto/notebooklm-skill` (study from sources in NotebookLM).

## Guardrails built in

- Research agents must verify every paper, URL, and community before listing it and say so when they can't. They never invent citations.
- Study agents base output on your material and mark outside additions.
- Essay co-writing keeps your ideas central, marks `[ADD: ...]` spots for your own evidence, and reminds you to follow your institution's AI policy.

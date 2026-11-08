---
name: orchestrate
description: Orchestrator for the essay-helper agent team. Routes any study, writing, research, communication, or problem-solving request to the right specialist subagent(s), chains them for multi-step requests, runs interactive quizzes, and quality-checks results. Use for every request in this project, or when the user types /orchestrate.
---

# Orchestrator

You manage a team of specialist subagents (installed in the project's `.claude/agents/` or the user's `~/.claude/agents/`). You do not do the specialist work yourself: you route, brief, sequence, run interactions, and check quality.

## 1. Route
Pick the agent(s) from this table. If several fit, prefer the more specific one.

| User wants... | Agent |
|---|---|
| A step-by-step guide to solve a problem or make a decision | `problem-solver` |
| Key points/takeaways of an article, paper, or long text | `text-summarizer` |
| Communities, forums, groups of learners/experts on a topic | `community-connector` |
| A launch speech for a product/business | `launch-speech-writer` |
| A professional customer-service email reply | `customer-email-responder` |
| An essay written in the style of a sample text | `style-mimic-writer` |
| 5+ fresh, practical ideas on a topic | `idea-generator` |
| The 80/20 of a topic, learn fast | `pareto-learning-coach` |
| Proofreading, grammar, feedback, essay review/editing | `editor` |
| A researched, cited report with a how-to guide | `report-researcher` |
| Top-10 prompts for an occupation/topic | `prompt-generator` |
| A concept explained simply / like I'm 12 / until I get it | `concept-explainer` |
| Notes, transcript, slides, or chapter -> study guide, mind map, storytelling guide | `study-guide-creator` |
| Quiz me / practice test / exam-style questions | `quiz-master` |
| What's likely on my exam; exam strategy | `exam-predictor` |
| Key research papers with summaries and citations | `research-librarian` |
| Flashcards for Anki/Quizlet | `flashcard-generator` |
| Plan or co-write an essay or assignment | `essay-planner` |
| Study schedule for N days, or last-minute cram plan | `study-planner` |
| Mnemonics / help memorising a list | `memory-hacker` |
| How to answer a past exam question | `past-paper-coach` |

Nothing fits? Handle it directly, applying the `structured-problem-solving` skill.

## 2. Fill the placeholders
Each original prompt has slots (topic, audience, word count, citation style, product, problem, solution, exam date...). Before delegating:
- If the user gave the slot, pass it on verbatim.
- If a slot is missing but has a sensible default (the agent files list them), let the agent use the default.
- Ask the user only when a missing input makes the output useless (e.g., "summarise this article" with no article; "respond to this email" with no problem). Ask all missing questions in one message.

## 3. Brief the agent
Subagents start with no memory of this conversation. Every Agent call must include:
- The task and all slot values.
- The user's full material: pasted text verbatim, or the file paths/URLs to read.
- Relevant context from earlier in the conversation (level, course, deadline, preferences).
- Any output constraints the user stated.

## 4. Sequence multi-step requests
- Independent tasks (e.g., "explain X and find papers on X"): launch the agents in parallel in one message.
- Dependent tasks: chain them, feeding each output into the next brief. Common chains:
  - Article -> `text-summarizer` -> `flashcard-generator` / `quiz-master`
  - Notes -> `study-guide-creator` -> `flashcard-generator` -> `study-planner`
  - Topic -> `research-librarian` -> `essay-planner` -> (student drafts) -> `editor`
  - Syllabus -> `exam-predictor` -> `study-planner` -> `quiz-master`
  - Problem -> `idea-generator` (options) -> `problem-solver` (plan for the chosen one)

## 5. Run interactive tasks yourself
Subagents return one result and cannot hold a back-and-forth. For quizzes ("quiz me", exam prep buddy, "grade me after"):
1. Call `quiz-master`; keep its ANSWER KEY to yourself.
2. Show one question at a time and wait for the answer.
3. After each answer, say right/wrong and explain the correct answer using the key, whether they were right or wrong.
4. At the end: score, weak areas, and an offer to make flashcards or a study plan for the weak areas.

Do the same for "explain until I understand it": if the user is still confused after `concept-explainer`, call it again with what confused them and ask for a different angle.

## 6. Quality-check before replying
- Does the output cover every element the original prompt asked for, in the requested length/format?
- Research outputs: are citations real (agents were told to verify; spot-check one link if in doubt)?
- Writing outputs: word limits respected; no generic AI phrasing (see the `unslop` skill).
- Fix small gaps yourself; re-brief the agent for big ones.

## 7. Deliver
- Short outputs: return them directly, without wrapping commentary.
- Long or reusable outputs (flashcard decks, study guides, reports, plans): also save to `output/<short-name>.<md|tsv>` and give the path. Flashcards go to `.tsv` for Anki/Quizlet import.
- End with one line suggesting the natural next step from the chains above, only if useful.

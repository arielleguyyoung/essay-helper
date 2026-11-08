# essay-helper

A team of study, writing, and problem-solving agents managed by an orchestrator.

For any user request in this project, follow the `orchestrate` skill (`.claude/skills/orchestrate/SKILL.md`): route the request to the specialist agents in `.claude/agents/`, then quality-check and deliver the result. Save long deliverables to `output/`.

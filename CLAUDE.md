# OCTO2026 - 내부 경영관리 시스템

## 프로젝트 개요
- React + Vite + Express + tRPC + MySQL
- Railway 배포 (auto-deploy on push)
- 사업부: 봄봄시공, 온라인판매, 제조공급, 리코코

## 기술 스택
- Frontend: React, Vite, TypeScript, Tailwind CSS
- Backend: Express, tRPC
- Database: MySQL (Railway)
- 배포: Railway (GitHub push → auto deploy)

## 개발 규칙
- zsh 환경: 커밋 메시지에 `!` 사용 금지
- DATABASE_URL: Railway direct URL 사용 (reference syntax 아님)
- tRPC batch endpoint: `/api/trpc/router.method?input=encodeURIComponent(JSON.stringify({json:{...}}))`

## gstack

Use /browse from gstack for all web browsing. Never use mcp__claude-in-chrome__* tools.

### Skill routing

When the user's request matches an available skill, ALWAYS invoke it using the Skill tool as your FIRST action. Do NOT answer directly, do NOT use other tools first.

- Product ideas, "is this worth building", brainstorming → invoke office-hours
- Bugs, errors, "why is this broken", 500 errors → invoke investigate
- Ship, deploy, push, create PR → invoke ship
- QA, test the site, find bugs → invoke qa
- Code review, check my diff → invoke review
- Update docs after shipping → invoke document-release
- Weekly retro → invoke retro
- Design system, brand → invoke design-consultation
- Visual audit, design polish → invoke design-review
- Architecture, data flow → invoke plan-eng-review
- Security audit → invoke cso

Available skills: /office-hours, /plan-ceo-review, /plan-eng-review, /plan-design-review, /design-consultation, /design-shotgun, /design-html, /review, /ship, /land-and-deploy, /canary, /benchmark, /browse, /open-gstack-browser, /qa, /qa-only, /design-review, /setup-browser-cookies, /setup-deploy, /retro, /investigate, /document-release, /codex, /cso, /autoplan, /pair-agent, /careful, /freeze, /guard, /unfreeze, /gstack-upgrade, /learn

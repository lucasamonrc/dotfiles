---
name: qwixx
description: Play Qwixx, an SSH-based multiplayer dice game. Use when asked to join, play, or participate in a Qwixx game session. Covers connecting via SSH, navigating the TUI, understanding turn phases, and making strategic decisions about which numbers to mark or pass.
allowed-tools: Bash
---

# Qwixx Player Guide

You are playing Qwixx — a real-time multiplayer dice game over SSH. Read this entire guide before connecting.

---

## 1. Connect

```bash
ssh -p 2222 lucasacastro.cloud
# or locally:
ssh -p 3333 localhost
```

The SSH connection launches an interactive TUI. Use the keyboard — do not try to script input.

---

## 2. Lobby Flow

1. Enter a nickname and press Enter.
2. Choose **Create a room** or **Join a room** (enter the 4-character room code).
3. Wait in the lobby. The host (creator) presses Enter to start once 2–5 players are present.
4. The game begins automatically for all connected players.

---

## 3. Rules

### The Scorecard

Four rows, each with 11 numbers:

| Row    | Direction  | Numbers (left → right)       |
|--------|------------|------------------------------|
| Red    | ascending  | 2 3 4 5 6 7 8 9 10 11 12     |
| Yellow | ascending  | 2 3 4 5 6 7 8 9 10 11 12     |
| Green  | descending | 12 11 10 9 8 7 6 5 4 3 2     |
| Blue   | descending | 12 11 10 9 8 7 6 5 4 3 2     |

**Left-to-right rule:** You can only mark numbers to the right of your rightmost existing mark. Numbers you skip are permanently lost.

### The Dice

Six dice total:
- **2 white dice** — used by all players in Phase 1
- **4 colored dice** (red, yellow, green, blue) — used only by the active player in Phase 2

Locked rows remove their colored die from future rolls.

### Turn Structure

Each turn has an **active player** (rotates each turn). Both phases happen within the same turn:

**Phase 1 — White Sum (ALL players act simultaneously):**
- White sum = white1 + white2.
- Every player (active and non-active) may mark that sum on any one unlocked row, or pass.
- Non-active players are done after this phase — they do not get a Phase 2.

**Phase 2 — Color Combo (ACTIVE player only):**
- Active player may mark one (white die + one colored die) sum on the matching colored row, or pass.
- Two combos per color: white1+color and white2+color (up to 8 combos across 4 active colors).

**Penalty rule:** If the active player marks nothing in EITHER phase, they take a -5 point penalty. Marking in Phase 1 prevents the penalty even if they pass Phase 2.

**4 penalties = game over immediately.**

### Locking a Row

- To mark the rightmost number (12 for Red/Yellow, 2 for Green/Blue), you must already have **5 or more marks** in that row.
- Marking the rightmost number immediately **locks the row globally** — no one can mark it again.
- The player who locks gets a **bonus +1 mark** counted in their score.
- When a row locks, its colored die is removed from all future rolls.

### End Conditions

Game ends when either:
- 2 rows are locked (globally, any combination of players), OR
- Any player reaches 4 penalties.

### Scoring

Each row scores: n × (n+1) / 2, where n = your marks in that row.
If you personally locked the row, n = your marks + 1 (lock bonus).
Penalties: -5 each.
Highest total wins.

**Score reference:**

| Marks   | Points |
|---------|--------|
| 1       | 1      |
| 2       | 3      |
| 3       | 6      |
| 4       | 10     |
| 5       | 15     |
| 6       | 21     |
| 7       | 28     |
| 8       | 36     |
| 9       | 45     |
| 10      | 55     |
| 11+lock | 78     |

---

## 4. Keyboard Controls

| Key               | Action                   |
|-------------------|--------------------------|
| Arrow keys / hjkl | Move cursor on scorecard |
| Enter or Space    | Mark selected number     |
| P                 | Pass current phase       |
| Ctrl+C            | Quit                     |

The TUI highlights valid moves. If you have no valid moves, the game auto-passes for you after a brief delay — you do not need to detect this yourself.

---

## 5. Decision Framework

### Phase 1 — Should I mark the white sum?

Work through these in order:

1. **Any valid positions?** If the white sum has no valid positions in any row, you cannot mark — the game will auto-pass.

2. **Which rows can accept this number?**
   - Red/Yellow: the number must be greater than your rightmost mark.
   - Green/Blue: the number must be less than your rightmost mark.

3. **Rank valid rows by priority:**
   - Rows with the most existing marks (protect your triangular score investment).
   - Rows where the skip is smallest (number is closest to your rightmost position).
   - Avoid rows where accepting the number skips 4+ positions early in the row.

4. **Mark the top-priority row, or pass if all options are too costly.**

**Skip tolerance heuristic:** Accept a skip of 1–2 positions readily. For skips of 3+, only mark if that row already has many marks (protecting a large investment). A skip of 5+ is almost never worth it unless you are avoiding a penalty.

### Phase 2 — Should I mark a color combo? (Active player only)

Your Phase 1 decision changes the stakes:

- **You marked in Phase 1:** Safe from penalty — be selective. Only mark if the move is good.
- **You passed Phase 1:** You MUST mark something in Phase 2 or take a penalty. Mark the best available move even if it's mediocre.

Rank color combos by priority:

1. **Moves that complete a lock** (5+ marks in row + marking rightmost number). Always take this — +1 bonus mark and removes an opponent's Phase 2 option.
2. **Moves in rows with the most existing marks** (protect investment).
3. **Moves with the smallest skip.**
4. **Pass only if already safe from penalty and all combos require large skips (4+).**

### Penalty Avoidance (Active Player)

If you passed Phase 1, scan ALL available Phase 2 color combos before giving up. If ANY valid combo exists — even a bad one — mark it. A -5 penalty is nearly always worse than an imperfect mark.

### Row Prioritization (General)

Priority order:
1. Rows closest to locking (5+ marks, rightmost number reachable soon).
2. Rows with the most marks (highest marginal gain from triangular scoring).
3. Rows with a moderate number of marks (3–7).
4. De-prioritize rows with 0–1 marks unless a perfect opportunity arises.

### Endgame Strategy

When 1 row is already locked, the next lock ends the game:
- **If you are ahead in score:** Be cautious about triggering the second lock prematurely — opponents may not have had time to build their rows.
- **If you are behind:** Aggressively pursue a second lock to end the game before opponents close the gap.

---

## 6. Worked Examples

**Example A — Choosing which row in Phase 1:**
White sum = 7. Red row: marks at 2,3,4,5 (rightmost=5). Yellow row: marks at 2,6 (rightmost=6). Green/Blue: empty.
- Red: can mark 7 (skip 1, loses 6 forever). Red has 4 marks.
- Yellow: can mark 7 (skip 0, directly next after 6). Yellow has 2 marks.
- Yellow has zero skip and Red has more marks — choose Yellow. No numbers lost, and you still grow Red later.

**Example B — Penalty avoidance:**
Active player. White sum = 3, no valid moves anywhere (all rows start past 3). Pass Phase 1. Phase 2: Blue combo = blue+white1 = 10. Blue row (descending) has rightmost mark at 11, so 10 is next valid (skip 0). Mark Blue 10 — penalty avoided.

**Example C — Locking:**
Yellow row: marks at 2,3,4,5,6,7 (6 marks). Phase 1 white sum = 12. Yellow can accept 12 (rightmost, skip 4: loses 8,9,10,11). With 6 existing marks, lock threshold met (5+). Mark it — locks Yellow, score = 6+1=7 marks = 28 points for that row, yellow die removed.

---

## 7. Common Mistakes

- **Green/Blue direction confusion:** Green and Blue are descending (12→2). The number 12 is the leftmost (starting) position, 2 is the rightmost (lock) position. High numbers come first in these rows.
- **Misjudging the lock threshold:** To mark the rightmost number, you need 5 marks already in the row — the mark you are about to make becomes the 6th. You cannot lock on your 5th mark.
- **Forgetting non-active players stop after Phase 1:** When you are not the active player, press P (or mark the white sum) and your turn ends. Do not wait for a Phase 2 prompt.
- **Passing Phase 1 without checking Phase 2 first:** Before passing Phase 1 as the active player, verify that at least one Phase 2 color combo is valid. If Phase 2 also has nothing, you will take a penalty — and sometimes it is better to take a bad mark in Phase 1 than to guarantee a penalty.

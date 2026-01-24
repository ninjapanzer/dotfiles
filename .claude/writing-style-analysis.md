# Writing Style Analysis: Corpus Extraction vs. Agent Prompts

This document extracts actual writing patterns from the developmeh corpus, compares them to the generated agent prompts, and identifies gaps and discrepancies.

---

## Part 1: Extracted Style Guides

### Professional Voice - Extracted from Corpus

**Source documents analyzed:**
- `the-good-sergeant.md`
- `ci_cd.md`
- `decoupling_patterns_in_ruby_overview.md`
- `sufficient-complexity.md`

#### Sentence Structure Patterns

1. **Opening with position statements:**
   - "I am a consultant, and I have lived in more production systems than most."
   - "As I age in my software development career, I find myself falling into unofficial management roles."
   - "I was once asked, 'Where would you put your business logic in an MVC application?'"

2. **Declarative followed by qualification:**
   - "I will tell you that CD(continuous delivery) is easy. Everyone does it, and in general, it works."
   - "I often find myself aware of the opportunity to make decisions that drive change for my teams. I would classify myself as 'intense' and 'opinionated'"

3. **Parenthetical technical clarification:**
   - "CD(continuous delivery)"
   - "Conway's Law"
   - "RBAC (Role Based Access Control)"

#### Language Inventory

**Actually used hedging (contrary to prompt):**
- "I think" appears: "I think different authority is easier to gain"
- "I believe" appears: "I believe that people are attracted to people who can comfortably share their vulnerabilities"
- "probably" appears: "that's probably both true and false"

**Distinctive phrases:**
- "Consider this:"
- "Interestingly,"
- "To be crystal [clear]"
- "Here in lies the trap"
- "Secret time!"
- "Say it with me,"

**Metaphor domains:**
- Plumbing/pipes: "plastered over", "pinholes, leaks"
- Military: "the good sergeant", "NCOs", "command center"
- Food/cooking: "pickles", "cucumbers", "dish for our customers"
- Sports: "Steelers", "foosball"

#### Structural Patterns

1. **Section headers as provocations:**
   - "You have Continuous Deployment, not Continuous Delivery"
   - "Slow is fast"
   - "When you do things right"

2. **Inline emotional intensification:**
   - Bold text for emphasis: "__Authority is not unary__"
   - Italicized concepts: "_Art_, _Income_, and _Moat_"

3. **Quote integration:**
   - Attributed quotes as punctuation marks
   - "Watch the pennies and the dollars will take care of themselves. - Franklin"

---

### Devlog Voice - Extracted from Corpus

**Source documents analyzed:**
- `the-magic-of-stubbing-sh.md`
- `recreating-kafka-blind.md`
- `this-weeks-crazy.md` (devlog entries)

#### Code Block Patterns

1. **File naming convention observed:**
   - `__temp.sh__` with double underscores, NOT backticks
   - Inline filename before code block
   - "Subject Under Test" label pattern

2. **Code completeness patterns:**
   - Full imports shown when referencing external packages
   - `...` NOT consistently used - some blocks show complete code
   - Code blocks are often complete units, not fragments

3. **Dependency listing:**
   - Often embedded in prose rather than explicit lists
   - "bats_require_minimum_version 1.5.0"
   - References to required libraries inline

#### Structural Patterns

1. **Date headers in devlogs:**
   - Format: `## DD MM YYYY` (day first, European style)
   - Followed by `###` subheading describing focus

2. **Explanatory prose placement:**
   - Appears AFTER code blocks, not before
   - "Lets explore the mocking..."
   - "Lets explore what happens here."

3. **Inline notes:**
   - "_Note_ The use of `command` which bypasses..."
   - Placed after code, not as comments within

#### Language Patterns

**Technical jargon handling observed:**
- NOT always defined on first use
- Assumes familiarity: "LSM (Log-Structured Merge)" defined, but "TCP", "ACK", "goroutine" used without definition
- Inconsistent application of the "define jargon" rule

**Voice characteristics:**
- First person throughout
- Admission of uncertainty: "I don't know if I really like Kafka all that much"
- Self-deprecating: "while this might be structured like a tutorial its really a devlog of the failures"
- "While a little hacky and providing an arbitrary limit..."

---

### Blog Personality - Extracted from Corpus

**Source documents analyzed:**
- `creative-impostor-syndrome.md`
- `nih.md`
- `this-weeks-crazy.md` (intro section)
- `the-perfect-dev-env.md` (rant sections)

#### Opening Patterns

1. **Subversion of expectation:**
   - "Another Syndrome?!" (section header)
   - "In reality, I am merely saying I had impostor syndrome, but not the workplace kind"

2. **Memory invocation:**
   - "Remember Web-Rings? I do, they sucked but..."
   - "Back in those days you had to get a host, write your own HTML..."

3. **Direct confession:**
   - "In all honestly tech is completely boring. Nothing shakes me to my core anymore."

#### Sentence Rhythm Analysis

**Short punchy sentences:**
- "You should be picking up the conflicts now."
- "It is a BIG DEAL!"
- "Yep, go find a product person..."
- "That's pretty cool to be honest"

**Long flowing sentences (counterpoint):**
- "Unlike the kind many of us have early in our careers, my relationship with creativity has much more complicated roots."
- "My definition of what creation is has always been mired in a deranged triangle of, _Art_, _Income_, and _Moat_."

**Mixed rhythm pattern:**
Short declarative. Longer explanation with embedded clauses. Short punch. Longer reflection.

#### Emotional Intensification

**Observed expletives/intensifiers:**
- "__IF YOU EVEN ONCE SAY WE DON'T NEED TO TEST OUR BASH GET THE HELL OUT__"
- "get shit done"
- "stunk for me"

**Formatting during emotional peaks:**
- ALL CAPS within bold: `__ALL CAPS__`
- Multiple formatting layers combined
- Exclamation marks sparingly but pointedly

#### Non-Linear Structure

**Observed patterns:**
1. Opens with tangent (web rings, nostalgia)
2. Builds seemingly unrelated thread (creativity, income, moat)
3. Reader addressed directly: "You should be picking up the conflicts now"
4. Thesis emerges mid-article or later
5. Ends with quote or philosophical beat

**Bullet list handling:**
- Lists 3-4 items
- Addresses most but not all immediately
- Returns to unaddressed items later in prose

---

## Part 2: Prompt vs. Corpus Comparison

### Professional Voice

| Aspect | Prompt Claims | Corpus Evidence | Discrepancy |
|--------|---------------|-----------------|-------------|
| "I think" usage | NEVER use | Used regularly: "I think different authority is easier" | **MAJOR GAP** |
| "I feel" usage | NEVER use | Used: "feel busy, feels dangerous" | **MAJOR GAP** |
| "maybe/perhaps" | NEVER use | Used: "this might seem a little out of scope" | **GAP** |
| Expletives | NEVER use | Rare but present: "stunk", "crap" contexts | Minor gap |
| Plumbing metaphors | Emphasized | Present and accurate | Accurate |
| Active voice preference | Claimed | Mixed usage observed | Overstated |
| Science as authority | Emphasized | Present but balanced with personal anecdote | Accurate |

**Assessment:** The prompt overcorrects on hedging language. The actual corpus shows measured use of "think/feel" as honest qualification, not weakness.

### Devlog Voice

| Aspect | Prompt Claims | Corpus Evidence | Discrepancy |
|--------|---------------|-----------------|-------------|
| File extensions required | Always | Present but format varies: `__temp.sh__` vs backticks | Format inconsistent |
| `...` for partial code | Always | NOT consistently used - many complete blocks | **MAJOR GAP** |
| Jargon always defined | First use | Inconsistent - many terms assumed | **MAJOR GAP** |
| Dependencies listed | Always | Often embedded in prose, not explicit | Overstated |
| Given/When/Then | Recommended | Used once explicitly, often implied | Accurate |
| Code focus over prose | Claimed | Accurate - prose serves code | Accurate |
| Errata sections | Mentioned | Present in some articles | Accurate |

**Assessment:** The prompt overspecifies code formatting rules. The actual corpus shows flexibility based on context. Jargon definition is inconsistent in practice.

### Blog Personality

| Aspect | Prompt Claims | Corpus Evidence | Discrepancy |
|--------|---------------|-----------------|-------------|
| Inverse thesis | Build to conclusion | Accurate - thesis often mid/late | Accurate |
| Expletives when emotional | Permitted | Used sparingly but present | Accurate |
| Non-linear bullet lists | Items addressed out of order | Observed but subtle | Accurate |
| Mark Manson inspiration | No false hope, accept flaws | Tone present, never saccharine | Accurate |
| Memory openings | "Remember X?" | Present and characteristic | Accurate |
| One-sentence paragraphs | Power move | Used effectively | Accurate |
| Self-deprecation | Present | Accurate | Accurate |
| Foreign phrases | Occasional | "Regarde-moi!" observed | Accurate |

**Assessment:** This prompt most accurately captures the corpus patterns. Minor refinements possible but fundamentally sound.

---

## Part 3: Recommended Prompt Revisions

### Professional Voice - Corrections Needed

**Remove or soften:**
```diff
- NEVER use: "I think", "I feel", "maybe", "perhaps"
+ LIMIT but don't eliminate: "I think", "I feel" - use when genuine qualification is warranted
+ Avoid EXCESSIVE hedging, but honest uncertainty is acceptable
```

**Add observed patterns:**
- "Consider this:" as a transition device
- "Say it with me," for reader engagement
- Sports and food metaphors alongside plumbing
- Parenthetical acronym expansion pattern

### Devlog Voice - Corrections Needed

**Revise code block rules:**
```diff
- Use `...` (three dots) to show code is part of a larger file
+ Use `...` when showing fragments; complete code blocks are also acceptable
+ Context determines whether to show complete or partial code

- ALWAYS define jargon inline on first use
+ Define jargon for cross-domain terms (LSM, NAT); assume familiarity with
+ language-specific terms (goroutine, ctx, closure) for target audience
```

**Add observed patterns:**
- Date headers: `## DD MM YYYY` format
- Double-underscore file naming: `__filename.ext__`
- Explanatory prose AFTER code blocks
- Admission of uncertainty: "I don't know if..."

### Blog Personality - Minor Additions

**Add observed patterns:**
- "You should be picking up the conflicts now" - direct reader address mid-article
- Formatting intensification: bold + caps for peak emotion
- Quote endings as philosophical punctuation
- Pittsburgh/regional references as grounding details

---

## Part 4: Synthesis

### What the Prompts Got Right

1. **Core voice distinctions are accurate** - the three personas are genuinely different in the corpus
2. **Metaphor domains are accurate** - plumbing, enterprise, early web nostalgia
3. **Blog personality structure is well-captured** - inverse thesis, pacing, emotional intensity
4. **Philosophy captured** - pragmatism over dogma, protocols over abstractions, "be boring"

### What the Prompts Over-Specified

1. **Hedging language ban** - corpus shows thoughtful use of "think/feel" for honest qualification
2. **Code formatting rigidity** - the `...` convention is not consistently applied
3. **Jargon definition requirement** - assumes audience knowledge varies by context

### What the Prompts Under-Specified

1. **Regional identity markers** - Pittsburgh, Steelers, etc. ground the voice
2. **Food and sports metaphors** - present alongside plumbing
3. **Specific transitional phrases** - "Consider this:", "Say it with me,"
4. **Date format for devlogs** - DD MM YYYY, not US format

### Authenticity Assessment

The blog personality prompt is the most authentic to the corpus (85% alignment).
The devlog prompt is moderately aligned (70%) but over-rigid on formatting.
The professional prompt has the largest gap (60%) due to overcorrection on hedging.

The prompts collectively capture the *spirit* of the voices but impose artificial constraints not present in the actual writing. The real corpus shows a writer comfortable with uncertainty, regional identity, and flexible formatting based on context.

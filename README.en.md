# ai-portrait-light (English summary)

A **model-agnostic methodology** for writing portrait-lighting prompts, packaged as a
Claude Code skill. Derived from ~280 single-variable, fixed-seed A/B renders plus eleven rounds of
human-curated finals (~480 candidates, 30 kept — they are in `assets/`, with the full prompt for each
in `docs/配方全文.md`).

The rules are split by whether they survive a change of model. Most of them — everything about
composition, where the light source sits, and what has to be in the air — are optics and framing,
and they carry over. A smaller set is tied to the sampler and conditioning (cfg=1 negative prompts,
prompt length vs. crop, seed reproducibility) and has to be re-measured on a new model. SKILL.md
keeps the two apart.

The prompts are written in Chinese and are meant to stay that way — they are tuned against
Chinese-native text encoders and work as-is in Doubao / Jimeng / Qwen as well as local ComfyUI.
This page is a summary; the methodology itself is Chinese:
[`skills/portrait-light/SKILL.md`](skills/portrait-light/SKILL.md).

## The one-line takeaway

> Don't write *"beautiful rim lighting."* Write *"the sun sits low in the gap between the two
> buildings 45° to her front-left, cutting across half her face."*

Every other rule here is a corollary — it does three things at once: describes the scene instead of
the light, pins a **bearing** rather than a height, and puts the light **on her face** instead of
only rimming her.

⚠️ An earlier version of this line ended with *"level with her head."* That is a rim light: not
physically wrong, but eight subsequent renders were all rejected — **rim-only means the person
doesn't look good.** See finding 2.

## Install

```bash
git clone https://github.com/L-Trunks/ai-portrait-light.git
cd ai-portrait-light
bash install.sh            # Windows: powershell -ExecutionPolicy Bypass -File install.ps1
```

Installs to `~/.claude/skills/`. Pass `--project` to install into `./.claude/skills/` instead.

## The four findings that cost the most to get

**1. Light comes from the scene description, not from adjectives.**
Five escalating intensities of lighting adjectives appended to the prompt moved P1 / ΔB / HALO
by *nothing*. Changing one scene clause — from "behind her is a clean warm-white wall" to
"behind her is an open shop door and the street outside" — produced real backlight on the first try.
The wall was blocking the sun out of frame. **Write the scene so that the lighting is the only
physically possible one.**

**2. Pin both the distance and the bearing — and only two phrasings survive.**
"The whole city's neon is right behind her" puts the neon hundreds of metres away; the light
reaching the subject is ~zero and you get *a very pretty backdrop*. **"Level with her face/head" is
retired outright**: that is the *camera's* height, so the model can only push the source behind her.
Two phrasings never failed: **45° to her front-left/right** (a bearing) and **directly in front,
lower than her face** (a height difference). True backlight from directly behind is the one exception.
And a counterintuitive one: **the noun for a lamp carries its own height.** Write "a street lamp,
its head level with hers" and the model puts it *above* her, because that is what street lamps do.
For a low source, change the fixture (an oil lantern on a low wall), not the adjective.

**3. The air must contain something lit.**
"Golden hour" alone gives ΔB = −10.11 (i.e. nothing). Adding "fine dust motes lit up in the air"
gives +1.37. Dust, catkins, mist, snow grains, petals, embers, dry-ice haze — pick what fits the scene.

**4. At cfg=1 there is no "not".** *(model-specific: anything running Lightning / turbo / distillation)*
Negative prompts silently do nothing. Every prohibition must be rewritten as a positive assertion:

| Goal | ⛔ Doesn't work | ✅ Works |
|---|---|---|
| No cast shadows | negative: `shadow` | "every object sits directly on the white paper and casts absolutely no shadow" |
| Face not too round | "face not chubby" | "a narrow oval face, cheeks tapering smoothly inward, jaw angle narrowed, pointed chin" |
| Skirt not becoming a bodysuit | "not a bodysuit" | "the skirt is one fully closed tube, level all the way around, wrapping the thighs" |

The pattern: **`no X` summons X.** The only thing that works is describing the shape you *do* want.

## Three framing families, whose rules contradict each other

| | Close-up | Medium / bust | Environmental portrait (landscape) |
|---|---|---|---|
| What makes it work | shadow under the face + a light source touching it | composition (subject off-centre, background fully blurred) | scene geometry + a light source **next to her** |
| Background | positively state "blurred into one shape, no detail" | same | the opposite: **it must have detail** |
| Aspect | ⛔ portrait only | either | ⛔ landscape only |
| Usual failure | the crop slips back to a bust shot | background steals attention | degrades into "a pretty backdrop" |

⛔ **A 16:9 frame will not hold a close-up.** The same close-up camera clause, revised three times
in landscape, moved the crop by nothing across twelve renders; the identical clause in portrait
aspect landed on the first try. A 16:9 frame is itself a request to fill it horizontally.

## ⚠️ Two caveats

**Good numbers do not mean a good picture.** The repo ships eight quantitative metrics.
**They can falsify, not verify.** The best-scoring set in the whole experiment was "a very pretty
backdrop with no light on the subject at all" — that mistake was made three times. The only reliable
check is looking at whether individual strands of hair light up and whether the subject has a rim.

**Re-rolling the seed beats rewording.** The spread between seeds on one prompt is larger than most
wording changes produce. The 30 finals were picked from ~480 candidates — **every slot ended up
on a non-default seed.** If three revisions in one direction move nothing, what's blocking you is
structural (framing, aspect ratio), not the wording.

**A checklist is not a build order.** The single largest effect measured after publication: applying
*every* criterion to *every* image produced a 7/12 keep rate on the first batch and then collapsed to
1/12 and 1/12 on the next two, because attention went into filling the checklist and the poses and
camera heights silently defaulted (10 of 12 shared one pose sentence; 12 of 12 were shot at eye
level). Deciding **one thing each image stands on** and leaving the rest blank held at 6/12 and 4/12
across two consecutive batches. **One skeleton lasts one batch.**

## License

Methodology documents and images: CC BY 4.0. Code: MIT. See [LICENSE](LICENSE).
Cosplay characters shown remain the property of their respective rights holders; this repository is
not affiliated with them.

Related: [ai-film-skills](https://github.com/L-Trunks/ai-film-skills) — AI short-film methodology skills
by the same author.

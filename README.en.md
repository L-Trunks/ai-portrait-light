# zimage-portrait-light (English summary)

A **Chinese-prompt lighting recipe** for portrait image generation on **cfg=1 models**
(z-image, and anything running Lightning / turbo / S2V acceleration), packaged as a
Claude Code skill. Derived from ~120 single-variable, fixed-seed A/B renders over fifteen rounds.

The prompts are written in Chinese and are meant to stay that way — they are tuned against
Chinese-native text encoders and work as-is in Doubao / Jimeng / Qwen as well as local z-image.
This page is a summary; the recipe itself is Chinese:
[`skills/zimage-portrait-light/SKILL.md`](skills/zimage-portrait-light/SKILL.md).

## The one-line takeaway

> Don't write *"beautiful rim lighting."* Write *"the sun sits low in the gap between the two
> buildings behind her, level with her head."*

Every other rule here is a corollary.

## Install

```bash
git clone https://github.com/L-Trunks/zimage-portrait-light.git
cd zimage-portrait-light
bash install.sh            # Windows: powershell -ExecutionPolicy Bypass -File install.ps1
```

Installs to `~/.claude/skills/`. Pass `--project` to install into `./.claude/skills/` instead.

## The three findings that cost the most to get

**1. Light comes from the scene description, not from adjectives.**
Five escalating intensities of lighting adjectives appended to the prompt moved P1 / ΔB / HALO
by *nothing*. Changing one scene clause — from "behind her is a clean warm-white wall" to
"behind her is an open shop door and the street outside" — produced real backlight on the first try.
The wall was blocking the sun out of frame. **Write the scene so that the lighting is the only
physically possible one.**

**2. The air must contain something lit.**
"Golden hour" alone gives ΔB = −10.11 (i.e. nothing). Adding "fine dust motes lit up in the air"
gives +1.37. Dust, catkins, mist, snow grains, petals, embers, dry-ice haze — pick what fits the scene.

**3. At cfg=1 there is no "not".**
Negative prompts silently do nothing. Every prohibition must be rewritten as a positive assertion:

| Goal | ⛔ Doesn't work | ✅ Works |
|---|---|---|
| No cast shadows | negative: `shadow` | "every object sits directly on the white paper and casts absolutely no shadow" |
| Face not too round | "face not chubby" | "a narrow oval face, cheeks tapering smoothly inward, jaw angle narrowed, pointed chin" |
| Skirt not becoming a bodysuit | "not a bodysuit" | "the skirt is one fully closed tube, level all the way around, wrapping the thighs" |

The pattern: **`no X` summons X.** The only thing that works is describing the shape you *do* want.

## Four presets, whose rules contradict each other

| | Warm backlight · full body | Profile hair-light · close-up | Front ring-light · close-up | Self-lit · cold close-up |
|---|---|---|---|---|
| What makes it work | scene geometry | composition (profile + close-up) | how the light is phrased | a self-luminous prop + crushed shadows |
| Tone | warm | warm | warm | **cold — and cold is load-bearing** |

Rule of thumb: full-body depends on scene geometry, close-ups depend on composition and on how you
phrase the light, and cold tones only work through the self-lit preset.

## ⚠️ One caveat

The repo ships eight quantitative metrics. **They can falsify, not verify.** The best-scoring set in
the whole experiment was "a very pretty backdrop with no light on the subject at all" — that mistake
was made three times. The only reliable check is looking at whether individual strands of hair light up.

## License

Recipe documents and images: CC BY 4.0. Code: MIT. See [LICENSE](LICENSE).

Related: [ai-film-skills](https://github.com/L-Trunks/ai-film-skills) — AI short-film methodology skills
by the same author.

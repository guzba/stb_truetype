import unicode

when defined(windows) and defined(vcc):
  {.pragma: stbcall, stdcall.}
else:
  {.pragma: stbcall, cdecl.}

{.compile: "stb_truetype.c".}

type
  stbttBuf = object
    data: ptr cuchar
    cursor: cint
    size: cint

  FontInfo* = ref object
    userData: pointer
    data: ptr cuchar
    fontStart: ptr cint
    numGlyphs: cint
    loca, head, glyf, hhea, hmtx, kern, gpos, svg: cint
    indexMap: cint
    indexToLocFormat: cint
    cff, charstrings, gsubrs, subrs, fontdicts, fdselect: stbttBuf

proc stbtt_InitFont(
  fontInfo: FontInfo,
  buffer: ptr cuchar,
  offset: cint
) {.importc: "stbtt_InitFont", stbcall.}

proc initFont*(buffer: string): FontInfo =
  result = FontInfo()
  stbtt_InitFont(
    result,
    cast[ptr cuchar](buffer[0].unsafeAddr),
    0
  )

proc stbtt_FindGlyphIndex(
  fontInfo: FontInfo,
  unicodeCodepoint: cint
): cint {.importc: "stbtt_FindGlyphIndex", stbcall.}

proc findGlyphIndex*(fontInfo: FontInfo, rune: Rune): uint16 =
  stbtt_FindGlyphIndex(fontInfo, rune.cint).uint16

proc stbtt_GetFontVMetrics(
  fontInfo: FontInfo,
  ascent, descent, lineGap: ptr cint
) {.importc: "stbtt_GetFontVMetrics", stbcall.}

proc getFontVMetrics*(fontInfo: FontInfo, ascent, descent, lineGap: var cint) =
  stbtt_GetFontVMetrics(fontInfo, ascent.addr, descent.addr, lineGap.addr)

proc stbtt_GetCodepointHMetrics(
  fontInfo: FontInfo,
  codepoint: cint,
  advanceWidth, leftSideBearing: ptr cint
) {.importc: "stbtt_GetCodepointHMetrics", stbcall.}

proc getCodepointHMetrics*(fontInfo: FontInfo, rune: Rune, advanceWidth, leftSideBearing: var cint) =
  stbtt_GetCodepointHMetrics(fontInfo, rune.cint, advanceWidth.addr, leftSideBearing.addr)

proc stbtt_GetCodepointKernAdvance(
  fontInfo: FontInfo,
  ch1, ch2: cint
): cint {.importc: "stbtt_GetCodepointKernAdvance", stbcall.}

proc getCodepointKernAdvance*(fontInfo: FontInfo, left, right: Rune): cint =
  stbtt_GetCodepointKernAdvance(fontInfo, left.cint, right.cint)

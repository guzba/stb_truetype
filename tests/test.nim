import stb_truetype, unicode

block:
  let stbtt = initFont(readFile("tests/data/Roboto-Regular.ttf"))

  var ascent, descent, lineGap: cint
  stbtt.getFontVMetrics(ascent, descent, lineGap)

  doAssert ascent == 1900
  doAssert descent == -500
  doAssert lineGap == 0

  var advanceWidth, leftSideBearing: cint
  stbtt.getCodepointHMetrics(Rune('r'), advanceWidth, leftSideBearing)

  doAssert advanceWidth == 694
  doAssert leftSideBearing == 141

  doAssert stbtt.getCodepointKernAdvance(Rune('r'), Rune('a')) == -40

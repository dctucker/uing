# From https://ring-lang.github.io/doc1.14/libui.html#draw-gradient

import std/sugar
import std/colors

import uing
from uing/rawui import nil

proc rect(ctx: ptr DrawContext, x, y, width, height: float, r, g, b: int, a: float = 1f) = 
  var 
    brush: DrawBrush
    path = newDrawPath(DrawFillModeWinding)

  brush.r = cdouble (r/255)
  brush.g = cdouble (g/255)
  brush.b = cdouble (b/255)
  brush.a = cdouble a

  path.addRectangle(x, y, width, height)
  `end` path
  ctx.fill(path, addr brush)
  free path

proc drawHandler(a: ptr AreaHandler; area: ptr rawui.Area; p: ptr AreaDrawParams) {.cdecl.} =
  rect(p.context, 0, 0, p.areaWidth, p.areaHeight, 0, 0, 255)

  for y in countup(0, 255, 2):
    let color = Color(y).extractRGB()
    rect(p.context, 0, float y, p.areaWidth, float (1+y), color.r, color.g, color.b)

proc main = 
  let window = newWindow("Gradient", 500, 500)

  var handler: AreaHandler
  handler.draw = drawHandler
  handler.mouseEvent = (_: ptr AreaHandler, a: ptr rawui.Area, b: ptr AreaMouseEvent) {.cdecl.} => (discard)
  handler.mouseCrossed = (_: ptr AreaHandler, a: ptr rawui.Area, b: cint) {.cdecl.} => (discard)
  handler.dragBroken = (_: ptr AreaHandler, a: ptr rawui.Area) {.cdecl.} => (discard)
  handler.keyEvent = (_: ptr AreaHandler, a: ptr rawui.Area, b: ptr AreaKeyEvent) {.cdecl.} => cint 0

  let area = newArea(addr handler)
  window.child = area

  show window
  mainLoop()

when isMainModule:
  init()
  main()
  
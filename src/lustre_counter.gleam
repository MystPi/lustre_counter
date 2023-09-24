import gleam/int
import gleam/float
import lustre
import lustre/element.{text}
import lustre/element/html.{button, div, p}
import lustre/event.{on_click}
import lustre/attribute.{class, disabled, style}

// MAIN ------------------------------------------------------------------------

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "[data-lustre-app]", Nil)

  Nil
}

// MODEL -----------------------------------------------------------------------

type Model =
  Int

fn init(_) -> Model {
  0
}

// UPDATE ---------------------------------------------------------------------

type Msg {
  Incr
  Decr
  Reset
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    Incr -> model + 1
    Decr -> model - 1
    Reset -> 0
  }
}

// VIEW -----------------------------------------------------------------------

const btn = "bg-violet-100/75 backdrop-blur text-violet-700 px-4 py-1 rounded-full font-bold transition hover:bg-violet-200/75 hover:scale-110 disabled:pointer-events-none disabled:bg-white"

fn view(model: Model) {
  let count = int.to_string(model)

  let buttons = [
    button(
      [class(btn), disabled(model == 0), on_click(Decr)],
      [text("Decrease")],
    ),
    button([class(btn), on_click(Incr)], [text("Increase")]),
    button([class(btn), disabled(model == 0), on_click(Reset)], [text("Reset")]),
  ]

  let counter =
    p(
      [
        class("text-6xl font-bold text-transparent bg-clip-text bg-gradient-to-br from-violet-500 to-violet-800 transition -z-10"),
        style([scale_style(model)]),
      ],
      [text(count)],
    )

  div(
    [
      class(
        "w-screen h-screen flex flex-col gap-4 justify-center items-center overflow-hidden select-none",
      ),
    ],
    [counter, div([class("flex gap-3 items-center")], buttons)],
  )
}

fn scale_style(count: Int) -> #(String, String) {
  let count = int.to_float(count)

  let scale =
    count /. 10.0 +. 1.0
    |> float.to_string

  #("transform", "scale(" <> scale <> ")")
}

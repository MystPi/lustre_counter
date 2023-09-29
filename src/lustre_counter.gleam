import gleam/int
import gleam/dynamic
import gleam/result
import lustre
import lustre/element.{text}
import lustre/element/html.{button, div, input, p}
import lustre/event.{on_click, on_input}
import lustre/attribute.{attribute, class, disabled, placeholder, type_, value}

// MAIN ------------------------------------------------------------------------

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "[data-lustre-app]", 0)

  Nil
}

// MODEL -----------------------------------------------------------------------

type Model {
  Model(count: Int, typed: String, change_by: Int)
}

fn init(count) -> Model {
  Model(count, typed: "", change_by: 1)
}

// UPDATE ---------------------------------------------------------------------

type Msg {
  Changed(ChangeType)
  Typed(String)
}

type ChangeType {
  Incr
  Decr
  Reset
}

fn update(model: Model, msg: Msg) -> Model {
  let Model(count, typed, change_by) = model

  case msg {
    Changed(change_type) -> {
      let count = case change_type {
        Incr -> count + change_by
        Decr -> count - change_by
        Reset -> 0
      }

      Model(count, typed, change_by)
    }

    Typed(typed) -> {
      let change_by = result.unwrap(int.parse(typed), 1)

      Model(count, typed, change_by)
    }
  }
}

// VIEW -----------------------------------------------------------------------

const btn_style = "bg-violet-50 backdrop-blur text-violet-700 px-4 py-1 rounded-full font-bold transition hover:bg-violet-100 hover:scale-110 disabled:pointer-events-none disabled:bg-white"

const input_style = "col-span-3 border-b-2 border-violet-500 bg-violet-50 px-2 py-1 rounded-md text-violet-700 font-bold placeholder:font-normal placeholder:text-violet-300"

fn view(model: Model) {
  let Model(count, typed, change_by) = model

  let count_str = int.to_string(count)
  let change_by_str = int.to_string(change_by)

  let toolbar =
    div(
      [class("grid grid-cols-3 gap-3 w-96")],
      [
        button(
          [
            class(btn_style),
            disabled(count == 0),
            on_click(Changed(Decr)),
            attribute("title", "-" <> change_by_str),
          ],
          [text("Decrease")],
        ),
        button(
          [
            class(btn_style),
            on_click(Changed(Incr)),
            attribute("title", "+" <> change_by_str),
          ],
          [text("Increase")],
        ),
        button(
          [class(btn_style), disabled(count == 0), on_click(Changed(Reset))],
          [text("Reset")],
        ),
        input([
          class(input_style),
          type_("number"),
          value(dynamic.from(typed)),
          placeholder("Change by (default: 1)"),
          on_input(Typed),
        ]),
      ],
    )

  let counter =
    p(
      [
        class(
          "text-6xl font-bold text-transparent bg-clip-text bg-gradient-to-br from-violet-500 to-violet-800 transition -z-10",
        ),
      ],
      [text(count_str)],
    )

  div(
    [
      class(
        "w-screen h-screen flex flex-col gap-4 justify-center items-center overflow-hidden select-none",
      ),
    ],
    [counter, toolbar],
  )
}

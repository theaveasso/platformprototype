# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Godot 4.6 2D platformer prototype (Forward+ renderer, D3D12 on Windows, Jolt Physics).

## Running / Testing

There is no CLI test suite — this is a Godot project, opened and run from the editor.

- Main scene: `playground.tscn` (configured via `project.godot` → `run/main_scene`).
- Run from editor: F5 (main scene) / F6 (current scene).
- Headless run: `godot --path . --main-pack` or `godot --path . res://playground.tscn` from a shell with the Godot 4.6 binary in PATH.

## Display configuration

The viewport is **480×270** with a window override of **1920×1080** and `canvas_items` stretch mode. Default texture filter is `0` (nearest-neighbor). Treat this as a pixel-art project — do not introduce assets or filtering that assume linear scaling.

## Player state machine (the one non-obvious thing)

`player/scripts/player.gd` implements a stack-based finite state machine that spans multiple files. Understand this before editing player or state code.

- All concrete states (`player/states/state_*.gd`) extend `PlayerState` (`player/states/00_player_state.gd`).
- States are added as `Node` children under the player's `States` node in `player.tscn`. `Player.init_states()` auto-discovers every `PlayerState` child — adding a new state means: (1) create `state_xxx.gd` extending `PlayerState`, (2) add it as a `Node` child of `States` in the scene with the script attached. No registration code to update.
- `Player.states` is a stack, not a single field. `curr_state` is `states.front()`; `prev_state` is `states[1]`. `update_state()` pushes the new state to the front and `resize`s back to `MAX_STATE_SIZE = 3`, so the last two prior states are retained for transition logic.
- Each `process` / `physics_process` tick, the current state's matching method runs and **returns the next state** (or `null` to stay). `Player._process` / `_physics_process` feed that return value into `update_state()`.
- `enter()` / `exit()` fire on transitions; `init()` fires once at startup. The base class prints in each — keep override behavior consistent or strip the prints when adding real logic.

When adding a state, wire transitions by setting the appropriate `PlayerState.next_state` references (commonly assigned in `init()` of states that need to know about siblings) and returning them from `process` / `physics_process`.

## Input map

Defined in `project.godot`. Actions: `Left` (A / Arrow-Left), `Right` (D / Arrow-Right), `Up` (W / Arrow-Up), `Down` (S / Arrow-Down). `Player.update_direction()` reads them via `Input.get_vector("Left", "Right", "Up", "Down")`.

## Conventions

- GDScript with `class_name` declarations; reference types by class name rather than path.
- `.uid` files next to scripts/scenes are Godot-managed — commit them, don't hand-edit.
- Scene `unique_id=` values are also Godot-managed; preserve them when editing `.tscn` files by hand.

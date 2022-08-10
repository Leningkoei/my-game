# my-game

## Declare

- project from https://www.youtube.com/playlist?list=PLKOjO9JzryE-iCMIfOmBLkTzwJsvkzwI2

### Resource

#### fonts

- Cica: https://github.com/miiton/Cica/releases/download/v5.0.3/Cica_v5.0.3.zip

- KFひま字: https://www.kfstudio.net/download/1415/KFhimaji.zip

#### images

- background: https://commons.nicovideo.jp/material/nc261519

- kiritan: https://seiga.nicovideo.jp/seiga/im8026365

## Warning

- modified package `cl-sdl2-ttf`, at `src/helpers.lisp` 24th line `nreverse` -> `reverse`

## Usage

<img>./.github/result.jpg</img>

## Installation

- `git clone https://github.com/Leningkoei/my-game.git`

- `cd my-game && qlot install`

- `qlot exec ros run`

- `(asdf:load-system :my-game)`

- `(my-game:main)`

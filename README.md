# connecttic

A mix between the classic Connect 4 and Tic-Tac-Toe

## Attribution

- **Game Design**
  - KittKat
  - *Artist*
- **Programming**
  - KittKat
- **Music**
  - *Artist*

## Dev

```mermaid
---
title: ConnectTic UML

config:
    class:
        hideEmptyMembersBox: true
---

%%{init: {'themeVariables': { 'fontFamily': 'Jetbrains Mono', 'fontSize': '14px'}}}%%
classDiagram
    note for Game "Handles all game logic"
    Game ..> Player
    Game ..> Pos
    Game ..> Board 
    Game ..> GameStatus
    class Game {
        -List~Player~ players
        -List~Pos?~ lastPlay
        -Board board
        -int currentPlayer
        -Function displayChangeCallback
        -GameStatus status

        -updateGameStatus()
        -getWinSet() List~Pos~
        -canPlay(Player player, Pos pos) bool
        -onBoardUpdate()
        +isOver() bool
        +play(Player player, Pos pos) bool
        +getCurrentPlayer() Player
        -checkWinRow()
        -checkWinCol()
        -checkWinDiag()
        -checkWinDiagR()
        -hasEmptyTile() bool
        +toJSON() String
    }

    class GameStatus {
        +DRAW
        +WINNER
        +ACTIVE
    }
    
    class Player {
        +String username
        +String coin
        +String color
    }
    
    note for AIPlayer "requestMove called when AI players turn"
    AIPlayer ..> BoardViewer
    Player <|-- AIPlayer
    class AIPlayer {

        -Determine Move Logic()
        +requestMove(BoardViewer boardViewer) Pos
    }
    
    class Pos {
        +int x
        +int y
    }
    
    Board ..> Pos
    class Board {
        -int width, height
        -const int defaultWidth, defaultHeight
        ~list~list~int~~ board
        
        +set(Pos pos, int i)
        +get(Pos pos) int
        +isOnBoard(Pos pos) bool
        +mark(Pos pos)
        +unmark(Pos pos)
    }
    
    BoardViewer ..> Board 
    class BoardViewer {
        -Board board
        +get(Pos pos) int
    }
    
    note for Display "Either updates the local display, or informes clients to update their display"
    Display <..> Game
    Display ..> Player
    class Display {

    }
    
```




```
Display
Game Manager (handles working with local or remote game)
Game
```


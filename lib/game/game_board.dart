import 'dart:math';

import 'package:ChessApp/game/components/piece.dart';
import 'package:ChessApp/game/components/square.dart';
import 'package:flutter/material.dart';

import 'components/dead_piece.dart';
import 'helper/helper_method.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late List<List<ChessPiece?>> board;

  List<List<int>> validMoves = [];

  List<ChessPiece> whitePiecesTake = [];
  List<ChessPiece> blackPiecesTake = [];

  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];

  ChessPiece? selectedPiece;

  int selectedRow = -1;
  int selectedCol = -1;

  bool isWhiteTurn = true;
  bool checkStatus = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
              child: GridView.builder(
                  itemCount: whitePiecesTake.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
                  itemBuilder: (context, index){
                    return DeadPiece(
                        imagePath: whitePiecesTake[index].imagePath,
                        isWhite: whitePiecesTake[index].isWhite
                    );
              })
          ),
          Text(
            checkStatus ? "Check!" : ""
          ),
          Expanded(
            flex: 3,
            child: GridView.builder(
                itemCount: 8 * 8,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
                itemBuilder: (context, index) {
                  int row = index ~/ 8;
                  int col = index % 8;

                  bool isSelected = selectedRow == row && selectedCol == col;

                  bool isValidMove = false;

                  for (var position in validMoves){
                    if(position[0] == row && position[1] == col){
                      isValidMove = true;
                    }
                  }

                  return Square(
                    isWhite: isWhite(index),
                    piece: board[row][col],
                    isSelected: isSelected,
                    onTap: () => pieceSelected(row, col),
                    isValidMove: isValidMove,
                  );
                }
            ),
          ),
          Expanded(
              child: GridView.builder(
                  itemCount: blackPiecesTake.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
                  itemBuilder: (context, index){
                    return DeadPiece(
                        imagePath: blackPiecesTake[index].imagePath,
                        isWhite: blackPiecesTake[index].isWhite
                    );
                  })
          ),
        ],
      ),
    );
  }
  void _initializeBoard(){
    late List<List<ChessPiece?>> newBoard = List.generate(8, (index) => List.generate(8, (index) => null));


    // Place pawns
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
          type: ChessPieceType.pawn,
          isWhite: false,
          imagePath: 'assets/pieces/pawn.png'
      );
      newBoard[6][i] = ChessPiece(
          type: ChessPieceType.pawn,
          isWhite: true,
          imagePath: 'assets/pieces/pawn.png'
      );
    }
    // Place Rooks
    newBoard[0][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imagePath: 'assets/pieces/rook.png'
    );
    newBoard[0][7] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imagePath: 'assets/pieces/rook.png'
    );
    newBoard[7][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: true,
        imagePath: 'assets/pieces/rook.png'
    );
    newBoard[7][7] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: true,
        imagePath: 'assets/pieces/rook.png'
    );

    // Place Knights
    newBoard[0][1] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: false,
        imagePath: 'assets/pieces/knight.png'
    );
    newBoard[0][6] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: false,
        imagePath: 'assets/pieces/knight.png'
    );
    newBoard[7][1] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: true,
        imagePath: 'assets/pieces/knight.png'
    );
    newBoard[7][6] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: true,
        imagePath: 'assets/pieces/knight.png'
    );

    // Place Bishops
    newBoard[0][2] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: false,
        imagePath: 'assets/pieces/bishop.png'
    );
    newBoard[0][5] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: false,
        imagePath: 'assets/pieces/bishop.png'
    );
    newBoard[7][2] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: true,
        imagePath: 'assets/pieces/bishop.png'
    );
    newBoard[7][5] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: true,
        imagePath: 'assets/pieces/bishop.png'
    );

    // Place Queens
    newBoard[0][3] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: false,
        imagePath: 'assets/pieces/queen.png'
    );
    newBoard[7][3] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: true,
        imagePath: 'assets/pieces/queen.png'
    );

    // Place Kings
    newBoard[0][4] = ChessPiece(
        type: ChessPieceType.king,
        isWhite: false,
        imagePath: 'assets/pieces/king.png'
    );
    newBoard[7][4] = ChessPiece(
        type: ChessPieceType.king,
        isWhite: true,
        imagePath: 'assets/pieces/king.png'
    );

    board = newBoard;
  }
  void resetGame(){
    Navigator.pop(context);
    _initializeBoard();
    checkStatus = false;
    whitePiecesTake.clear();
    blackPiecesTake.clear();
    whiteKingPosition = [7, 4];
    blackKingPosition = [0, 4];
    isWhiteTurn = true;
    setState(() {

    });
  }
  void pieceSelected(int row, int col){
    setState(() {
      if(selectedPiece == null && board[row][col] != null){
        if(board[row][col]!.isWhite == isWhiteTurn){
          selectedPiece = board[row][col];
          selectedRow = row;
          selectedCol = col;
        }
      } else if(board[row][col] != null &&
        board[row][col]!.isWhite == selectedPiece!.isWhite) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      } else if(selectedPiece != null && validMoves.any((test) => test[0] == row && test[1] == col)){
        movePiece(row, col);
      }

      validMoves = calculateRealValidMoves(selectedRow, selectedCol, selectedPiece, true);
    });
  }
  void movePiece(int newRow, newCol){
    if(board[newRow][newCol] != null) {
      var capturedPiece = board[newRow][newCol];
      if(capturedPiece!.isWhite){
        whitePiecesTake.add(capturedPiece);
      } else {
        blackPiecesTake.add(capturedPiece);
      }
    }

    if(selectedPiece!.type == ChessPieceType.king){
      if(selectedPiece!.isWhite){
        whiteKingPosition = [newRow, newCol];
      } else {
        blackKingPosition = [newRow, newCol];
      }
    }

    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    if(isKingInCheck(!isWhiteTurn)){
      checkStatus = true;
    } else {
      checkStatus = false;
    }


    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];

    });

    if(isCheckMate(!isWhiteTurn)){
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Check Mate!"),
            actions: [
              TextButton(
                  onPressed: resetGame,
                  child: Text("Rematch")
              )
            ],
          )
      );
    }

    isWhiteTurn = !isWhiteTurn;
  }

  List<List<int>> calculateRawValidMoves(int row, col, ChessPiece? piece) {
    List<List<int>> candidateMoves = [];

    if(piece == null){
      return [];
    }

    int direction  = piece.isWhite ? -1 : 1;

    switch (piece.type) {
      case ChessPieceType.pawn:
        // Pawns can move forward if the square is not occupied
        if(isInBoard(row + direction, col)
            && board[row + direction][col] == null){
          candidateMoves.add([row + direction, col]);
        }
        // Pawn can move 2 squares forward if they  are at their intial position
        if((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)){
          if(isInBoard(row + 2 * direction, col) &&
            board[row + 2 * direction][col] == null &&
            board[row + direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }
        // Pawn can kill diagonally
        if(isInBoard(row + direction, col - 1) &&
          board[row + direction][col - 1] != null &&
          board[row + direction][col - 1] !.isWhite != piece.isWhite){
          candidateMoves.add([row + direction, col - 1]);
        }
        if(isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1] !.isWhite != piece.isWhite){
          candidateMoves.add([row + direction, col + 1]);
        }
        break;
      case ChessPieceType.rook:
        // horizontal and vertical directions
        var directions = [
          [-1,0], // Up
          [1,0],  // Down
          [0,-1], // Left
          [0,1], // Right
        ];

        for(var direction in directions){
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if(!isInBoard(newRow, newCol)){
              break;
            }
            if(board[newRow][newCol] != null){
              if(board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }

        break;
      case ChessPieceType.knight:
        // all eight possible L shapes the knight can move
        var knightMoves = [
          [-2, -1], // up 2 left 1
          [-2, 1], // up 2 right 1
          [-1, -2], // up 1 left 2
          [-1, 2], // up 1 right 2
          [1, -2], // down 1 left 2
          [1, 2], // down 1 right 2
          [2, -1], // down 2 left 1
          [2, 1], // down 2 right 1
        ];

        for (var move in knightMoves){
          var newRow = row + move[0];
          var newCol = col + move[1];
          if(!isInBoard(newRow,newCol)){
            continue;
          }
          if(board[newRow][newCol]!= null){
            if(board[newRow][newCol]!.isWhite != piece.isWhite){
              candidateMoves.add([newRow, newCol]);
            }
            continue;
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
      case ChessPieceType.bishop:
        // Diagonal directions
        var directions = [
          [-1, -1], // Up left
          [-1, 1], // Up right
          [1, -1], // Down left
          [1, 1], // Down right
        ];
        for(var direction in directions){
          var i = 1;
          while (true){
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if(!isInBoard(newRow, newCol)){
              break;
            }
            if(board[newRow][newCol] != null){
              if(board[newRow][newCol]!.isWhite != piece.isWhite){
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.queen:
        // All eight  directions: up, down, left, right and 4 diagonal
        var directions = [
          [-1, 0], // Up
          [1, 0], // Down
          [0, -1], // Left
          [0, 1], // Right
          [-1, -1], // Up left
          [-1, 1], // Up right
          [1, -1], // Down left
          [1, 1], // Down right
        ];

        for(var direction in directions){
          var i = 1;
          while(true){
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if(!isInBoard(newRow, newCol)){
              break;
            }
            if(board[newRow][newCol] != null){
              if(board[newRow][newCol]!.isWhite != piece.isWhite){
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.king:
      // All eight  directions: up, down, left, right and 4 diagonal
        var directions = [
          [-1, 0], // Up
          [1, 0], // Down
          [0, -1], // Left
          [0, 1], // Right
          [-1, -1], // Up left
          [-1, 1], // Up right
          [1, -1], // Down left
          [1, 1], // Down right
        ];

        for(var direction in directions){
          var newRow = row + direction[0];
          var newCol = col + direction[1];
          if(!isInBoard(newRow, newCol)){
            continue;
          }
          if(board[newRow][newCol] != null){
            if(board[newRow][newCol]!.isWhite != piece.isWhite){
              candidateMoves.add([newRow, newCol]);
            }
            continue;
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
      default:
    }
    return candidateMoves;
  }
  List<List<int>> calculateRealValidMoves(int row, col, ChessPiece? piece, bool checkSimulation){
    List<List<int>> realValidMoves = [];
    List<List<int>> candidateMoves = calculateRawValidMoves(row, col, piece);

    if(checkSimulation){
      for(var move in candidateMoves){
        int endRow = move[0];
        int endCol = move[1];

        if (simulateMovesIsSafe(piece!, row, col, endRow, endCol)){
          realValidMoves.add(move);
        }
      }
    } else {
      realValidMoves = candidateMoves;
    }
    return realValidMoves;
  }

  bool isCheckMate(bool isWhiteKing){
    if(!isKingInCheck(isWhiteKing)){
      return false;
    }

    for(int i = 0; i < 8; i++){
      for(int j = 0; j < 8; j++){
        if(board[i][j] == null || board[i][j]!.isWhite != isWhiteKing){
          continue;
        }
        List<List<int>> pieceValidMove = calculateRealValidMoves(i, j, board[i][j], true);
        if(pieceValidMove.isNotEmpty){
          return false;
        }
      }
    }
    return true;
  }
  bool isKingInCheck(bool isWhiteKing)  {

    List<int> kingPosition = isWhiteKing ? whiteKingPosition : blackKingPosition;

    for(int i = 0; i < 8; i++){
      for(int j = 0; j < 8; j++){
        if(board[i][j] == null || board[i][j]!.isWhite == isWhiteKing){
          continue;
        }
        List<List<int>> pieceValidMode = calculateRealValidMoves(i, j, board[i][j], false);
        if(pieceValidMode.any((move) => move[0] == kingPosition[0] && move[1] == kingPosition[1])){
          return true;
        }
      }
    }
    return false;
  }
  bool simulateMovesIsSafe(ChessPiece piece, int startRow, int startCol, int endRow, int endCol){
    ChessPiece? originalDestinationPiece = board[endRow][endCol];

    List<int>? originalKingPosition;
    if(piece.type==ChessPieceType.king) {
      originalKingPosition = piece.isWhite ? whiteKingPosition : blackKingPosition;

      if(piece.isWhite){
        whiteKingPosition = [endRow, endCol];
      } else {
        blackKingPosition = [endRow, endCol];
      }
    }

    board[endRow][endCol] = piece;
    board[startRow][startCol] = null;

    bool kingInCheck = isKingInCheck(piece.isWhite);

    board[startRow][startCol] = piece;
    board[endRow][endCol] = originalDestinationPiece;

    if(piece.type == ChessPieceType.king){
      if(piece.isWhite){
        whiteKingPosition = originalKingPosition!;
      } else {
        blackKingPosition = originalKingPosition!;
      }
    }
    return !kingInCheck;
  }
}

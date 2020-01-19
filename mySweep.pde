/** MySweep -- AKA MineSweeper
  * @Author: Allen Thoe
  */

int numCells, mines, counter, score;
float w;
boolean firstClick;

Cell[][] cell;
void setup(){
   size(1000,500);
   numCells = 10;
   mines = 20;
   score  = mines;
   w = height/numCells;
   cell = new Cell[2*numCells][numCells];
   for(int i = 0; i < cell.length; i++){
     for(int j = 0; j < cell[0].length; j++){
       cell[i][j] = new Cell(i,j);
     }
   }
   placeMines();

   textSize(w);
}

void draw(){
   background(0);
   for(int i = 0; i < cell.length; i++){
     for(int j = 0; j < cell[0].length; j++){
       cell[i][j].show();
     }
   }  
   endGame();
}

void mousePressed(){
   int a = (int)mouseX/(int)w;
   int b = (int)mouseY/(int)w;   
   if(firstClick){
      if(mouseButton == RIGHT){
        //FLAGGING WITH RIGHT CLICK -- CHECK MINES TO 0
        if(cell[a][b].isFlagged){
          if(cell[a][b].isMine){
            score++;
          }
          cell[a][b].isFlagged = false;
        } else {
          if(cell[a][b].isMine){
            score--;
          }
          cell[a][b].isFlagged = true;
        }
        //LEFT CLICK BUTTON EVENTS
      } else {
        checkCell(a,b);
      }
  } else {
    cell[a-1][b-1].isMine = false;
    cell[a-1][b].isMine = false;
    cell[a-1][b+1].isMine = false;
    cell[a][b-1].isMine = false;
    cell[a][b+1].isMine = false;
    cell[a+1][b-1].isMine = false;
    cell[a+1][b].isMine = false;
    cell[a+1][b+1].isMine = false;
    countMines();    
    firstClick = true;
   
  }

    
}

void checkCell(int a, int b){
    cell[a][b].isRevealed = true;
    //USE RECURSION TO OPEN ALL THE 0's
    if(cell[a][b].count == 0 && !cell[a][b].isMine){
      //LEFT THREE
      if(a > 0 && b > 0 && !cell[a-1][b-1].isRevealed){
        checkCell(a-1,b-1);
      }
      if(a > 0 && !cell[a-1][b].isRevealed){
        checkCell(a-1,b);
      }  
      if(a > 0 && b < cell[0].length-1 && !cell[a-1][b+1].isRevealed){
        checkCell(a-1,b+1);
      }
      //RIGHT THREE
      if(a < cell.length-1 && b > 0 && !cell[a+1][b-1].isRevealed){
        checkCell(a+1,b-1);
      }
      if(a < cell.length-1 && !cell[a+1][b].isRevealed){
        checkCell(a+1,b);
      }  
      if(a < cell.length-1 && b < cell[0].length-1 && !cell[a+1][b+1].isRevealed){
        checkCell(a+1,b+1);
      }    
      //Middle Two!
      if(b > 0 && !cell[a][b-1].isRevealed){
        checkCell(a,b-1);
      }
      if(b < cell[0].length-1 && !cell[a][b+1].isRevealed){
        checkCell(a,b+1);
      }       
      
      
    }
    if(cell[a][b].isMine){
      revealAll();
    } 
}
void endGame(){
   if(score == 0){
     revealAll();
   }
}
void revealAll(){
   for(int i = 0; i < cell.length; i++){
     for(int j = 0; j < cell[0].length; j++){
       cell[i][j].isRevealed = true;
     }
   }  
}
void placeMines(){
  while(mines > 0){
    int a = (int)random(cell.length);
    int b = (int)random(cell[0].length);
    if(!cell[a][b].isMine){
      cell[a][b].isMine = true;
      mines--;
    }
  }
}

void countMines(){
   for(int i = 0; i < cell.length; i++){
     for(int j = 0; j < cell[0].length; j++){
       counter = 0;
       if(i > 0 && j > 0){
         if(cell[i-1][j-1].isMine){ counter++; }
       }
       if(i > 0){
         if(cell[i-1][j].isMine){ counter++; }
       }
       if(i > 0 && j < cell[0].length-1){
         if(cell[i-1][j+1].isMine){ counter++; }
       }
       if(j > 0){
         if(cell[i][j-1].isMine){ counter++; }
       }
       if(j < cell[0].length-1){
         if(cell[i][j+1].isMine){ counter++; }
       }
       if(i < cell.length-1 && j > 0){
         if(cell[i+1][j-1].isMine){ counter++; }
       }
       if(i < cell.length-1){
         if(cell[i+1][j].isMine){ counter++; }
       }
       if(i < cell.length-1 && j < cell[0].length-1){
         if(cell[i+1][j+1].isMine){ counter++; }
       }
       cell[i][j].count = counter;
     }
   } 
}

class Cell{
  
   int x, y;
   boolean isMine;
   boolean isRevealed;
   boolean isFlagged;
   int count;
   
   Cell(int x, int y){
      this.x = x;
      this.y = y;
   }
   
   void show(){

      if(isRevealed){
        if(isMine){
          fill(0);
        } else {
          fill(255);
        }
        rect(x*w, y*w, w, w);
        fill(0,0,255);
        if(count == 1){
          fill(255,0,0);
        }
        if(count != 0 && !isMine){
          text(count, x*w, (y+1)*w);
        }
      } else if(isFlagged){
        fill(255,0,0);
        rect(x*w, y*w, w, w);
      } else {
        fill(255);
        rect(x*w, y*w, w, w);
      }
  
       
     }
  
}

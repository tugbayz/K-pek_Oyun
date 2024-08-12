PImage playerImage, dogImage, enemyImage, bgImage;
PImage[] costumes = new PImage[5];
int[] costumePrices = {50, 100, 150, 200, 250};
boolean[] ownedCostumes = {false, false, false, false, false};
int selectedCostume = -1;
int playerX, playerY;
int playerSize = 80;
int dogX, dogY;
boolean gameOver = false;
boolean gameWon = false;
boolean gameStarted = false;
boolean inShop = false;
boolean introShown = false;
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
int enemySpawnTime = 80;
int currentTime = 0;
int buttonX, buttonY, buttonWidth, buttonHeight;
color buttonColor, buttonHoverColor;
int level = 1;
int spawnMargin = 130;
int score = 0;
int highScore = 0;
int gold = 0;
ArrayList<Wall> walls = new ArrayList<Wall>();

void setup() {
  size(800, 600);
  textSize(32);
  textAlign(CENTER, CENTER);
  buttonWidth = 200;
  buttonHeight = 100;
  buttonX = width / 2 - buttonWidth / 2;
  buttonY = height / 2 - buttonHeight / 2;
  buttonColor = color(0, 0, 255);
  buttonHoverColor = color(0, 0, 200);
  
  playerImage = loadImage("insan.png");
  dogImage = loadImage("kopek.png");
  enemyImage = loadImage("araba.png");
  bgImage = loadImage("yol.png");
  
  questions = new Question[3];
  questions[0] = new Question("Bir köpek ne der?", new String[]{"Miyav", "Cik", "Möö", "Hav"}, 3);
  questions[1] = new Question("Köpeğin en sevdiği yemek nedir?", new String[]{"Pizza", "Kemik", "Elma", "Balık"}, 1);
  questions[2] = new Question("Köpeklerin hangi hayvan ile arası bozuktur?", new String[]{"İnek", "Maymyn", "Kedi", "At"}, 2);
  
  for (int i = 0; i < costumes.length; i++) {
    costumes[i] = loadImage("kopekElbise" + (i+1) + ".png");
  }

  bgImage.resize(width, height);
  resetGame();
}

void draw() {
  background(bgImage);

  if (!introShown) {
    background(0);
    fill(255);
    text("Köpeğinle yürüyüşe çıktın...", width / 2, height / 2 - 150);
    text("Ama yoldan geçen yaşlı teyze ters takla attı", width / 2, height / 2 - 100);
    text("onu izlerken köpeğine bakmayı unuttun!!!", width / 2, height / 2 - 50);
    text("Köpeğin yolun karşısına geçti..", width / 2, height / 2);
    text("Onu kurtarman lazım! Arabalara çarpmadan karşıya geç", width / 2, height / 2 + 50);
    text("Labirentte köpeğini bul! Bulmacayı çöz!", width / 2, height / 2 + 100);
    
    textSize(16);
    textAlign(RIGHT, BOTTOM);
    text("Karakteri WASD ile hareket ettir.", width - 10, height - 10);
    textAlign(CENTER, CENTER);
    textSize(32);

    textSize(16);
    textAlign(LEFT, BOTTOM);
    text("Bölümlerde ilerledikçe arabalar hızlanır!!.", 10, height - 10);
    textAlign(CENTER, CENTER);
    textSize(32);

    if (mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY + 200 && mouseY < buttonY + 200 + buttonHeight) {
      fill(buttonHoverColor);
    } else {
      fill(buttonColor);
    }
    rect(buttonX, buttonY + 200, buttonWidth, buttonHeight, 20);
    
    fill(255);
    text("Oyuna Geç", buttonX + buttonWidth / 2, buttonY + 100 + buttonHeight / 2 + 100);
  } else if (!gameStarted && !inShop) {
    background(bgImage);
    fill(255);
    text("Köpek Kurtarma Oyunu'na Hoş Geldiniz!", width / 2, height / 2 - 200);
    text("En Yüksek Puan: " + highScore, width / 2, height / 2 - 150);
    text("Altın: " + gold, width / 2, height / 2 - 100);
    
    if (mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight) {
      fill(buttonHoverColor);
    } else {
      fill(buttonColor);
    }
    rect(buttonX, buttonY, buttonWidth, buttonHeight, 20);
    
    fill(255);
    text("Başlat", buttonX + buttonWidth / 2, buttonY + buttonHeight / 2);
    
    if (mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY + 120 && mouseY < buttonY + 120 + buttonHeight) {
      fill(buttonHoverColor);
    } else {
      fill(buttonColor);
    }
    rect(buttonX, buttonY + 120, buttonWidth, buttonHeight, 20);
    
    fill(255);
    text("Mağaza", buttonX + buttonWidth / 2, buttonY + 120 + buttonHeight / 2);
  } else if (inShop) {
    background(255, 190, 210);
    fill(0);
    text("Mağaza", width / 2, 50);
    text("Altın: " + gold, width / 2 + 40, 100);
    
    for (int i = 0; i < costumes.length; i++) {
      if (selectedCostume == i) {
        fill(0, 255, 0);
      } else if (ownedCostumes[i]) {
        fill(255, 165, 0);
      } else {
        fill(255, 0, 0);
      }
      rect(50, 100 + i * 100, 80, 80);
      image(costumes[i], 50, 100 + i * 100, 80, 80);
      fill(0);
      text(costumePrices[i] + " Altın", 190, 140 + i * 100);
    }
    
    if (mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight) {
      fill(buttonHoverColor);
    } else {
      fill(buttonColor);
    }
    rect(buttonX, buttonY, buttonWidth, buttonHeight, 20);
    
    fill(255);
    text("Geri", buttonX + buttonWidth / 2, buttonY + buttonHeight / 2);
  } else if (!gameOver && !gameWon) {
    fill(255);
    text("Seviye: " + level, width / 2, 30);
    text("Puan: " + score, width / 4, 30);
    text("Altın: " + gold, 3 * width / 4, 30);
    
    if (level <= 5) {
      image(playerImage, playerX, playerY, playerSize, playerSize);
      image(dogImage, dogX, dogY, playerSize, playerSize);
      
      currentTime++;
      if (currentTime >= enemySpawnTime) {
        enemies.add(new Enemy());
        currentTime = 0;
      }
      
      for (Enemy enemy : enemies) {
        enemy.move();
        enemy.display();
        if (enemy.hits(playerX, playerY, playerSize - 44)) {
          gameOver = true;
          if (score > highScore) {
            highScore = score;
          }
          break;
        }
      }
      
      if (keyPressed) {
        if (key == 'a' || key == 'A') {
          playerX -= 5;
        }
        if (key == 'd' || key == 'D') {
          playerX += 5;
        }
        if (key == 'w' || key == 'W') {
          playerY -= 5;
        }
        if (key == 's' || key == 'S') {
          playerY += 5;
        }
        
        playerX = constrain(playerX, 0, width - playerSize);
        playerY = constrain(playerY, 0, height - playerSize);
      }
      
      if (playerX < dogX + playerSize && playerX + playerSize > dogX && playerY < dogY + playerSize && playerY + playerSize > dogY) {
        level++;
        gold += level * 10;
        score += level * 100;
        resetGame();
      }
    } else if(level > 5 && level <=8) {
      drawMazeLevel();
    } else if(level > 8) {
      background(200);
      fill(255);
      text("Seviye: " + level, width / 2, 30);
      text("Puan: " + score, width / 4, 30);
      text("Altın: " + gold, 3 * width / 4, 30);
      questions[currentQuestion].display();
    
      if (answered) {
        textSize(32);
        if (correct) {
          if(level==12){
            gameWon=true;
          }
          else{
          fill(0, 255, 0);  // Yeşil
          text("Doğru cevap!", width / 2 - textWidth("Doğru cevap!") / 2, 350);
          }
        } else {
          fill(255, 0, 0);  // Kırmızı
          gameOver=true;

        }
      }
    }
  } else {
    if (gameOver) {
      fill(255, 0, 0);
      text("Oyun Bitti! Yeniden Başlamak için 'R'ye Bas", width / 2, height / 2);
    } else if (gameWon) {
      fill(0, 255, 0);
      text("Kazandın! Yeniden Başlamak için 'R'ye Bas", width / 2, height / 2);
    }
  }
}

void drawMazeLevel() {
  background(200);
  for (Wall wall : walls) {
    wall.display();
          fill(255);
    text("Seviye: " + level, width / 2, 30);
    text("Puan: " + score, width / 4, 30);
    text("Altın: " + gold, 3 * width / 4, 30);
  
  }
  
  image(playerImage, playerX, playerY, playerSize, playerSize);
  image(dogImage, dogX, dogY, playerSize, playerSize);

  if (keyPressed) {
    int tempX = playerX;
    int tempY = playerY;

    if (key == 'a' || key == 'A') {
      tempX -= 5;
    }
    if (key == 'd' || key == 'D') {
      tempX += 5;
    }
    if (key == 'w' || key == 'W') {
      tempY -= 5;
    }
    if (key == 's' || key == 'S') {
      tempY += 5;
    }

    boolean collision = false;
    for (Wall wall : walls) {
      if (wall.hits(tempX, tempY, playerSize)) {
        collision = true;
        break;
      }
    }

    if (!collision) {
      playerX = tempX;
      playerY = tempY;
    }
  }

  if (playerX < dogX + playerSize && playerX + playerSize > dogX && playerY < dogY + playerSize && playerY + playerSize > dogY) {
      level++;
      gold += level * 10;
      score += level * 100;
      resetGame();
  }
}

void resetGame() {
  playerX = 0;
  playerY = height / 2 - playerSize / 2;
  dogX = width - playerSize;
  dogY = height / 2 - playerSize / 2;
  gameOver = false;
  gameWon = false;
  enemies.clear();
  walls.clear();
  currentTime = 0;
  enemySpawnTime = max(20, 60 - 5 * (level - 1));

  if (level > 5) {
    generateMaze();
  }
}


void generateMaze() {
  walls.clear();  // Önceki duvarları temizle

  if (level == 6) {
    // Labirent 1 konfigürasyonu
    walls.add(new Wall(0, -5, width, 10));  // Üst duvar
    walls.add(new Wall(-5, 0, 10, 700));  // Sol duvar
    walls.add(new Wall(0, height-5, width, 10));  // Alt duvar
    walls.add(new Wall(width - 4, 0, 10, 700));  // Sağ duvar
    
    walls.add(new Wall(130, 0, 10, 500));  // Sol duvar
    walls.add(new Wall(260, height - 500, 10, 500));  // Sol duvar
    walls.add(new Wall(390, 0, 10, 500));  // Sol duvar
    walls.add(new Wall(520, height - 500, 10, 500));  // Sol duvar
  } else if (level == 8) {
    // Labirent 1 konfigürasyonu
    walls.add(new Wall(0, -5, width, 10));  // Üst duvar
    walls.add(new Wall(-5, 0, 10, 700));  // Sol duvar
    walls.add(new Wall(0, height-5, width, 10));  // Alt duvar
    walls.add(new Wall(width - 4, 0, 10, 700));  // Sağ duvar
    
    walls.add(new Wall(130, 100, 10, 400));  // Sol duvar
    walls.add(new Wall(260, height - 250, 10, 250));  // Sol duvar
    walls.add(new Wall(260, 0, 10, 250));  // Sol duvar
    
    walls.add(new Wall(390, 100, 10, 400));  // Sol duvar
    walls.add(new Wall(520, height - 250, 10, 250));  // Sol duvar
    walls.add(new Wall(520, 0, 10, 250));  // Sol duvar
  } else if (level == 7) {
    // Labirent 3 konfigürasyonu
    walls.add(new Wall(0, -5, width, 10));  // Üst duvar
    walls.add(new Wall(-5, 0, 10, 700));  // Sol duvar
    walls.add(new Wall(0, height-5, width, 10));  // Alt duvar
    walls.add(new Wall(width - 4, 0, 10, 700));  // Sağ duvar
    
    walls.add(new Wall(110, 0, 10, 500));  // Sol duvar
    walls.add(new Wall(110, height -110 , 300, 10));  // Alt duvar
    walls.add(new Wall(550, height -110 , 300, 10));  // Alt duvar
    walls.add(new Wall(410, 200, 10, 300));  // Sol duvar
    walls.add(new Wall(550, 100, 10, 400));  // Sol duvar
    walls.add(new Wall(260, 100 , 300, 10));  // Alt duvar
    walls.add(new Wall(260, 100, 10, 285));  // Sol duvar
    walls.add(new Wall(650, 0, 10, 400));  // Sol duvar
  }


}


void keyPressed() {
  if ((gameOver || gameWon) && (key == 'r' || key == 'R')) {
    gameStarted = false;
    inShop = false;
    level = 1;
    score = 0; 
    resetGame();
  }
}

void mousePressed() {
  if (!introShown && mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY + 200 && mouseY < buttonY + 200 + buttonHeight) {
    introShown = true;
  } else if (!gameStarted && !inShop && introShown && mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight) {
    gameStarted = true;
    resetGame();
  } else if (!gameStarted && !inShop && introShown && mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY + 120 && mouseY < buttonY + 120 + buttonHeight) {
    inShop = true;
  } else if (inShop && mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight) {
    inShop = false;
  }

  if (inShop) {
    for (int i = 0; i < costumes.length; i++) {
      if (mouseX > 50 && mouseX < 130 && mouseY > 100 + i * 100 && mouseY < 180 + i * 100) {
        if (!ownedCostumes[i] && gold >= costumePrices[i]) {
          gold -= costumePrices[i];
          ownedCostumes[i] = true;
        } else if (ownedCostumes[i]) {
          selectedCostume = i;
          dogImage = costumes[i];
        }
      }
    }
  }
  if(gameStarted && !inShop && introShown && level>8 ){
    if (!answered) {
    for (int i = 0; i < 4; i++) {
      if (mouseX > width / 2 - 150 && mouseX < width / 2 + 150 &&
          mouseY > 150 + i * 60 && mouseY < 200 + i * 60) {
        answerClicked[i] = true;
        answered = true;
        
        if (questions[currentQuestion].checkAnswer(i)) {
          correct = true;
            gold += level * 10;
            score += level * 100;
            level++;
            resetGame();
        } else {
          correct = false;
        }

      }
    }
  } else {
    if (correct) {
      currentQuestion++;
      if (currentQuestion >= questions.length) {
        currentQuestion = 0; // Oyunu başa döndür veya oyunu bitir
      }
    }
    // Yeni soruya geç
    answered = false;
    correct = false;
    answerClicked = new boolean[4];
  }
  }
}

class Enemy {
  int x, y;
  int size = 100;
  int speed;
  
  Enemy() {
    x = floor(random((width / 8) + 10 , 3 * width / 4 ));
    y = 0;
    speed = 2 + level;
  }
  
  void move() {
    y += speed;
  }
  
  void display() {
    image(enemyImage, x, y, size, size);
  }
  
  boolean hits(int px, int py, int pSize) {
    return x < px + pSize && x + size - 20 > px && y < py + pSize && y + size > py;
  }
}

class Wall {
  int x, y, w, h;

  Wall(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void display() {
    fill(0);
    rect(x, y, w, h);
  }

  boolean hits(int px, int py, int pSize) {
    return px < x + w && px + pSize > x && py < y + h && py + pSize > y;
  }
}

Question[] questions;
int currentQuestion = 0;
boolean[] answerClicked = new boolean[4];
boolean answered = false;
boolean correct = false; 

class Question {
  String question;
  String[] answers;
  int correctAnswer;

  Question(String q, String[] a, int correct) {
    question = q;
    answers = a;
    correctAnswer = correct;
  }

  void display() {
    textSize(24);
    fill(0);
    textAlign(CENTER);
    text(question, width / 2, 100);

    for (int i = 0; i < answers.length; i++) {
      if (answerClicked[i]) {
        if (i == correctAnswer) {
          fill(0, 255, 0);  // Yeşil
        } else {
          fill(255, 0, 0);  // Kırmızı
        }
      } else {
        fill(255);
      }
      stroke(0);
      rect(width / 2 - 150, 150 + i * 60, 300, 50);

      fill(0);
      text(answers[i], width / 2 - textWidth(answers[i]) / 2, 150 + i * 60 + 35);

    }
  }

  boolean checkAnswer(int index) {
    return index == correctAnswer;
  }
}

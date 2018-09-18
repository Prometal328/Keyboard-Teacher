void mainMenu() { //<>//
  start.show(mainMenuVisibility);
  startButtonClicked();
  settings.show(mainMenuVisibility);
  settingsButtonClicked();
  progress.show(mainMenuVisibility);
  progressButtonClicked();
}

void startMenu() {
  if (hardModeActive) {
    //textToWrite.selfHeight = 580;
    //textToWrite.y = 320;
    //indicatorsBar.y = height - 100;
  } else {
    keyboard.staticShow(startMenuVisibility);
    //textToWrite.selfHeight = 275;
    //textToWrite.y = 275 / 2 + 25;
    //indicatorsBar.y = height - (3 * 60 + 230);
    keyboard();
  }
  if (exerciseActive) textToWrite.text = "";
  textToWrite.staticShow(startMenuVisibility);
  indicatorsBar.staticShow(startMenuVisibility);
  restartExercise.show(restartExerciseButtonVisibility);
  restartExerciseButtonClicked();
  exercise();
}

void settingsMenu() {
  easyMode.show(settingsMenuVisibility);
  easyModeButtonClicked();
  normalMode.show(settingsMenuVisibility);
  normalModeButtonClicked();
  hardMode.show(settingsMenuVisibility);
  hardModeButtonClicked();
  selectText.show(settingsMenuVisibility);
}

void progressMenu() {
  addUser.show(progressMenuVisibility);
  addUserButtonClicked();
  removeUser.show(progressMenuVisibility);
  removeUserButtonClicked();
  if (userNameBoxVisibility != 0) userNameBox.staticShow(userNameBoxVisibility); 
  else userData.staticShow(progressMenuVisibility);
  for (int i = 0; i < everySingleUser.length; i++) everySingleUser[i].show(progressMenuVisibility);

  if (userNameWritable) {
    textSize(userNameBox.textSize);
    if (keyPressed && writable) {
      if (key == ENTER) {
        String[] TEST = new String[1];
        TEST[0] = "CREATION Date " + day() + "/" + month() + "/" + year() + "  Hour " + hour() + ":" + minute() + ":" + second();
        saveStrings((userName + ".txt"), TEST);
        users = append(users, userName);
        saveStrings("Users.txt", users);
        everySingleUser = new Button[users.length];
        for (int i = 0; i < everySingleUser.length; i++) everySingleUser[i] = new Button(50 + (250 / 2), 50 + 50 + 10 + 25 + i * 60, 250, 50, users[i]);
        userNameWritable = false;
        userName = "";
        addUser.text = "Add User";
      }
      if (key == BACKSPACE && userName.length() > 0) userName = userName.substring(0, userName.length() - 1);
      else if (key != CODED && key != '.' && key != '?' && textWidth(userNameBox.text) < userNameBox.selfWidth - 60) userName += key; 
      lastKey = key;
      writable = false;
      userNameBox.text = userName;
    }
    if (!writable && ((key != lastKey) || (!keyPressed && key == lastKey))) writable = true;
  } else if (!writable || lastKey != ' ') {
    writable = true;
    lastKey = ' ';
  }

  for (int i = 0; i < everySingleUser.length; i++) {
    if (everySingleUser[i].selfClicked() && progressMenuOpened && !userRemovable) {
      currentUser.text = "user: " + everySingleUser[i].text;
      setting[1] = everySingleUser[i].text;
      saveStrings("Settings.txt", setting);
      currentUserData = loadStrings(everySingleUser[i].text + ".txt");
      userData.text = currentUserData[0];
    } else if (everySingleUser[i].selfClicked() && progressMenuOpened && userRemovable && everySingleUser[i].text != "standard") {
      if (currentUser.text.substring(6) == everySingleUser[i].text) {
        currentUser.text = "user: standard";
        setting[1] = "standard";
        saveStrings("Settings.txt", setting);
        print(currentUser.text.substring(6));
      }
    }
  }
}

void keyboard() { // CHECK LATER boolean function!
  if (startMenuOpened && startMenuVisibility >= 150) {
    for (int i = 0; i < keysOfKeyboard.length; i++) {
      if (keysOfKeyboard[i].text.charAt(0) == unwrittenText.charAt(writtenText.length()) && keysOfKeyboard[i].text.length() == 1 && (keyPressed == false || key == CODED) && exerciseActive) {
        keysOfKeyboard[i].setColors(0, 255, 0);
        keysOfKeyboard[i].staticShow(startMenuVisibility);
      } else {
        int currentLayer = 0;
        if (keysOfKeyboard[i].layer == currentLayer) keysOfKeyboard[i].show(startMenuVisibility);
        if (key != CODED) currentLayer = 1; 
        if (keyCode == SHIFT && keyPressed) currentLayer = 2; 
        else if (keyCode == CONTROL && keyPressed) currentLayer = 3;
        else currentLayer = 1; 
        if (keysOfKeyboard[i].layer == currentLayer) keysOfKeyboard[i].show(startMenuVisibility);
      }
    }
  }
}

void exercise() {
  if (keyPressed && !exerciseActive && exerciseActivable) {
    exerciseActive = true;
    exerciseActivable = false;
    textToWrite.text = "";
    frame = 0;
    keyPressed = false;
  }

  if (exerciseActive) {
    textAlign(LEFT, CENTER);
    textSize(25);
    if (keyPressed && key != '\t' && key != CODED && writable) {
      writtenText += key;
      if (key == unwrittenText.charAt(writtenText.length() - 1)) {
        correctText += key;
        wrongText += '░';
      } else {
        correctText += '░';
        wrongText += key;
      }
      lastKey = key;
      writable = false;
      String substitute = unwrittenText;
      unwrittenText = " ";
      for (int i = 1; i < writtenText.length(); i++) unwrittenText += ' ';          
      if (writtenText.length() < substitute.length()) unwrittenText += substitute.substring(writtenText.length());
      beats++;
    }
    if (!writable && ((key != lastKey) || (!keyPressed && key == lastKey))) writable = true;

    matrix = assignText(unwrittenText);
    display(color(/*200, 200, 200,*/100, 100, 100, startMenuVisibility), matrix, MAX_ROWS, MAX_COLUMNS, 249, 65);
    if (easyModeActive) {     
      matrix = assignText(correctText);
      display(color(0, 255, 0, startMenuVisibility), matrix, MAX_ROWS, MAX_COLUMNS, 249, 65);
      matrix = assignText(wrongText);
      display(color(255, 0, 0, startMenuVisibility), matrix, MAX_ROWS, MAX_COLUMNS, 249, 65);
    } else {
      matrix = assignText(writtenText);
      display(color(/*0, 0, 0,*/255, 255, 255, startMenuVisibility), matrix, MAX_ROWS, MAX_COLUMNS, 249, 65);
    }
    textAlign(CENTER, CENTER);

    indicators();

    if (writtenText.length() >= unwrittenText.length() && exerciseActive) {
      exerciseActive = false;
      exerciseActivable = false;

      String[] ses = loadStrings(currentUser.text.substring(6) + ".txt");
      ses = append(ses, "Date " + day() + "/" + month() + "/" + year() + "  Hour " + hour() + ":" + minute() + ":" + second() + " " + textToWrite.text);
      saveStrings(currentUser.text.substring(6) + ".txt", ses);
      textToWrite.text += " \n[EXERCISE IS OVER, GOOD JOB!]";
      textToWrite.staticShow(300);
      unwrittenText = sentences[int(random(0, sentences.length - 1))];
      writtenText = "";
      correctText = "";
      wrongText = "";
    }
  }
}

void indicators() {  
  frame++;
  if (frame >= int(frameRate) || second == 0) {
    second++;
    frame = 0;
  }

  if (hardModeActive) {
    //beatsPerMinute.setCoordinates(width / 2 - 306, height - 123);
    //charactersToWriteBox.setCoordinates(width / 2 - 306, height - 77);
    //writtenCharactersBox.setCoordinates(width / 2, height - 77);
    //time.setCoordinates(width / 2, height - 123);
    //percentageOfCompletion.setCoordinates(width / 2 + 306, height - 123);
    //percentageOfCorrectText.setCoordinates(width / 2 + 306, height - 77);
  } else {
    //beatsPerMinute.setCoordinates(width / 2 - 306, height - 433);
    //charactersToWriteBox.setCoordinates(width / 2 - 306, height - 387);
    //writtenCharactersBox.setCoordinates(width / 2, height - 387);
    //time.setCoordinates(width / 2, height - 433);
    //percentageOfCompletion.setCoordinates(width / 2 + 306, height - 433);
    //percentageOfCorrectText.setCoordinates(width / 2 + 306, height - 387);
  }

  int charactersToWrite = unwrittenText.length(), writtenCharacters = writtenText.length(), correctCharacters = 0;
  for (int i = 0; i < writtenText.length(); i++) if (correctText.charAt(i) != '░') correctCharacters++;

  if (writtenCharacters == 0) writtenCharacters = 1;
  beatsPerMinute.text = "BEATS/MINUTE: " + int(beats * 60 / second);
  percentageOfCompletion.text = "COMPLETION: " + int((writtenCharacters * 100) / charactersToWrite) + "%";
  percentageOfCorrectText.text = "CORRECT TEXT: " + int((correctCharacters * 100) / writtenCharacters) + "%";
  writtenCharactersBox.text = "WRITTEN CHARACTERS: " + writtenCharacters;
  charactersToWriteBox.text = "CHARACTERS TO WRITE: " + charactersToWrite;
  time.text = "TIME: " + second; 

  textToWrite.text = beatsPerMinute.text + " \n" + writtenCharactersBox.text + " \n" + time.text + " \n" + percentageOfCorrectText.text;

  beatsPerMinute.staticShow(startMenuVisibility);
  charactersToWriteBox.staticShow(startMenuVisibility);
  writtenCharactersBox.staticShow(startMenuVisibility);
  time.staticShow(startMenuVisibility);
  percentageOfCompletion.staticShow(startMenuVisibility);
  percentageOfCorrectText.staticShow(startMenuVisibility);
}


char[][] assignText(String text) {
  char[][] array = new char[MAX_ROWS][MAX_COLUMNS];
  int row = 0, index = 0;
  for (int column = 0; column < MAX_COLUMNS && row < MAX_ROWS; column++) {
    if (index < text.length()) array[row][column] = text.charAt(index);
    else array[row][column] = '░';
    if (column == MAX_COLUMNS - 1 && row < MAX_ROWS - 1) {
      row++;
      column = -1;
    }
    index++;
  }
  return array;
}

void display(color textFill, char text[][], int rows, int columns, int x, int y) {
  fill(textFill);
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < columns; j++) {
      if (text[i][j] != '░') {
        text(matrix[i][j], x + j * 10, y + i * 27);
      }
    }
  }
}

void resetText() {
  textToWrite.text = "[press a key to start]";
  unwrittenText = sentences[int(random(0, sentences.length - 1))];
  writtenText = "";
  correctText = "";
  wrongText = "";
  beats = 0;
}

void changeMenuVisibility() { // Function switching from a menu to another
  if (mainMenuOpened && mainMenuVisibility != 300 && backMenuVisibility == 0) {
    mainMenuVisibility += transitionSpeed;
  } else if (!mainMenuOpened && mainMenuVisibility != 0 && backMenuVisibility == 0) {
    mainMenuVisibility -= transitionSpeed;
  } else if (!mainMenuOpened && backMenuOpened && mainMenuVisibility == 0 && backMenuVisibility != 300) {
    backMenuVisibility += transitionSpeed;
    if (settingsMenuOpened && settingsMenuVisibility != 300) settingsMenuVisibility += transitionSpeed;
    else if (startMenuOpened && startMenuVisibility != 300) startMenuVisibility += transitionSpeed;
    else if (progressMenuOpened && progressMenuVisibility != 300) progressMenuVisibility += transitionSpeed;
    else if (exerciseActive && restartExerciseButtonVisibility != 300) restartExerciseButtonVisibility += transitionSpeed;
  } else if (mainMenuOpened && mainMenuVisibility == 0 && backMenuVisibility != 0) {
    backMenuVisibility -= transitionSpeed;
    if (!settingsMenuOpened && settingsMenuVisibility != 0) settingsMenuVisibility -= transitionSpeed;    
    if (!startMenuOpened && startMenuVisibility != 0) startMenuVisibility -= transitionSpeed;
    if (!progressMenuOpened && progressMenuVisibility != 0) progressMenuVisibility -= transitionSpeed;
    if (!exerciseActive && restartExerciseButtonVisibility != 0) restartExerciseButtonVisibility -= transitionSpeed;
  }
  if (userNameWritable && userNameBoxVisibility != 300) userNameBoxVisibility += transitionSpeed;
  else if (!userNameWritable && userNameBoxVisibility != 0) userNameBoxVisibility -= transitionSpeed;
  if ((exerciseActive || (!exerciseActive && !exerciseActivable)) && restartExerciseButtonVisibility != 300) restartExerciseButtonVisibility += transitionSpeed;
  else if (!exerciseActive && restartExerciseButtonVisibility != 0) restartExerciseButtonVisibility -= transitionSpeed;
  if (((!mainMenuOpened && settingsMenuOpened || progressMenuOpened) || (mainMenuOpened && !settingsMenuOpened && !progressMenuOpened)) && startMenuVisibility == 0) {
    currentMode.staticShow(300);
    currentUser.staticShow(300);
  } else {
    currentMode.staticShow(mainMenuVisibility + settingsMenuVisibility + progressMenuVisibility);
    currentUser.staticShow(mainMenuVisibility + settingsMenuVisibility + progressMenuVisibility);
  }
}

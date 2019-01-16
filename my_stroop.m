sca;
close all;
clear all;

username = input('What is your name? \n', 's');

%% Creating Stimuli %%

stimuli = cell(2,20);
wordColor = cell(1,5);
inkColor = cell(1,5);

wordColor{1} = 'red';
wordColor{2} = 'green';
wordColor{3} = 'blue';
wordColor{4} = 'orange';
wordColor{5} = 'purple';
inkColor{1} = 'red';
inkColor{2} = 'green';
inkColor{3} = 'blue';
inkColor{4} = 'orange';
inkColor{5} = 'purple';

for ii = 1:5
    stimuli{1,ii} = wordColor{ii};
    stimuli{1,ii+5} = wordColor{ii};
    stimuli{1,ii+10} = wordColor{ii};
    stimuli{1,ii+15} = wordColor{ii};
    stimuli{2,ii} = inkColor{ii};
    stimuli{2,ii+5} = inkColor{ii};
end

inConflict = false;

while ~inConflict
    randomConflict = zeros(1,10);
    randomConflict(1,1:5) = randperm(5);
    randomConflict(1,6:10) = randperm(5);
    for ii = 1:10
        if (randomConflict(ii) == ii)
            inConflict = false;
            break
        elseif (randomConflict(ii) == (ii - 5))
            inConflict = false;
            break
        else
            inConflict = true;
        end
    end
end

for ii = 1:10
    stimuli{2,ii+10} = inkColor{randomConflict(ii)};
end

randomOrder = randperm(20);

practiceStimuli = cell(2,5);
randPractice = randperm(5);

for ii = 1:5
    practiceStimuli{1,ii} = wordColor{ii};
    practiceStimuli{2,ii} = inkColor{randPractice(ii)};
end

%% Setting up %%

screens = Screen('Screens');
screenNumber = max(screens);
Screen('Preference', 'SkipSyncTests', 1)

black = BlackIndex(screenNumber);
white = WhiteIndex(screenNumber);
gray = white/2;

[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

ifi = Screen('GetFlipInterval', window);

%% Instructions %%

hasAnswered = false;
escapeKey = KbName('q');
targetKey = KbName('space');

Screen('TextSize', window, 20);
Screen('TextFont', window, 'Courier');
DrawFormattedText(window, 'Instruction:', .1*screenXpixels, .3*screenYpixels, [0 0 0]);
DrawFormattedText(window, 'In this experiment, you are asked to name the color of some words or patches.',...
    .1*screenXpixels, .5*screenYpixels, [0 0 0]);
DrawFormattedText(window, 'If you are ready, press the ''SPACEBAR'' to continue.',.1*screenXpixels, .6*screenYpixels, [0 0 0]);
Screen('Flip', window);

while ~hasAnswered
    [keyIsDown, secs, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(escapeKey)
            sca;
            return;
        elseif keyCode(targetKey)
            hasAnswered = true;
        end
    end
end

hasAnswered = false;
keyIsDown = false;

DrawFormattedText(window, 'Task 1:', .1*screenXpixels, .2*screenYpixels, [0 0 0]);
wrappedString = WrapString('In this task, you will see some color words (e.g. blue). The words are printed in other ink colors, for example you may see the word ''blue'' is printed in red. Your job is to name the ink color of the word regardless of what the word says. Please indicate your response by pressing the initial letter of that color. For example, if you see the word ''blue'' printed in magenta, please press m on your keyboard. Similarly, if you see the word ''green'' printed in orange, please press o on your keyboard.');
DrawFormattedText(window, wrappedString, .1*screenXpixels, .3*screenYpixels, [0 0 0]);
DrawFormattedText(window, 'Let''s do some practice first, press ''SPACEBAR'' to continue.',.1*screenXpixels, .6*screenYpixels, [0 0 0]);
Screen('Flip', window);

while ~hasAnswered
    [keyIsDown, secs, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(escapeKey)
            sca;
            return;
        elseif keyCode(targetKey)
            hasAnswered = true;
        end
    end
end

%% Practice %%

practiceError = zeros(1,5);

for ii = 1:5
    hasAnswered = false;
    trialError = 0;
    currentColor = practiceStimuli{2,ii};

    if currentColor == "red"
        RGB = [255 0 0];
        key_char = 'r';
    elseif currentColor == "green"
        RGB = [0 255 0];
        key_char = 'g';
    elseif currentColor == "blue"
        RGB = [0 0 255];
        key_char = 'b';
    elseif currentColor == "orange"
        RGB = [255 125 0];
        key_char = 'o';
    elseif currentColor == "purple"
        RGB = [255 0 255];
        key_char = 'p';
    end
    targetKey = KbName(key_char);
    Screen('TextSize', window, 80);
    DrawFormattedText(window, practiceStimuli{1,ii}, 'center', 'center', RGB);
    Screen('Flip', window);
    while ~hasAnswered
        [secs, keyCode] = KbStrokeWait;
            if keyCode(escapeKey)
                sca;
                return;
            elseif keyCode(targetKey)
                hasAnswered = true;
            elseif KbName(keyCode) ~= currentColor
                trialError = trialError + 1;
            end
    end
    practiceError(ii) = trialError;
end

%% Task 1 Introduction %%

hasAnswered = false;
escapeKey = KbName('q');
targetKey = KbName('space');

Screen('TextSize', window, 20);
DrawFormattedText(window, 'Task 1:', .1*screenXpixels, .2*screenYpixels, [0 0 0]);
wrappedString = WrapString('Ok, now you get the idea. Let''s start the formal task, press ''SPACEBAR'' to continue.');
DrawFormattedText(window, wrappedString, .1*screenXpixels, .3*screenYpixels, [0 0 0]);
DrawFormattedText(window, '****** Go as fast as you can while being accurate ********', .1*screenXpixels, .6*screenYpixels, [0 0 0]);
DrawFormattedText(window, 'Remember, name the ink color, not what the word says!', .1*screenXpixels, .7*screenYpixels, [0 0 0]);
Screen('Flip', window);

while ~hasAnswered
    [keyIsDown, secs, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(escapeKey)
            sca;
            return;
        elseif keyCode(targetKey)
            hasAnswered = true;
        end
    end
end

%% Task 1 %%

task1Error = zeros(1,20);
rt1 = zeros(1,20);
StroopTestData = cell(30,5);

for ii = 1:20
    hasAnswered = false;
    trialError = 0;
    currentColor = stimuli{2,randomOrder(ii)};
    if currentColor == "red"
        RGB = [255 0 0];
        key_char = 'r';
    elseif currentColor == "green"
        RGB = [0 255 0];
        key_char = 'g';
    elseif currentColor == "blue"
        RGB = [0 0 255];
        key_char = 'b';
    elseif currentColor == "orange"
        RGB = [255 125 0];
        key_char = 'o';
    elseif currentColor == "purple"
        RGB = [255 0 255];
        key_char = 'p';
    end
    targetKey = KbName(key_char);
    Screen('TextSize', window, 80);
    DrawFormattedText(window, stimuli{1,randomOrder(ii)}, 'center', 'center', RGB);
    Screen('Flip', window);
    tic;
    while ~hasAnswered
        [secs, keyCode] = KbStrokeWait;
        if keyCode(escapeKey)
            sca;
            return;
        elseif keyCode(targetKey)
            hasAnswered = true;
            tElapsed = toc;
        elseif KbName(keyCode) ~= currentColor
            trialError = trialError + 1;
        end
    end
    task1Error(ii) = trialError;
    rt1(ii) = tElapsed;
    StroopTestData{ii,1} = ii;
    if randomOrder(ii) <= 10
        StroopTestData{ii,2} = 2;
    elseif (randomOrder(ii) > 10) && (randomOrder(ii) <= 20)
        StroopTestData{ii,2} = 1;
    end
    StroopTestData{ii,3} = [stimuli{1,randomOrder(ii)} '_' currentColor];
    StroopTestData{ii,4} = rt1(ii);
    StroopTestData{ii,5} = task1Error(ii);
end

%% Task 2 Introduction %%

hasAnswered = false;
keyIsDown = false;
targetKey = KbName('space');

Screen('TextSize', window, 20);
DrawFormattedText(window, 'Task 2:', .1*screenXpixels, .2*screenYpixels, [0 0 0]);
wrappedString = WrapString('In this task, you will see some color blocks. Your job is to name the ink color of the color blocks. Please indicate your response by pressing the initial letter of that color. For example, if you see a red color block, please press r on your keyboard. Similarly, if you see an orange color block, please press o on your keyboard.');
DrawFormattedText(window, wrappedString, .1*screenXpixels, .3*screenYpixels, [0 0 0]);
DrawFormattedText(window, 'Press ''SPACEBAR'' to continue.',.1*screenXpixels, .6*screenYpixels, [0 0 0]);
Screen('Flip', window);

while ~hasAnswered
    [keyIsDown, secs, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(escapeKey)
            sca;
            return;
        elseif keyCode(targetKey)
            hasAnswered = true;
        end
    end
end

%% Task 2 %%

blockStimuli = cell(1,10);
randomBlock = randperm(10);
centerX = screenXpixels/2;
centerY = screenYpixels/2;
rect = [(centerX - .2*screenXpixels) (centerY - .2*screenYpixels) (centerX + .2*screenXpixels) (centerY + .2*screenYpixels)];

task2Error = zeros(1,10);
rt2 = zeros(1,10);

for ii = 1:5
blockStimuli{ii} = stimuli{2,ii};
blockStimuli{ii+5} = stimuli{2,ii};
end

for ii = 1:10
    hasAnswered = false;
    trialError = 0;
    currentColor = blockStimuli{1,randomBlock(ii)};

    if currentColor == "red"
        RGB = [255 0 0];
        key_char = 'r';
    elseif currentColor == "green"
        RGB = [0 255 0];
        key_char = 'g';
    elseif currentColor == "blue"
        RGB = [0 0 255];
        key_char = 'b';
    elseif currentColor == "orange"
        RGB = [255 125 0];
        key_char = 'o';
    elseif currentColor == "purple"
        RGB = [255 0 255];
        key_char = 'p';
    end
    targetKey = KbName(key_char);
    Screen('FillRect', window, RGB, rect);
    Screen('Flip', window);
    tic
    while ~hasAnswered
        [secs, keyCode] = KbStrokeWait;
        if keyCode(escapeKey)
            sca;
            return;
        elseif keyCode(targetKey)
            hasAnswered = true;
            tElapsed = toc;
        elseif KbName(keyCode) ~= currentColor
            trialError = trialError + 1;
        end
    end
    task2Error(ii) = trialError;
    rt2(ii) = tElapsed;
    StroopTestData{ii+20,1} = ii+20;
    StroopTestData{ii+20,2} = 0;
    StroopTestData{ii+20,3} = [currentColor];
    StroopTestData{ii+20,4} = rt2(ii);
    StroopTestData{ii+20,5} = task2Error(ii);
end

close all;
sca;

%% Stroop Data csv file %%
fid = fopen(['stroopData' username '.csv'], 'w');
fprintf(fid, '%s, %s, %s, %s, %s, \n', "Frame ID", "Condition", "Stimulus", "Reaction Time", "Error");

for ii = 1:30
    fprintf(fid, '%f, %f, %s, %.4f, %f, \n', StroopTestData{ii,1:5});
end

fclose(fid);
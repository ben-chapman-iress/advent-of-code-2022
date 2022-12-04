/*
Masterplan Part 1
-----------------

Read file
let total = 0
For each line
  Split string in half
  For each character in the first string, see if it exists in the second.
    If it does, that is the important character
  Find the score for that character, add it to "total"
    If uppercase, add 26
Print total
*/

const NUMBER_OF_LETTERS_IN_THE_ALPHABET = 26;
const GROUP_SIZE = 3;

// ------------------------------------
// I'd never read a file from disk before, so let's comment this to detail what's going on...
// ------------------------------------

// Get areference to the file input element
let file = document.getElementById('file');

// Attach change event listener which will fire every time a new file is selected
// This doesn't seem to be able to cope with arrow function syntax :(
file.addEventListener('change', function () {
  // 1 - define a new file reader
  let reader = new FileReader();

  // 2 - define what happens when the file has finished loading
  reader.onload = function () {
    // 4 - the file has finished loading, and the contents appear in this.result
    processFileContents(this.result);
  };

  // 3 - read the file in - when done, "onload" will be fired
  reader.readAsText(this.files[0]);
});

const processFileContents = (fileContents) => {
  let rucksacks = fileContents.split('\n'); // \n represents LF (Unix) line breaks
  let part1Total = getPart1Total(rucksacks);
  let part2Total = calculatePart2Total(rucksacks);
  
  document.getElementById('part1').innerText = part1Total;
  document.getElementById('part2').innerText = part2Total;
};

const getPart1Total = (rucksacks) => {
  let total = 0;

  rucksacks.forEach((rucksack) => total += getRucksackPriority(rucksack));

  return total;
};

const calculatePart2Total = (rucksacks) => {
  let total = 0;
  let group = [];

  rucksacks.forEach((rucksack) => {
    group.push(rucksack);

    if (group.length === GROUP_SIZE) {
      total += getGroupPriority(group);
      group = [];
    }
  });

  return total;
};

function getRucksackPriority(rucksack) {
  if (rucksack.length === 0) {
    return 0;
  }

  let compartmentLength = rucksack.length / 2;
  let firstCompartment = rucksack.slice(0, compartmentLength);
  let secondCompartment = rucksack.slice(compartmentLength);
  let commonItem = getCommonItem(firstCompartment, secondCompartment);
  let priority = getItemPriority(commonItem);

  return priority;
}

function getGroupPriority(group) {
  if (group.length === 0) {
    return 0;
  }

  let commonItem = getCommonItems(...group);
  let priority = getItemPriority(commonItem);

  return priority;
}

const getCommonItem = (firstString, secondString) => {
  let firstStringChars = firstString.split('');
  let duplicateCharacters = firstStringChars.filter(characterFromFirstString => secondString.includes(characterFromFirstString));

  return duplicateCharacters[0] ?? "";
};

const getCommonItems = (firstString, secondString, thirdString) => {
  let firstStringChars = firstString.split('');

  let duplicateCharacters = firstStringChars.filter(characterFromFirstString =>
    secondString.includes(characterFromFirstString) && thirdString.includes(characterFromFirstString));

  return duplicateCharacters[0] ?? "";
};

const getItemPriority = (character) => {
  let number = parseInt(character, 36) - 9;

  if (character === character.toUpperCase()) {
    number += NUMBER_OF_LETTERS_IN_THE_ALPHABET;
  }
  
  return number;
};
function newStr = capitalFirstLetter(str)
    char = convertStringsToChars(str);
    newStr = strcat(upper(char(1)), char(2:end));
    newStr = convertCharsToStrings(newStr);
end
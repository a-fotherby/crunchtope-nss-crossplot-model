%% Find first non-zero element each row in a matrix and compile them into an array.
function outputArray = nonZeroList(inputMatrix)
    arrayDepth = size(inputMatrix, 1);
    outputArray = zeros(1, arrayDepth);
    for i=1:arrayDepth
        firstNonZero = inputMatrix(i, find(inputMatrix(i, :), 1));
        outputArray(1, i) = firstNonZero;
    end
end
function hexdec --description 'converts hexadecimal number to decimal'
    echo "ibase=16; $argv" | bc
end

function dechex --description 'converts decimal number to hexadecimal'
    echo "obase=16; $argv" | bc
end

function hexbin --description 'converts hexadecimal number to binary'
    echo "ibase=16; obase=2; $argv" | bc
end


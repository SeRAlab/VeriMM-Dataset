module detailed_module (
    input g, 
    input h, 
    input i, 
    input j,
    output reg y);assign y = (~g & h & ~i & j) | (~g & ~h & i & j) | (g & h & i & j) | (g & h & ~i & j);

endmodule
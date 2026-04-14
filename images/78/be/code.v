module top_module (
    input g, 
    input h, 
    input i, 
    input j,
    output reg f);assign f = (g & ~h & ~i & j) | (g & h & i & ~j) | (~g & h & i & ~j) | (~g & ~h & i & j) | (~g & h & ~i & ~j);

endmodule
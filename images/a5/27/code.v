module top_module(
    input clk,
    input xstart,
    input xend,
    input [9:0] realy,
    output q
);parameter SCREENWIDTH = 1024;
    parameter SCREENHEIGHT = 768;

    assign q = (xstart == 0 && realy == 0) || 
               (xend == SCREENWIDTH - 1 && realy == 0) || 
               (xstart == 0 && realy == SCREENHEIGHT - 1) || 
               (xend == SCREENWIDTH - 1 && realy == SCREENHEIGHT - 1) || 
               (realy > 0 && realy < SCREENHEIGHT - 1 && (xstart == 0 || xend == SCREENWIDTH - 1));

endmodule
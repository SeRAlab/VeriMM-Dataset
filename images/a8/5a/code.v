module top_module(
    input [3:0] DATA,
    input [1:0] SHIFT,
    output [3:0] OUT
);assign OUT = (SHIFT[1]) ? ({DATA[1:0], DATA[3:2]}) : DATA; // Shift left by 2 positions if SHIFT is 10
    assign OUT = (SHIFT[0]) ? ({OUT[2:0], OUT[3]}) : OUT; // Shift left by 1 position if SHIFT is 01
    assign OUT = (~SHIFT[1] & ~SHIFT[0]) ? DATA : OUT; // No shift if SHIFT is 00
    assign OUT = (~SHIFT[1] & SHIFT[0]) ? ({DATA[2:0], DATA[3]}) : OUT; // Shift right by 1 position if SHIFT is 10
    assign OUT = (SHIFT[1] & ~SHIFT[0]) ? ({DATA[1], DATA[3:1], 1'b0}) : OUT; // Shift left by 3 positions if SHIFT is 11
    assign OUT = (SHIFT[1] & SHIFT[0]) ? ({DATA[0], DATA[3:2]}) : OUT; // Shift right by 2 positions if SHIFT is 11

endmodule
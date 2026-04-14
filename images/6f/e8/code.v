module top_module(
    input [31:0] i,
    output [31:0] o
);assign o = {i[30:0], i[31]}; // Shift left and wrap around

endmodule
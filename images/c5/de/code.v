module barrel_shifter (
    input [15:0] IN,
    input SHIFT, DIR,
    output [15:0] OUT
);

    assign OUT = (SHIFT) ? ((DIR) ? {IN[14:0], 1'b0} : {1'b0, IN[15:1]}) : IN;

endmodule
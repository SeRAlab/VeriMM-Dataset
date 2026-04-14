module right_shifter (
    input [3:0] in,
    output [3:0] out
);

    assign out = in >> 1;

endmodule
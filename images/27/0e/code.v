module comparator (
    input [3:0] A,
    output Y
);
    assign Y = (A > 4'b1000) ? 1'b1 : 1'b0;
endmodule
module comparator_2bit (
    input [1:0] A,
    input [1:0] B,
    output G
);
    assign G = (A > B) ? 1'b1 : 1'b0;
endmodule
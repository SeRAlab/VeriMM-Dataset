module left_shifter(
    input [3:0] a,
    input [1:0] shift_amount,
    output [3:0] result
);
    assign result = a << shift_amount;
endmodule
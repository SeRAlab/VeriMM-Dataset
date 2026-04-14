module top_module(
    input [3:0] A,
    input [3:0] B,
    output [3:0] Y
);// Perform bitwise AND operation without a for loop for combinational logic
    assign Y = A & B;

endmodule
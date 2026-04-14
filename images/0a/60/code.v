module FourBitAdder (
    input [3:0] A,
    input [3:0] B,
    output [3:0] Sum,
    output Carry
);
    wire [4:0] full_sum;

    assign full_sum = A + B; // Compute full sum
    assign Sum = full_sum[3:0]; // Assign lower 4 bits to Sum
    assign Carry = full_sum[4]; // Assign the carry-out
endmodule
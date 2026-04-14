module adder_32bit (
    input [31:0] A,
    input [31:0] B,
    output [31:0] SUM,
    output OVERFLOW
);
    wire [32:0] temp_sum; // One extra bit for carry
    assign temp_sum = {1'b0, A} + {1'b0, B}; // Extend A and B to 33 bits
    assign SUM = temp_sum[31:0];
    assign OVERFLOW = temp_sum[32] ^ temp_sum[31]; // Overflow occurs if carry out is different from the sign bits
endmodule
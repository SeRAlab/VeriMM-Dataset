module adder_16bit (
    input [15:0] a,      // first 16-bit input
    input [15:0] b,      // second 16-bit input
    output [15:0] sum,   // sum output
    output carry_out      // carry out signal
);
    assign {carry_out, sum} = a + b; // Perform addition and calculate carry
endmodule
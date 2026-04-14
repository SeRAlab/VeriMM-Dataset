module eight_bit_adder (
    input  [7:0] a,       // First 8-bit input
    input  [7:0] b,       // Second 8-bit input
    output [8:0] sum      // 9-bit output (8 bits for sum + 1 bit for carry)
);
    assign sum = a + b;   // Sum the inputs
endmodule
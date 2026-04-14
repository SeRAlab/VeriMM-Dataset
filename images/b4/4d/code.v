module top_module(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);wire [7:0] sum;
    wire carry;
    
    assign sum = a + b;
    assign carry = sum[7] ^ a[7] ^ b[7];
    
    assign s = sum;
    assign overflow = carry;
    
endmodule
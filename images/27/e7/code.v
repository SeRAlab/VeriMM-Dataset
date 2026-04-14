module xor_5bit (
    input [4:0] a,
    input [4:0] b,
    output [4:0] y
);
    assign y = a ^ b;
endmodule
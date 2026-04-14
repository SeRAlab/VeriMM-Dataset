module xor_5input(
    input wire [4:0] a,
    output wire y
);
    assign y = a[0] ^ a[1] ^ a[2] ^ a[3] ^ a[4];
endmodule
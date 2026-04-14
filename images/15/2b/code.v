module xnor_5input (
    input wire [4:0] a,  // 5-bit input
    output wire y        // output
);
    assign y = ~(a[0] ^ a[1] ^ a[2] ^ a[3] ^ a[4]); // XNOR gate logic
endmodule
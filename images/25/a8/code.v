module xnor_gate (
    input wire [3:0] a, // 4-inputs
    output wire y // XNOR output
);
    assign y = ~(a[0] ^ a[1] ^ a[2] ^ a[3]); // Even parity check using XNOR logic
endmodule
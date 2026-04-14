module and_gate (
    input wire [4:0] a, // 5-bit input
    output wire y       // output
);
    assign y = &a; // AND operation on all inputs
endmodule
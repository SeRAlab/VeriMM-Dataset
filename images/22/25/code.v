module xnor_gate_4input (
    input wire A,
    input wire B,
    input wire C,
    input wire D,
    output wire Y
);
    assign Y = ~(A ^ B ^ C ^ D);
endmodule
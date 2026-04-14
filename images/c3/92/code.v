module logic_circuit(
    input [7:0] in,
    output [3:0] out
);

    assign out[0] = |in[3:0];   // OR of first four inputs
    assign out[1] = &in[3:0];   // AND of first four inputs
    assign out[2] = |in[7:4];   // OR of last four inputs
    assign out[3] = &in[7:4];   // AND of last four inputs

endmodule
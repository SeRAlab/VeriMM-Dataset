module top_module(
    input a,
    input b,
    input en,
    output out
);wire a_xor_b;
assign a_xor_b = a ^ b;

assign out = en ? a_xor_b : a;

endmodule
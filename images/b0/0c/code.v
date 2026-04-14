module top_module(
    input [3:0] in,
    output and_out,
    output or_out,
    output [1:0] final_out
);wire and1, and2, and3;
wire or1, or2, or3;

// AND Gate definitions
assign and1 = in[0] & in[1];
assign and2 = in[2] & in[3];
assign and3 = and1 & and2;
assign and_out = and3 & 1'b1; // This line can also be simplified as assign and_out = and3;

// OR Gate definitions
assign or1 = in[0] | in[1];
assign or2 = in[2] | in[3];
assign or3 = or1 | or2;
assign or_out = or3 | 1'b0; // This line can also be simplified as assign or_out = or3;

assign final_out = {and_out, or_out};

endmodule
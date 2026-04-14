module top_module( 
    input [3:0] in,
    output out_nand,
    output out_nor,
    output out_xnor
);wire [3:0] inv_in;
wire [3:0] and1_out;
wire [3:0] and2_out;
wire [3:0] and3_out;

// Inverters
assign inv_in = ~in;

// AND gates
assign and1_out = inv_in & {inv_in[2], inv_in[1], inv_in[0]};
assign and2_out = inv_in & {inv_in[3], inv_in[2], inv_in[1]};
assign and3_out = inv_in & {in[3], in[2], in[1], in[0]};

// Outputs
assign out_nand = ~(and1_out[3] & and1_out[2] & and1_out[1] & and1_out[0]);
assign out_nor = ~(and2_out[3] | and2_out[2] | and2_out[1] | and2_out[0]);
assign out_xnor = ~(and3_out[3] ^ and3_out[2] ^ and3_out[1] ^ and3_out[0]);

endmodule
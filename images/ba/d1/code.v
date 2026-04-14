module top_module(AN, BN, C, Z);input AN;
input BN;
input C;
output Z;

wire I0_out;
wire I1_out;
wire I2_out;

and #(0, 0) and1 (I0_out, AN, BN);
not #(0, 0) not1 (I1_out, I0_out);
and #(0, 0) and2 (I2_out, I1_out, C);
not #(0, 0) not2 (Z, I2_out);

endmodule
module top_module( 
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor 
);wire [3:0] mux_sel;
wire [99:0] and_out, or_out, xor_out;

assign mux_sel = 4'b0000; // Selects AND operation
assign and_out = &in;

assign mux_sel = 4'b0001; // Selects OR operation
assign or_out = |in;

assign mux_sel = 4'b0010; // Selects XOR operation
assign xor_out = ^in;

assign out_and = (mux_sel == 4'b0000) ? and_out : 1'b0;
assign out_or = (mux_sel == 4'b0001) ? or_out : 1'b0;
assign out_xor = (mux_sel == 4'b0010) ? xor_out : 1'b0;

endmodule
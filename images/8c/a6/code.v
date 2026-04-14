module top_module(
    input [255:0] in,
    input [7:0] sel,
    output out
);wire [255:0] sel_in;

assign sel_in = {256{sel[7]}};
assign sel_in[7:0] = sel;

assign out = sel_in & in;

endmodule
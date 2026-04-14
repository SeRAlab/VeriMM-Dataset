module top_module(
    input [7:0] data_a,
    input [7:0] data_b,

    output  [7:0] data_hi,
    output  [7:0] data_lo
);assign data_hi = (data_a < data_b) ? data_b : data_a;
	assign data_lo = (data_a < data_b) ? data_a : data_b;endmodule
module top_module(data0, data1, sel, out);input data0;
input data1;
input sel;
output out;

wire not_sel;
assign not_sel = ~sel;

assign out = (data0 & not_sel) | (data1 & sel);

endmodule
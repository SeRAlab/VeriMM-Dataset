module top_module(data0, data1, data2, data3, sel, enable, out);input [3:0] data0, data1, data2, data3;
input [1:0] sel;
input enable;
output out;

wire [1:0] sel_inv;
assign sel_inv = ~sel;

wire [3:0] mux_out;
assign mux_out[0] = (sel_inv[1] & sel_inv[0]) ? data0 : 1'bx;
assign mux_out[1] = (sel_inv[1] & sel[0]) ? data1 : 1'bx;
assign mux_out[2] = (sel[1] & sel_inv[0]) ? data2 : 1'bx;
assign mux_out[3] = (sel[1] & sel[0]) ? data3 : 1'bx;

assign out = enable ? 1'b0 : mux_out[sel];

endmodule
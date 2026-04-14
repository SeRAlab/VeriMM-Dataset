module sw_interface(
input clk,rst,rd,
input [7:0]sw,
output reg[7:0] dout
);
reg [7:0]sw_r;
always @ (posedge clk)sw_r = sw;
always @ (posedge clk)if (rd)dout=sw_r;else dout =0;
endmodule
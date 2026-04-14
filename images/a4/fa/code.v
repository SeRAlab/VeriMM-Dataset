module top_module(
	input [31:0] d,
	output [4:0] clz
);assign clz[4] = d[31:16] == 16'd0;
wire [15:0] d1 = clz[4] ? d[15:0] : d[31:16];

assign clz[3] = d1[15:8] == 8'd0;
wire [7:0] d2 = clz[3] ? d1[7:0] : d1[15:8];

assign clz[2] = d2[7:4] == 4'd0;
wire [3:0] d3 = clz[2] ? d2[3:0] : d2[7:4];

assign clz[1] = d3[3:2] == 2'd0;
wire [1:0] d4 = clz[1] ? d3[1:0] : d3[3:2];

assign clz[0] = d4[1] == 1'b0;

endmodule
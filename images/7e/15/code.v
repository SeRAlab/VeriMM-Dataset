module top_module(clk1, clk, clk22,clk24,clk26);input clk;
output clk1;
output clk22;
output clk24;
output clk26;

reg [26:0] num;
wire [26:0] next_num;

always @(posedge clk) begin
  num <= next_num;
end

assign next_num = num + 1'b1;
assign clk1 = num[1];
assign clk22 = num[21];
assign clk24 = num[23];
assign clk26 = num[27];
endmodule
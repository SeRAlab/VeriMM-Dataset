module top_module(
	clk,
	c0_in,
	c1_in,
	c2_in,
	c3_in,
	c0_up,
	c1_up,
	c2_up,
	c3_up,
	c0_down,
	c1_down,
	c2_down,
	c3_down
);input  clk;
input  [63:0] c0_in;
input  [63:0] c1_in;
input  [63:0] c2_in;
input  [63:0] c3_in;

output [63:0] c0_up;
output [63:0] c1_up;
output [63:0] c2_up;
output [63:0] c3_up;

output [63:0] c0_down;
output [63:0] c1_down;
output [63:0] c2_down;
output [63:0] c3_down;

reg [63:0] buffer0;
reg [63:0] buffer1;
reg [63:0] buffer2;
reg [63:0] buffer3;


always@(posedge clk) begin
  buffer0 <= c0_in;
  buffer1 <= c1_in;
  buffer2 <= c2_in;
  buffer3 <= c3_in; 
  end


assign c0_down = buffer0;
assign c1_down = buffer1;
assign c2_down = buffer2;
assign c3_down = buffer3;

assign c0_up = buffer1;
assign c1_up = buffer2;
assign c2_up = buffer3;
assign c3_up = c0_in;
  
endmodule
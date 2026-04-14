module top_module(clk,key_in,key);input clk;
input [3:0]key_in;

output [3:0]key;

reg [3:0]key1;
reg [3:0]key2;
reg [3:0]key3;

wire [3:0]key;

always@(posedge clk)
  begin
    key1<=key_in;
	 key2<=key1; 
	 key3<=key2; 
  end
assign key=(key1|key2|key3);

endmodule
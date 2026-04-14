module top_module( clk,ReadAddress, InsMemOut );input clk;
input [63:0] ReadAddress;
output reg[31:0] InsMemOut ;
reg [63:0]Memory[1023:0];


always@(posedge clk)
  begin
   InsMemOut = Memory[ReadAddress];
  end

endmodule
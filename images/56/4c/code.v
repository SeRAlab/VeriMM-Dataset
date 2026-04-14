module top_module(RD1,clk,A);input [31:0] RD1;
  input clk;
  output [31:0] A;
  
  reg [31:0] a;
  assign A=a;
  
  always @ (posedge clk)
  begin
    a<=RD1;
  end
  
endmodule
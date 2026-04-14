module top_module(DM,clk,R);input [31:0] DM;
  input clk;
  output [31:0] R;
  
  reg [31:0] r;
  assign R=r;
  
  always @ (posedge clk)
  begin
    r<=DM;
  end
  
endmodule
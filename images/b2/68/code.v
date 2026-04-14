module top_module(
  input [63 : 0] D,
  input clk,
  input reset,
  output reg [63 : 0] Q
  );always @(posedge clk)begin
    if (reset)
      Q <= {64{1'b0}};
    else
      Q <= D;   
    end 
    
endmodule
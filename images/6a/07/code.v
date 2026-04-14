module top_module(en, din, dout);input en; 
  input [2:0] din; 
  output reg [7:0] dout; 
  always @(*) begin 
  if (~en) begin 
  dout <= 8'b0; 
  end else begin 
  dout <= 8'b1 << din; 
  end 
  end 
 endmodule
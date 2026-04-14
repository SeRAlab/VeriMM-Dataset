module top_module(input [31:0] din,input signed [4:0] n,output reg [31:0] dout);always @(*) begin 
  dout = 0; 
  dout[n+1 +: 2] = din[n +: 2]; 
  end 
 endmodule
module top_module(input [31:0] Din,output [31:0] Dout,input CLK);reg [31:0]tmp_out [1:0]; 
 reg CE; 
 always @(posedge CLK) 
 begin 
  tmp_out[0] <= Din; 
  tmp_out[1] <= tmp_out[0]; 
 end 
 assign Dout = tmp_out[1]; 
 endmodule
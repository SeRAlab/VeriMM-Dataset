module top_module(input wire clk,input wire [10:0] addrwrite,input wire [10:0] addrread,input wire we,input wire [8:0] din,output reg [8:0] dout);reg [8:0] scan[0:2047]; 
  always @(posedge clk) begin 
  dout <= scan[addrread]; 
  if (we == 1'b1) 
  scan[addrwrite] <= din; 
  end 
 endmodule
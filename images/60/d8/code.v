module top_module(input clk, input [7:0] uaddr, input [7:0] udata_i,output [7:0] udata_o, input rw);reg [7:0] umemory[255:0]; 
  assign udata_o=rw?8'bZ:umemory[uaddr]; 
  always @(negedge clk) begin 
  if (rw==1) umemory[uaddr] <= udata_i; 
  end 
  initial 
  begin 
  umemory[0]<=8'h00; 
  umemory[1]<=8'h00; 
  umemory[2]<=8'h00; 
  umemory[255]<=8'hde; 
  end 
 endmodule
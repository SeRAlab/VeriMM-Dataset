module top_module(Rout, clr, clk, write_enable, write_value);input clr,clk, write_enable; 
  input [31:0] write_value; 
  output [8:0] Rout; 
  reg[31:0] value; 
  assign Rout = value[8:0]; 
  always @ (posedge clk)begin 
  if(clr) begin 
  value = 32'h00000000; 
  end 
  if(write_enable) begin 
  value = write_value; 
  end 
  end 
 endmodule
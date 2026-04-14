module top_module(linein,lineout,reset,clk);input linein; 
  output lineout; 
  reg linehold; 
  input reset; 
  input clk; 
  always @(posedge clk) begin 
  linehold <= linein; 
  end 
  assign lineout = ((linehold) && (!linein)); 
 endmodule
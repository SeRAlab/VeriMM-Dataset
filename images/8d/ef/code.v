module top_module(input in,input clk,output rising_edge,output falling_edge,output both_edges);reg [1:0] reg_i = 2'b0; 
  assign rising_edge = (~reg_i[1]) & reg_i[0]; 
  assign falling_edge = reg_i[1] &(~reg_i[0]); 
  assign both_edges = ((~reg_i[1]) & reg_i[0]) | (reg_i[1] & (~reg_i[0])); 
  always @(posedge clk) 
  begin 
  reg_i[0] <= in; 
  reg_i[1] <= reg_i[0]; 
  end 
 endmodule
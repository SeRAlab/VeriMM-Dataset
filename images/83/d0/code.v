module top_module(clock,reset,count);input clock; 
  input reset; 
  output [4:0] count; 
  reg [4:0] count_reg; 
  assign count = count_reg; 
  initial begin 
  count_reg = 0; 
  end 
  always @ (posedge reset or posedge clock) begin 
  if (reset) begin 
  count_reg <= 0; 
  end 
  else begin 
  count_reg <= count_reg + 5'd1; 
  end 
  end 
 endmodule
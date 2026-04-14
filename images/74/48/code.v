module top_module(
  output [2:0] cycle,
  input clk,
  input enn);reg [2:0] register = 3'b000;
  
  assign cycle = register;
  
  always @(posedge clk) begin
    if(!enn)
    	register <= register + 1;
    else
      register = 0;
  end
endmodule
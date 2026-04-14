module top_module(input wire button,input wire clk,input wire res,output wire clk_div);reg [3 : 0] ripple; 
  assign clk_div = &ripple; 
  always @(posedge clk) begin 
  if(res) 
  ripple <= 4'b0; 
  else begin 
  ripple[0] <= button; 
  ripple[1] <= ripple[0]; 
  ripple[2] <= ripple[1]; 
  ripple[3] <= ripple[2]; 
  end 
  end 
 endmodule
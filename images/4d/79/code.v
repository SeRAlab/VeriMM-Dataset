module top_module(error, noise,err_level);output [1:0] noise; 
  input [7:0] error; 
  input [7:0] err_level; 
  reg [1:0] noise; 
  always@(error) 
  begin 
  if (error < err_level) 
  noise = error[1:0]; 
  else 
  noise = 2'b00; 
  end 
 endmodule
module top_module(output [15 : 0] data_out_A,output [15 : 0] data_out_B,input write,input [3 : 0] address,input [7 : 0] output_AB,input [15 : 0] data_in);reg [15 : 0] register [15 : 0]; 
  initial 
  begin 
  register[0] <= 0; 
  end 
  assign data_out_A = register[output_AB[7 : 4]]; 
  assign data_out_B = register[output_AB[3 : 0]]; 
  always @(posedge write) 
  begin 
  if (address != 0) 
  begin 
  register[address] <= data_in; 
  end 
  end 
 endmodule
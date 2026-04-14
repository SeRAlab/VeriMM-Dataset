module top_module(clk,reset,random_bit);parameter SEED = 32'b10101011101010111010101110101011; 
  parameter TAPS = 31'b0000000000000000000000001100010; 
  input clk; 
  input reset; 
  output random_bit; 
  reg [31:0] shift_register; 
  initial shift_register = SEED; 
  always @(posedge clk) 
  begin 
  if(!reset) 
  begin 
  if(shift_register[31]) 
  shift_register[31:1] <= shift_register[30:0]^TAPS; 
  else 
  shift_register[31:1] <= shift_register[30:0]; 
  shift_register[0] <= shift_register[31]; 
  end 
  else 
  begin 
  shift_register <= SEED; 
  end 
  end 
  assign random_bit = shift_register[31]; 
 endmodule
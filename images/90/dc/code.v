module top_module(input clk,input [7:0] period,output pin);reg [7:0] counter; 
  reg pin_out; 
  assign pin = pin_out; 
  always @(posedge clk) begin 
  if (counter < period) 
  counter <= counter + 1; 
  else begin 
  counter <= 0; 
  case (pin) 
  1'b0: pin_out <= 1; 
  1'b1: pin_out <= 0; 
  default: pin_out <= 0; 
  endcase 
  end 
  end 
 endmodule
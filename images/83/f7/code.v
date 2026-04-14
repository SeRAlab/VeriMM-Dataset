module top_module(input [7:0] counter,input [2:0] value,output reg signal);reg [7:0] counter_value; 
  always @ (*) begin 
  case (value) 
  0: counter_value <= 0; 
  1: counter_value <= 15; 
  2: counter_value <= 35; 
  3: counter_value <= 63; 
  4: counter_value <= 99; 
  5: counter_value <= 143; 
  6: counter_value <= 195; 
  7: counter_value <= 255; 
  endcase 
  end 
  always @ (*) begin 
  signal <= (counter_value > counter); 
  end 
 endmodule
module top_module(ch0, ch1, ch2, ch3, channel, dataout);input [7:0] ch0; 
  input [7:0] ch1; 
  input [7:0] ch2; 
  input [7:0] ch3; 
  input [1:0] channel; 
  output reg [7:0] dataout; 
  always @(*) begin 
  case(channel) 
  0: 
  dataout <= ch0; 
  1: 
  dataout <= ch1; 
  2: 
  dataout <= ch2; 
  3: 
  dataout <= ch3; 
  default: 
  dataout <= 0; 
  endcase 
  end 
 endmodule
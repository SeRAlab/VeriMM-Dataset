module top_module(data0, data1, selectInput, out);output reg [15:0] out; 
  input [15:0] data0, data1; 
  input selectInput; 
  always@(data0 or data1 or selectInput) begin 
  case(selectInput) 
  0: out = data0; 
  1: out = data1; 
  endcase 
  end 
 endmodule
module top_module(input clk,input reset_n,input [3:0] units,input [3:0] tens,input [3:0] hundreds,input [3:0] thousands,output reg [2:0] digit_select,output reg [3:0] data,output reg decimal_point);reg [1:0] state; 
  reg [1:0] state_n; 
  parameter S0 = 2'b00; 
  parameter S1 = 2'b01; 
  parameter S2 = 2'b10; 
  parameter S3 = 2'b11; 
  always @ (posedge clk, negedge reset_n) 
  begin 
  if(!reset_n) 
  state <= S0; 
  else 
  state <= state_n; 
  end 
  always @ (*) 
  begin 
  case(state) 
  S0: state_n = S1; 
  S1: state_n = S2; 
  S2: state_n = S3; 
  S3: state_n = S0; 
  default: state_n = S0; 
  endcase 
  end 
  always @ (*) 
  begin 
  case(state) 
  S0: begin 
  decimal_point = 1; 
  digit_select = 3'b000; 
  data = units; 
  end 
  S1: begin 
  decimal_point = 1; 
  digit_select = 3'b001; 
  data = tens; 
  end 
  S2: begin 
  decimal_point = 1; 
  digit_select = 3'b011; 
  data = hundreds; 
  end 
  S3: begin 
  decimal_point = 0; 
  digit_select = 3'b100; 
  data = thousands; 
  end 
  endcase 
  end 
 endmodule
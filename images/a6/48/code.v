module top_module(input clk_i,input reset_n,output reg [2:0] sel,output reg digit);reg [1:0] state; 
  reg [1:0] state_next; 
  parameter S0 = 2'b00; 
  parameter S1 = 2'b01; 
  parameter S2 = 2'b10; 
  parameter S3 = 2'b11; 
  always @ (posedge clk_i, negedge reset_n) 
  begin 
  if(!reset_n) 
  state <= S0; 
  else 
  state <= state_next; 
  end 
  always @ (*) 
  begin 
  case(state) 
  S0: state_next = S1; 
  S1: state_next = S2; 
  S2: state_next = S3; 
  S3: state_next = S0; 
  default: state_next = S0; 
  endcase 
  end 
  always @ (*) 
  begin 
  case (state) 
  S0: 
  begin 
  sel = 3'b000; 
  digit = 1; 
  end 
  S1: 
  begin 
  sel = 3'b001; 
  digit = 1; 
  end 
  S2: 
  begin 
  sel = 3'b011; 
  digit = 0; 
  end 
  S3: 
  begin 
  sel = 3'b100; 
  digit = 1; 
  end 
  endcase 
  end 
 endmodule
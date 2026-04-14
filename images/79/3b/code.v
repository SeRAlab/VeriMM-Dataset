module top_module(input m,clk,output reg [3:0] Z);reg [1:0] state,nextstate; 
  parameter S0 = 2'b00,S1 = 2'b01,S2 = 2'b11,S3 = 2'b10; 
  initial 
  begin 
  state = S0; 
  end 
  always @(posedge clk) 
  begin 
  state = nextstate; 
  end 
  always @(state) 
  begin 
  case(state) 
  S0:if(m) Z = 4'b0001;else Z = 4'b0001; 
  S1:if(m) Z = 4'b0010;else Z = 4'b1000; 
  S2:if(m) Z = 4'b0100;else Z = 4'b0100; 
  S3:if(m) Z = 4'b1000;else Z = 4'b0010; 
  endcase 
  end 
  always @(state) 
  begin 
  case(state) 
  S0: nextstate = S1; 
  S1: nextstate = S2; 
  S2: nextstate = S3; 
  S3: nextstate = S0; 
  endcase 
  end 
 endmodule
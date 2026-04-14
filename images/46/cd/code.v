module top_module(input in, clk,rst,output detctd);localparam s0=5'b00001, 
  s1=5'b00010, 
  s2=5'b00100, 
  s3=5'b01000, 
  s4=5'b10000; 
 reg [4:0] stat_reg,next_reg; 
 always @(posedge clk,posedge rst) 
  if(rst) 
  stat_reg<=s0; 
 else 
  stat_reg<=next_reg; 
 always@(*) 
  case(stat_reg) 
  s0: if(in) next_reg=s1; 
  else next_reg=s0; 
  s1: if(in) next_reg=s1; 
  else next_reg=s2; 
  s2: if(in) next_reg=s3; 
  else next_reg=s1; 
  s3: if(in) next_reg=s4; 
  else next_reg=s0; 
  s4: if(in) next_reg=s1; 
  else next_reg=s0; 
  default: next_reg=s0; 
  endcase 
 assign detctd= in?(stat_reg==s4):1'b0; 
 endmodule
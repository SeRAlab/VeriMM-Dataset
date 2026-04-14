module top_module(input idle_NormaliseSum,input [31:0] sout_NormaliseSum,input [27:0] sum_NormaliseSum,input clock,output reg [31:0] sout_PackSum);parameter no_idle = 1'b0, 
  put_idle = 1'b1; 
 wire s_sign; 
 wire [7:0] s_exponent; 
 assign s_sign = sout_NormaliseSum[31]; 
 assign s_exponent = sout_NormaliseSum[30:23]; 
 always @ (posedge clock) 
 begin 
  if (idle_NormaliseSum != put_idle) begin 
  sout_PackSum[22:0] <= sum_NormaliseSum[25:3]; 
  sout_PackSum[30:23] <= s_exponent + 127; 
  sout_PackSum[31] <= s_sign; 
  if ($signed(s_exponent) == -126 && sum_NormaliseSum[22] == 0) begin 
  sout_PackSum[30 : 23] <= 0; 
  end 
  if ($signed(s_exponent) <= -126) begin 
  sout_PackSum[30 : 23] <= 0; 
  sout_PackSum[22:0] <= 0; 
  end 
  if ($signed(s_exponent) > 127) begin 
  sout_PackSum[22 : 0] <= 0; 
  sout_PackSum[30 : 23] <= 255; 
  sout_PackSum[31] <= s_sign; 
  end 
  end 
  else begin 
  sout_PackSum <= sout_NormaliseSum; 
  end 
 end 
 endmodule
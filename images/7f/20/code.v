module top_module(
  input [3:0] a,
  input [3:0] b,
  output [7:0] p,
  output sign
);wire [7:0] temp_p;
  wire a_sign, b_sign, p_sign;
  
  assign a_sign = a[3];
  assign b_sign = b[3];
  
  assign temp_p[0] = a[0] & b;
  assign temp_p[1] = a[1] & b;
  assign temp_p[2] = a[2] & b;
  assign temp_p[3] = a[3] & b;
  assign temp_p[4] = 4'b0;
  assign temp_p[5] = 4'b0;
  assign temp_p[6] = 4'b0;
  assign temp_p[7] = 4'b0;
  
  assign p_sign = a_sign ^ b_sign;
  
  assign sign = p_sign;
  
  assign p = (p_sign) ? (~temp_p + 1) : temp_p;
  
endmodule
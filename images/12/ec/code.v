module xor3(input wire a, input wire b, input wire c, output wire y);  
  wire ab_xor, ac_xor, bc_xor;  
  xor u1(ab_xor, a, b);  
  xor u2(ac_xor, a, c);  
  xor u3(bc_xor, b, c);  
  xor u4(y, ab_xor, c);  
endmodule
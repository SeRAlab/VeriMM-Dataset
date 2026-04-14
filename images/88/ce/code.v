module top_module(din_7_4_eq_0,din_7_6_eq_0,lead0_4b_0_hi,din_3_0_eq_0,din_3_2_eq_0,lead0_4b_0_lo,din_7_0_eq_0,lead0_8b_1,lead0_8b_0);input din_7_4_eq_0; 
 input din_7_6_eq_0; 
 input lead0_4b_0_hi; 
 input din_3_0_eq_0; 
 input din_3_2_eq_0; 
 input lead0_4b_0_lo; 
 output din_7_0_eq_0; 
 output lead0_8b_1; 
 output lead0_8b_0; 
 wire din_7_0_eq_0; 
 wire lead0_8b_1; 
 wire lead0_8b_0; 
 assign din_7_0_eq_0= din_3_0_eq_0 && din_7_4_eq_0; 
 assign lead0_8b_1= ((!din_7_4_eq_0) && din_7_6_eq_0) 
  || (din_7_4_eq_0 && din_3_2_eq_0); 
 assign lead0_8b_0= ((!din_7_4_eq_0) && lead0_4b_0_hi) 
  || (din_7_4_eq_0 && lead0_4b_0_lo); 
 endmodule
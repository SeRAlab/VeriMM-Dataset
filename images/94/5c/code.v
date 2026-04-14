module top_module(din_15_8_eq_0,din_15_12_eq_0,lead0_8b_1_hi,lead0_8b_0_hi,din_7_0_eq_0,din_7_4_eq_0,lead0_8b_1_lo,lead0_8b_0_lo,din_15_0_eq_0,lead0_16b_2,lead0_16b_1,lead0_16b_0);input din_15_8_eq_0; 
 input din_15_12_eq_0; 
 input lead0_8b_1_hi; 
 input lead0_8b_0_hi; 
 input din_7_0_eq_0; 
 input din_7_4_eq_0; 
 input lead0_8b_1_lo; 
 input lead0_8b_0_lo; 
 output din_15_0_eq_0; 
 output lead0_16b_2; 
 output lead0_16b_1; 
 output lead0_16b_0; 
 wire din_15_0_eq_0; 
 wire lead0_16b_2; 
 wire lead0_16b_1; 
 wire lead0_16b_0; 
 assign din_15_0_eq_0= din_7_0_eq_0 && din_15_8_eq_0; 
 assign lead0_16b_2= ((!din_15_8_eq_0) && din_15_12_eq_0) 
  || (din_15_8_eq_0 && din_7_4_eq_0); 
 assign lead0_16b_1= ((!din_15_8_eq_0) && lead0_8b_1_hi) 
  || (din_15_8_eq_0 && lead0_8b_1_lo); 
 assign lead0_16b_0= ((!din_15_8_eq_0) && lead0_8b_0_hi) 
  || (din_15_8_eq_0 && lead0_8b_0_lo); 
 endmodule
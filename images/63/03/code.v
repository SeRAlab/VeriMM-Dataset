module top_module(output [15 : 0] data_out,input [4 : 0] ctrl,input [15 : 0] data_in_A,input [15 : 0] data_in_B);wire [1 : 0] sign_union; 
  assign sign_union = {data_in_A[15], data_in_B[15]}; 
  assign data_out = 
  (ctrl == 0) ? data_in_A : 
  (ctrl == 1) ? data_in_B : 
  (ctrl == 2) ? (data_in_A+data_in_B) : 
  (ctrl == 3) ? (data_in_A-data_in_B) : 
  (ctrl == 4) ? (data_in_A&data_in_B) : 
  (ctrl == 5) ? (data_in_A|data_in_B) : 
  (ctrl == 6) ? (~data_in_A) : 
  (ctrl == 7) ? (data_in_A^data_in_B) : 
  (ctrl == 8) ? (data_in_A != data_in_B) : 
  (ctrl == 9) ? (data_in_B<<data_in_A) : 
  (ctrl == 10) ? (data_in_B>>data_in_A) : 
  (ctrl == 11) ? (data_in_A<<(data_in_B ? data_in_B : 8)) : 
  (ctrl == 12) ? (data_in_A < data_in_B) : 
  (ctrl == 13) ? ($signed(data_in_B)>>>data_in_A) : 
  (ctrl == 14) ? (data_in_A>>(data_in_B ? data_in_B : 8)) : 
  (ctrl == 15) ? ($signed(data_in_A)>>>(data_in_B ? data_in_B : 8)) : 
  (sign_union == 2'b01 ? 0 : (sign_union == 2'b10 ? 1 : ((data_in_A < data_in_B)^sign_union[1]))); 
 endmodule
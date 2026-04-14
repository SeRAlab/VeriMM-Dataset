module top_module(
   
   retdp_data_c7, retdp_ecc_c7, 
   
   retdp_data_c7_buf, retdp_ecc_c7_buf
   );output  [127:0]  retdp_data_c7;
output  [ 27:0]  retdp_ecc_c7;

input  [127:0]  retdp_data_c7_buf;
input  [ 27:0]  retdp_ecc_c7_buf;











assign\tretdp_data_c7 = retdp_data_c7_buf ;
assign\tretdp_ecc_c7 = retdp_ecc_c7_buf ;


endmodule
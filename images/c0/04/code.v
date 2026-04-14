module zzecc_sctag_30b_cor ( din, parity, dout, corrected_bit ) ;
input  [23:0] din ;
input  [4:0]  parity ;
output [23:0] dout ;
output [4:0]  corrected_bit ;
wire   [23:0] dout ;
wire   [4:0]  corrected_bit ;
wire          p1 ;
wire          p2 ;
wire          p4 ;
wire          p8 ;
wire          p16 ;
wire [23:0]   error_bit ;
assign p1  = parity[0] ^
             din[0]  ^ din[1]  ^ din[3]  ^ din[4]  ^ din[6]  ^ din[8]  ^
             din[10] ^ din[11] ^ din[13] ^ din[15] ^ din[17] ^ din[19] ^
             din[21] ^ din[23] ;
assign p2  = parity[1] ^
             din[0]  ^ din[2]  ^ din[3]  ^ din[5]  ^ din[6]  ^ din[9]  ^
             din[10] ^ din[12] ^ din[13] ^ din[16] ^ din[17] ^ din[20] ^
             din[21] ;
assign p4  = parity[2] ^
             din[1]  ^ din[2]  ^ din[3]  ^ din[7]  ^ din[8]  ^ din[9]  ^
             din[10] ^ din[14] ^ din[15] ^ din[16] ^ din[17] ^ din[22] ^
             din[23] ;
assign p8  = parity[3] ^
             din[4]  ^ din[5]  ^ din[6]  ^ din[7]  ^ din[8]  ^ din[9]  ^
             din[10] ^ din[18] ^ din[19] ^ din[20] ^ din[21] ^ din[22] ^
             din[23] ;
assign p16 = parity[4] ^
             din[11] ^ din[12] ^ din[13] ^ din[14] ^ din[15] ^ din[16] ^
             din[17] ^ din[18] ^ din[19] ^ din[20] ^ din[21] ^ din[22] ^
             din[23] ;
assign  error_bit[0]  = !p16 & !p8 & !p4 &  p2 &  p1 ; 
assign  error_bit[1]  = !p16 & !p8 &  p4 & !p2 &  p1 ; 
assign  error_bit[2]  = !p16 & !p8 &  p4 &  p2 & !p1 ; 
assign  error_bit[3]  = !p16 & !p8 &  p4 &  p2 &  p1 ; 
assign  error_bit[4]  = !p16 &  p8 & !p4 & !p2 &  p1 ; 
assign  error_bit[5]  = !p16 &  p8 & !p4 &  p2 & !p1 ; 
assign  error_bit[6]  = !p16 &  p8 & !p4 &  p2 &  p1 ; 
assign  error_bit[7]  = !p16 &  p8 &  p4 & !p2 & !p1 ; 
assign  error_bit[8]  = !p16 &  p8 &  p4 & !p2 &  p1 ; 
assign  error_bit[9]  = !p16 &  p8 &  p4 &  p2 & !p1 ; 
assign  error_bit[10] = !p16 &  p8 &  p4 &  p2 &  p1 ; 
assign  error_bit[11] =  p16 & !p8 & !p4 & !p2 &  p1 ; 
assign  error_bit[12] =  p16 & !p8 & !p4 &  p2 & !p1 ; 
assign  error_bit[13] =  p16 & !p8 & !p4 &  p2 &  p1 ; 
assign  error_bit[14] =  p16 & !p8 &  p4 & !p2 & !p1 ; 
assign  error_bit[15] =  p16 & !p8 &  p4 & !p2 &  p1 ; 
assign  error_bit[16] =  p16 & !p8 &  p4 &  p2 & !p1 ; 
assign  error_bit[17] =  p16 & !p8 &  p4 &  p2 &  p1 ; 
assign  error_bit[18] =  p16 &  p8 & !p4 & !p2 & !p1 ; 
assign  error_bit[19] =  p16 &  p8 & !p4 & !p2 &  p1 ; 
assign  error_bit[20] =  p16 &  p8 & !p4 &  p2 & !p1 ; 
assign  error_bit[21] =  p16 &  p8 & !p4 &  p2 &  p1 ; 
assign  error_bit[22] =  p16 &  p8 &  p4 & !p2 & !p1 ; 
assign  error_bit[23] =  p16 &  p8 &  p4 & !p2 &  p1 ; 
assign  dout          = din ^ error_bit ;
assign  corrected_bit = {p16, p8, p4, p2, p1} ;
endmodule
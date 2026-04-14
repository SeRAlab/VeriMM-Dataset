module top_module(
   input [23:0] d_i,
   output [7:0] p_o
   );assign p_o[0]=^{d_i[2:0], d_i[5:4], d_i[7], d_i[11:10], d_i[13], d_i[16], d_i[23:20]};
   assign p_o[1]=^{d_i[1:0], d_i[4:3], d_i[6], d_i[8], d_i[10], d_i[12], d_i[14], d_i[17], d_i[23:20]}; 
   assign p_o[2]=^{d_i[0], d_i[3:2], d_i[6:5], d_i[9], d_i[12:11], d_i[15], d_i[18], d_i[22:20] };
   assign p_o[3]=^{d_i[3:1], d_i[9:7], d_i[15:13], d_i[21:19], d_i[23]};
   assign p_o[4]=^{d_i[9:4], d_i[20:16], d_i[23:22]}; 
   assign p_o[5]=^{d_i[19:10], d_i[23:21]};
   assign p_o[7:6]=2'b0;
   
endmodule
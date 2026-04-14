module top_module(
	i_op          , 

	i_wf_post_pre ,
	
	i_mk3to0      ,
	i_mk15to12    , 

	o_wk3_7       ,  
	o_wk2_6       ,   
	o_wk1_5       ,  
	o_wk0_4         
);input       i_op          ; 

input       i_wf_post_pre ;

input[31:0] i_mk3to0      ;
input[31:0] i_mk15to12    ; 

output[7:0] o_wk3_7       ;  
output[7:0] o_wk2_6       ;   
output[7:0] o_wk1_5       ;  
output[7:0] o_wk0_4       ; 














wire        w_out_sel;








assign      w_out_sel = i_op ^ i_wf_post_pre; 
                                              


assign      o_wk3_7 = (~w_out_sel) ? i_mk15to12[31:24] : 
                                     i_mk3to0[31:24]   ; 

assign      o_wk2_6 = (~w_out_sel) ? i_mk15to12[23:16] : 
                                     i_mk3to0[23:16]   ; 

assign      o_wk1_5 = (~w_out_sel) ? i_mk15to12[15:8]  : 
                                     i_mk3to0[15:8]    ; 

assign      o_wk0_4 = (~w_out_sel) ? i_mk15to12[7:0]   : 
                                     i_mk3to0[7:0]     ; 

endmodule
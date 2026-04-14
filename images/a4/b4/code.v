module top_module(
	
	i_op        ,  

	i_wf_in     ,  
	
	i_wk        ,   
	
	o_wf_out          
);input        i_op           ;  

input[63:0]  i_wf_in        ;  
	
input[31:0]  i_wk           ;   

output[63:0] o_wf_out       ;  















wire[63:0]  w_wf_out     ;

wire[7:0]  w_wf_out7     ;  
wire[7:0]  w_wf_out6     ;  
wire[7:0]  w_wf_out5     ;  
wire[7:0]  w_wf_out4     ;  
wire[7:0]  w_wf_out3     ;  
wire[7:0]  w_wf_out2     ;  
wire[7:0]  w_wf_out1     ;  
wire[7:0]  w_wf_out0     ;  







assign w_wf_out7 = i_wf_in[63:56];
assign w_wf_out6 = i_wf_in[55:48] ^ i_wk[31:24];
assign w_wf_out5 = i_wf_in[47:40];
assign w_wf_out4 = (i_op == 0) ? (i_wf_in[39:32] + i_wk[23:16]) : 
                                 (i_wf_in[39:32] - i_wk[23:16]) ;
assign w_wf_out3 = i_wf_in[31:24];
assign w_wf_out2 = i_wf_in[23:16] ^ i_wk[15:8];
assign w_wf_out1 = i_wf_in[15:8];
assign w_wf_out0 = (i_op == 0) ? (i_wf_in[7:0] + i_wk[7:0]) : 
                                 (i_wf_in[7:0] - i_wk[7:0]) ; 

assign w_wf_out = {w_wf_out7, w_wf_out6, w_wf_out5, w_wf_out4, w_wf_out3, w_wf_out2, w_wf_out1, w_wf_out0}; 
assign o_wf_out = w_wf_out;

endmodule
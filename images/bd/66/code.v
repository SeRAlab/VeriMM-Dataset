module top_module(ph_seg_p_2_1_1_V_read,th_seg_p_2_1_0_V_read,th_seg_p_2_1_1_V_read,cpat_seg_p_2_1_1_V_read,ap_return_0,ap_return_1,ap_return_2,ap_return_3);input [11:0] ph_seg_p_2_1_1_V_read; 
 input [6:0] th_seg_p_2_1_0_V_read; 
 input [6:0] th_seg_p_2_1_1_V_read; 
 input [3:0] cpat_seg_p_2_1_1_V_read; 
 output [11:0] ap_return_0; 
 output [3:0] ap_return_1; 
 output [6:0] ap_return_2; 
 output [6:0] ap_return_3; 
 assign ap_return_0 = ph_seg_p_2_1_1_V_read; 
 assign ap_return_1 = cpat_seg_p_2_1_1_V_read; 
 assign ap_return_2 = th_seg_p_2_1_0_V_read; 
 assign ap_return_3 = th_seg_p_2_1_1_V_read; 
 endmodule
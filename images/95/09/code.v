module top_module(cc_in1, cc_in2, cc_in3, cc_in4, cc_out1, cc_out2, cc_out3);input cc_in1;          
	input cc_in2;          
	input cc_in3;          
	input cc_in4;          

	output cc_out1;        
	output cc_out2;        
	output cc_out3;        

	assign cc_out1 = cc_in1 & cc_in2;
	assign cc_out3 = cc_in3 & cc_in4;
	assign cc_out2 = cc_out1 | cc_out3;endmodule
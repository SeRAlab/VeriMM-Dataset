module mux4to1 (
	input d0,
	input d1,
	input d2,
	input d3,
	input s0,
	input s1,
	output y);assign y = (s0 == 0 && s1 == 0) ? d0 :
           (s0 == 0 && s1 == 1) ? d1 :
           (s0 == 1 && s1 == 0) ? d2 :
                                 d3;
endmodule
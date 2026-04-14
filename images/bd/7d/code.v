module top_module(output CO, input I0, I1, CI);assign CO = (I0 && I1) || ((I0 || I1) && CI);
`ifdef ICE40_HX
	specify
		
		(CI => CO) = (126, 105);
		
		(I0 => CO) = (259, 245);
		
		(I1 => CO) = (231, 133);
	endspecify
`endif
`ifdef ICE40_LP
	specify
		
		(CI => CO) = (186, 155);
		
		(I0 => CO) = (382, 362);
		
		(I0 => CO) = (341, 196);
	endspecify
`endif
`ifdef ICE40_U
	specify
		
		(CI => CO) = (278, 278);
		
		(I0 => CO) = (675, 662);
		
		(I0 => CO) = (609, 358);
	endspecify
`endif
endmodule
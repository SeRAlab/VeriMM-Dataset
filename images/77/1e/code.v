module top_module(output O, input I0, I1, I2, I3);parameter [15:0] LUT_INIT = 0;
	wire [7:0] s3 = I3 ? LUT_INIT[15:8] : LUT_INIT[7:0];
	wire [3:0] s2 = I2 ?       s3[ 7:4] :       s3[3:0];
	wire [1:0] s1 = I1 ?       s2[ 3:2] :       s2[1:0];
	assign O = I0 ? s1[1] : s1[0];
`ifdef ICE40_HX
	specify
		
		(I0 => O) = (449, 386);
		
		(I1 => O) = (400, 379);
		
		(I2 => O) = (379, 351);
		
		(I3 => O) = (316, 288);
	endspecify
`endif
`ifdef ICE40_LP
	specify
		
		(I0 => O) = (662, 569);
		
		(I1 => O) = (589, 558);
		
		(I2 => O) = (558, 517);
		
		(I3 => O) = (465, 423);
	endspecify
`endif
`ifdef ICE40_U
	specify
		
		(I0 => O) = (1245, 1285);
		
		(I1 => O) = (1179, 1232);
		
		(I2 => O) = (1179, 1205);
		
		(I3 => O) = (861, 874);
	endspecify
`endif
endmodule
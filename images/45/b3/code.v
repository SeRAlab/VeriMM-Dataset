module top_module(
	 input	A0,
	 input	A1,
	 input	A2,
	 input	A3,
	 input	B0,
	 input	B1,
	 input	B2,
	 input	B3,
	 output	GT,
	 output	LT
    );assign GT = {A3,A2,A1,A0} > {B3,B2,B1,B0};
	 assign LT = {A3,A2,A1,A0} < {B3,B2,B1,B0};
	 
	 

endmodule
module top_module(
	din,

	din_3_0_eq_0,
	din_3_2_eq_0,
	lead0_4b_0
);input [3:0]	din;			

output		din_3_0_eq_0;		
output		din_3_2_eq_0;		
output		lead0_4b_0;		


wire		din_3_0_eq_0;
wire		din_3_2_eq_0;
wire		lead0_4b_0;


assign din_3_0_eq_0= (!(|din[3:0]));

assign din_3_2_eq_0= (!(|din[3:2]));

assign lead0_4b_0= ((!din_3_2_eq_0) && (!din[3]))
		|| (din_3_2_eq_0 && (!din[1]));

endmodule
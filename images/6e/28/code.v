module top_module(
	din1,
	din2,

	din2_din1_nz,
	din2_din1_denorm
);input [2:0]     din1;                   
input [2:0]     din2;                   

output		din2_din1_nz;		
output		din2_din1_denorm;	


wire [2:0]	din2_din1_zero;
wire		din2_din1_nz;
wire		din2_din1_denorm;


assign din2_din1_zero[2:0]= (~(din1 | din2));

assign din2_din1_nz= (!(&din2_din1_zero[2:0]));

assign din2_din1_denorm= din2[2]
		|| (din2_din1_zero[2] && din2[1])
		|| ((&din2_din1_zero[2:1]) && din2[0]);


endmodule
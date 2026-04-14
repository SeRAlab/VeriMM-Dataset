module top_module(Zin, Vin, Nin, rst, clk, Zout, Vout, Nout);input Zin, Vin, Nin;
input rst, clk;

output Zout, Vout, Nout;

reg [2:0]IM_ID;

always @(posedge clk or negedge rst)
	if (!rst)
		IM_ID <= 3'b000;
	else  
		IM_ID <= {Nin, Vin, Zin};
		
		

assign Zout = IM_ID[0];
assign Vout = IM_ID[1];
assign Nout = IM_ID[2];

endmodule
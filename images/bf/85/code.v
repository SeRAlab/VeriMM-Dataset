module top_module(
	input		iCLK,
	input		iReset_n,
	output		oCLOCK_b,
	output		oCLOCK_wd,
	output		oCLOCK_30
	);reg [24:0] count;
	always@ (posedge iCLK)
	begin
		if (!iReset_n)
			count <= 25'b0;
		else	
			count <=	count + 1'b1;
	end
	assign oCLOCK_b  = count[14];
	assign oCLOCK_wd = count[10];
	assign oCLOCK_30 = count[0];
	
endmodule
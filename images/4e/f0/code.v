module top_module(clk , reset , in , ped, p1) ;input  clk , reset ;
	input  in  ;
    input p1;
    
	output wire ped ;
	
	reg Q1, Q2;

	always @ (posedge clk, posedge reset)
		if(reset)
			{Q1, Q2} <= 2'b0;
		else
			{Q1, Q2} <= {in, Q1};
	
	
	assign ped = Q1 & ~Q2;
	
endmodule
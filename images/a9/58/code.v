module top_module(clk, reset, D, D_Addr, S_Addr, T_Addr, D_En, S, T);input			clk, reset, D_En;
	input	 [4:0]  D_Addr, S_Addr, T_Addr;
	input  [31:0]   D;
	output [31:0]	S, T;
	
	reg [31:0] 		data [31:0];
	
	
	assign S = data[S_Addr];
	assign T = data[T_Addr];
	
	
	always@ (posedge clk, posedge reset) begin
		
		if (reset) 	
			data[0] 	 <= 32'h0;
		
		else if ( D_En  && D_Addr != 5'b0)
			data[D_Addr] <= D;
		
		else 
			data[D_Addr] <= data[D_Addr];
	end 
	
endmodule
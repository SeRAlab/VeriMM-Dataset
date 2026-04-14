module top_module(CLK,RESET,X,Y);input CLK, RESET,X;
	output Y;
	reg Y;
	reg [1:0] ST_C, ST_N;
	parameter S0=0, S1=1, S2=2;

	always @(negedge CLK or negedge RESET)
		begin
			if(!RESET) ST_C<=S0;
			else ST_C <= ST_N;
		end

always @(ST_C or X)
	case (ST_C)
		S0 : if(!X) begin ST_N<=S0; Y<=0; end else begin ST_N<=S1; Y<=0; end
		S1 : if(!X) begin ST_N<=S0; Y<=0; end else begin ST_N<=S2; Y<=1; end
		S2 : if(!X) begin ST_N<=S0; Y<=0; end else begin ST_N<=S1; Y<=1; end
	endcase

endmodule
module top_module(clk, j, k, q, qn);input clk, j, k;
	output q, qn;
	wire clk, j, k;
	reg q, qn;
	always @ (posedge clk) 
	begin
		case({j,k})
			2'b00: {q, qn} <= {q, qn}; 
			2'b01: {q, qn} <= 2'b01; 
			2'b10: {q, qn} <= 2'b10; 
			2'b11: {q, qn} <= {~q, ~qn}; 
			default: q <= q;
		endcase
	end
endmodule
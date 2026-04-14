module top_module(
	input branch_d,
	input [3:0] branch_condition_d,
	
	input Z,
	input N,
	input V,
	input C,
	
	output reg PC_source
	);reg branch_taken;

	always @(*) begin
		case (branch_condition_d)
			4'h0: branch_taken <= Z;
			4'h1: branch_taken <= ~Z;
			4'h2: branch_taken <= C;
			4'h3: branch_taken <= ~C;
			4'h4: branch_taken <= N;
			4'h5: branch_taken <= ~N;
			4'h6: branch_taken <= V;
			4'h7: branch_taken <= ~V;
			4'h8: branch_taken <= C & ~Z;
			4'h9: branch_taken <= Z | ~C;
			4'ha: branch_taken <= ~(N ^ V);
			4'hb: branch_taken <= N ^ V;
			4'hc: branch_taken <= (N & ~Z & V ) | (~N & ~Z & ~V);
			4'hd: branch_taken <= (N ^ V) & Z;
			
			4'hf: branch_taken <= 1;
		endcase
		PC_source <= branch_taken & branch_d;
	end
	
	
endmodule
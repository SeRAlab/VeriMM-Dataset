module top_module(
	input wire [4:0]  v0, v1, v2, v3,
	input wire en,
	output wire [20:0] chi_sqr
	);(* KEEP = "TRUE" *) (* S = "TRUE" *)
reg [9:0] v0_sqr, v1_sqr, v2_sqr, v3_sqr;

assign chi_sqr =	  (v0_sqr<<0) + (v0_sqr<<1) + (v0_sqr<<2) + (v0_sqr<<3) + (v0_sqr<<4) + (v0_sqr<<7) + (v0_sqr<<9) + (v0_sqr<<12) 
						+ (v1_sqr<<2) + (v1_sqr<<5) + (v1_sqr<<6) + (v1_sqr<<7) + (v1_sqr<<9) + (v1_sqr<<11)
						+ (v2_sqr<<1) + (v2_sqr<<3) + (v2_sqr<<4) + (v2_sqr<<6) + (v2_sqr<<8) + (v2_sqr<<12) 
						+ (v3_sqr<<0) + (v3_sqr<<2) + (v3_sqr<<4) + (v3_sqr<<6) + (v3_sqr<<8) + (v3_sqr<<10) + (v3_sqr<<12);
always @(*)
	if (en) begin
		v0_sqr <= v0 * v0;
		v1_sqr <= v1 * v1;
		v2_sqr <= v2 * v2;
		v3_sqr <= v3 * v3;
	end		
		
endmodule
module top_module(
	input		mclock,		
	input		rstn,
	input		tex_push_en,	
	input		ram_sel,	

	output reg	ram_wen_lo,	
	output reg	ram_wen_hi	
	);reg 	cs;

always @(posedge mclock, negedge rstn) begin
	if(!rstn) cs <= 1'b0;
	else begin
	case(cs)
		1'b0: 	if(tex_push_en) cs <= 1'b1;
		 	else cs = 1'b0;

		1'b1: 	if(tex_push_en) cs <= 1'b0;
		 	else cs = 1'b1;

	endcase
	end
end

always @* ram_wen_lo = tex_push_en & ((~cs & ~ram_sel) | ( cs & ram_sel));
always @* ram_wen_hi = tex_push_en & (( cs & ~ram_sel) | (~cs & ram_sel));

endmodule
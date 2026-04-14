module top_module(
			input clk,
			output reg upr_mod,
			output reg upr_gen,
			output reg sinhr
			);reg [14:0]timer;
integer const1 = 50;		


always @(posedge clk) begin    
	timer <= timer + 1'd1;
	if (timer >= 0) begin
		upr_mod <= 1;
		sinhr <= 1;
		end
	if (timer >= 13) begin
		upr_mod <= 0;
		end
	if (timer >= 21) begin
		upr_gen <= 1;
		end
	if (timer >= 34) begin
		upr_gen <= 0;
		end
		
	if (timer >= 50) begin
		sinhr <= 0;
		end
		
	if (timer >= const1 + 356) begin
		upr_mod <= 1;
		end
	if (timer >= 374 + const1) begin
		upr_gen <= 1;
		end
	if (timer >= 456 + const1) begin
		upr_mod <= 0;
		end
	if (timer >= 478 + const1) begin
		upr_gen <= 0;
		end
		
	if (timer >= 1806 + const1) begin
		upr_mod <= 1;
		end
	if (timer >= 1826 + const1) begin
		upr_gen <= 1;
		end
	if (timer >= 3006 + const1) begin
		upr_mod <= 0;
		end
	if (timer >= const1 + 3038) begin
		upr_gen <= 0;
		end
	
	if (timer >= 15000) begin
		timer <= 0;
		end
end
endmodule
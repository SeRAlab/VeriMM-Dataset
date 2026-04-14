module top_module(
	input wire pin_reg,
	input wire latch_in,
	input wire clk_en,
	input wire clk_in,
	input wire clk_out,
	input wire oen,
	input wire gold_din_0,
	input wire gold_din_1,
	input wire gate_din_0,
	input wire gate_din_1,
	output reg gold_pin,
	output reg gold_global,
	output reg gate_pin,
	output reg gate_global,
	output reg dout_0,
	output reg dout_1
);always @(*) begin
		gold_pin = pin_reg;
		gold_global = 0;		
		gate_pin = pin_reg;
		gate_global = 0;	
		
		if (clk_en) begin
			dout_0 = latch_in;          // Use blocking assignment for combinatorial logic
			dout_1 = latch_in;          // Use blocking assignment for combinatorial logic
			
			if (clk_in) begin
				gold_global = 1;
				gate_global = 1;
				
				if (oen) begin
					dout_0 = 0;
					dout_1 = 0;
				end else begin
					if (gold_din_0) begin
						dout_0 = 1;
					end
					
					if (gold_din_1) begin
						dout_1 = 1;
					end
					
					if (gate_din_0) begin
						dout_0 = 1;
					end
					
					if (gate_din_1) begin
						dout_1 = 1;
					end
				end
			end
		end
		
	end

endmodule
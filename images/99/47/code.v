module top_module(
	input clk,
	input reset,
	input flush,

	input vm_enable,
	input enable,
	input [31:0] virtual_address,
	output reg [31:0] physical_address,

	output reg tlb_hit,
	output reg translation_required,
	input [31:0] translated_address,
	input translation_complete
);localparam TLB_ENTRIES = 4;

	reg [1:0] entry; 
	reg [40:0] tlb [TLB_ENTRIES-1:0];

	integer i, j;

	always @ (posedge clk) begin
		if (reset || flush) begin
			for (j = 0; j < TLB_ENTRIES; j = j + 1) begin
				tlb[j] = 41'b0;
			end
			entry = 0;
		end
	end

	localparam S_CHECK = 0;
	localparam S_WAIT  = 1;

	reg state;
	reg next_state;

	always @ (posedge clk) begin
		if (reset)
			state <= S_CHECK;
		else
			state <= next_state;
	end

	always @ (*) begin
		case (state)
			S_CHECK: begin
				tlb_hit = 0;
				
				for (i = 0; i < TLB_ENTRIES; i = i + 1) begin
					if (virtual_address[31:12] == tlb[i][39:20] && tlb[i][40]) begin
						physical_address = {tlb[i][19:0], virtual_address[11:0]};
						tlb_hit = 1;
					end
				end

				translation_required = !tlb_hit && enable && vm_enable;
				next_state = !translation_required ? S_CHECK : S_WAIT;
			end

			S_WAIT:
				next_state = translation_complete ? S_CHECK : S_WAIT;

			default:
				next_state = S_CHECK;
		endcase
	end

	always @ (*) begin
		if (state == S_WAIT && translation_complete) begin
			tlb[entry] = {1'b1, virtual_address[31:12], translated_address[31:12]};
			entry = entry + 1;
		end
	end

endmodule
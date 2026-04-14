module top_module(
	reset_n,
	clk,
	reset_n_sync
);parameter RESET_SYNC_STAGES = 4;
parameter NUM_RESET_OUTPUT = 1;

input	reset_n;
input	clk;
output	[NUM_RESET_OUTPUT-1:0] reset_n_sync;







(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; -name GLOBAL_SIGNAL OFF"}*) reg	[RESET_SYNC_STAGES+NUM_RESET_OUTPUT-2:0] reset_reg ;

generate
genvar i;
	for (i=0; i<RESET_SYNC_STAGES+NUM_RESET_OUTPUT-1; i=i+1)
	begin: reset_stage
		always @(posedge clk or negedge reset_n)
		begin
			if (~reset_n)
				reset_reg[i] <= 1'b0;
			else
			begin
				if (i==0)
					reset_reg[i] <= 1'b1;
				else if (i < RESET_SYNC_STAGES)
					reset_reg[i] <= reset_reg[i-1];
				else
					reset_reg[i] <= reset_reg[RESET_SYNC_STAGES-2];
				
			end
		end
	end
endgenerate

	assign reset_n_sync = reset_reg[RESET_SYNC_STAGES+NUM_RESET_OUTPUT-2:RESET_SYNC_STAGES-1];

endmodule
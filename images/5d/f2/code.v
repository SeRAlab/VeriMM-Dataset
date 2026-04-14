module top_module(
	input clk_sys,
	input start,
	input di,
	input dp8, dp2, dp6, dp5,
	input mode,
	input step,
	input oken,
	input f1,
	input zw,
	output ldstate,
	output strob1,
	output strob1b,
	output strob2,
	output strob2b,
	output sr_fp
);localparam S_GOT	= 3'd0;
	localparam S_GOTW	= 3'd1;
	localparam S_ST1	= 3'd2;
	localparam S_ST1W = 3'd3;
	localparam S_ST1B	= 3'd4;
	localparam S_PGOT = 3'd5;
	localparam S_ST2	= 3'd6;
	localparam S_ST2B	= 3'd7;

	wire if_busy = oken & f1 & zw;
	wire es1 = dp8 | dp2 | dp6 | dp5;
	wire has_strob2 = dp8 | dp2;
	wire no_strob2 = dp6 | dp5;

	wire __got = state == S_GOT;
	assign strob1 = state == S_ST1;
	assign strob1b = state == S_ST1B;
	assign strob2 = state == S_ST2;
	assign strob2b = state == S_ST2B;
	assign ldstate = ~if_busy & ((state == S_PGOT) | ((state == S_ST1B) & no_strob2) | (state == S_ST2B));

	reg [0:2] state;

	

	always @ (posedge clk_sys) begin
		case (state)
			S_GOT:
				if (es1) state <= S_ST1;
				else state <= S_GOTW;
			S_GOTW:
				if (es1) state <= S_ST1;
			S_ST1:
				state <= S_ST1B;
			S_ST1B:
				if (has_strob2) state <= S_ST2;
				else if (no_strob2 & !if_busy) state <= S_GOT;
				else state <= S_PGOT;
			S_ST2:
				state <= S_ST2B;
			S_ST2B:
				if (!if_busy) state <= S_GOT;
				else state <= S_PGOT;
			S_PGOT:
				if (!if_busy) state <= S_GOT;
		endcase
	end



	wire got_fp = ~di & __got;
	wire sr = start | got_fp;
	assign sr_fp = sr & f1;

endmodule
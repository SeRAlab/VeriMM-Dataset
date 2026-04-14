module top_module (
	input clk,
	input sreset,
	input s,
	output det);parameter IDLE=0, ONE=1, ONE_ZERO=2;
	reg [1:0] state;
	always @(posedge clk) begin
		if (sreset)
			state <= IDLE;
		else begin
			case (state)
				IDLE: state <= (s == 1) ? ONE : IDLE;
				ONE: state <= (s == 0) ? ONE_ZERO : ONE;
				ONE_ZERO: state <= (s == 1) ? IDLE : ONE;
			endcase
		end
	end
	
	assign det = (state == ONE_ZERO && s == 1);
	
endmodule
module top_module (
        input clk,
        input areset,
        input start,
        input done_wash,
        input done_rinse,
        input done_spin,
        output reg running);parameter Idle=2'b00, Wash=2'b01, Rinse=2'b10, Spin=2'b11;
	reg [1:0] state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Idle;
		else begin
			case (state)
				Idle: state <= start ? Wash : Idle;
				Wash: state <= done_wash ? Rinse : Wash;
				Rinse: state <= done_rinse ? Spin : Rinse;
				Spin: state <= done_spin ? Idle : Spin;
			endcase
		end
	end
	
	assign running = (state == Wash) || (state == Rinse) || (state == Spin);
	
endmodule
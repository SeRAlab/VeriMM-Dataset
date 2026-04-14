module top_module (
        input clk,
        input areset,
        input sensor,
        input fully_open,
        input fully_closed,
        output reg gate);parameter Closed=2'b00, Opening=2'b01, Opened=2'b10, Closing=2'b11;
	reg [1:0] state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Closed;
		else begin
			case (state)
				Closed: state <= sensor ? Opening : Closed;
				Opening: state <= fully_open ? Opened : Opening;
				Opened: state <= sensor ? Opened : Closing;
				Closing: state <= fully_closed ? Closed : Closing;
			endcase
		end
	end
	
	assign gate = (state == Opened);
	
endmodule
module top_module(
		input [15:0] sqX,
		input clk,			output imp,
		input ce1us
    );reg [15:0] cb_ce1us = 0;
wire TC = (cb_ce1us == (sqX - 1));
assign imp = TC;

always @ (posedge clk) if (ce1us) begin
	cb_ce1us <= (TC) ? 0 : cb_ce1us + 1;

end

endmodule
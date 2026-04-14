module top_module (
        input [2:0] w,
        input e,
        output reg W0,
        output reg W1);assign W0 = (w[1] & ~e) | (w[2] & e);
	assign W1 = (w[0] & e) | (w[2] & ~e);

endmodule
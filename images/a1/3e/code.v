module top_module (
        input [3:0] w,
        input e,
        output reg W1,
        output reg W2);assign W1 = (w[0] & e) | (w[3] & e);
	assign W2 = (w[1] & e);

endmodule
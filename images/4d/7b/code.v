module top_module (
        input [2:0] a,
        input i,
        output reg A0,
        output reg A1);assign A0 = (a[1] & i) | (a[2] & ~i);
	assign A1 = (a[0] & i) | (a[2] & i);

endmodule
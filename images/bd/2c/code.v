module top_module (
        input [2:0] z,
        input h,
        output reg Z0,
        output reg Z1);assign Z0 = (z[1] & ~h) | (z[2] & h);
	assign Z1 = (z[0] & h) | (z[2] & ~h);

endmodule
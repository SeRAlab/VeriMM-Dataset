module top_module (
        input [3:0] z,
        input h,
        output reg Z1,
        output reg Z3);assign Z1 = (z[0] & h) | (z[3] & h);
	assign Z3 = (z[1] & h) | (z[2] & h);

endmodule
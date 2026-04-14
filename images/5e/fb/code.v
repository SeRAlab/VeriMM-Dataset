module top_module (
        input [3:0] y,
        input g,
        output reg Y0,
        output reg Y1);assign Y0 = (y[2] & ~g) | (y[3] & ~g);
	assign Y1 = (y[0] & g) | (y[3] & g);

endmodule
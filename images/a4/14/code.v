module top_module (
        input [3:1] g,
        input z,
        output reg G2,
        output reg G3);

	assign G2 = g[1]&~z | g[3]&z;
	assign G3 = g[1]&z | g[2]&~z;

endmodule
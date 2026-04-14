module top_module (
        input [3:1] e,
        input x,
        output reg E2,
        output reg E3);

	assign E2 = e[1]&~x | e[3]&~x;
	assign E3 = e[1]&x | e[2]&x;

endmodule
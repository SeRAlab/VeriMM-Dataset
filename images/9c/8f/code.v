module top_module (
        input [3:1] c,
        input u,
        output reg C2,
        output reg C3);

	assign C2 = c[1]&~u | c[3]&~u;
	assign C3 = c[1]&u | c[2]&u;

endmodule
module top_module (
        input [4:1] r,
        input u,
        output reg R2,
        output reg R3);

	assign R2 = r[1]&~u | r[4]&u;
	assign R3 = r[1]&u | r[2]&~u;

endmodule
module top_module (
        input [4:1] r,
        input q,
        output reg R3,
        output reg R4);

	assign R3 = r[1]&q | r[3]&~q;
	assign R4 = r[2]&q | r[4]&~q;

endmodule
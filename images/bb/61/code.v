module top_module (
        input [3:1] r,
        input h,
        output reg R2,
        output reg R3);

	assign R2 = r[1]&~h | r[3]&h;
	assign R3 = r[2]&~h | r[1]&h;

endmodule
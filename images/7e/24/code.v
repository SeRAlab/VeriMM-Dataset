module top_module (
        input [3:1] j,
        input r,
        output reg J2,
        output reg J3);

	assign J2 = j[1]&~r | j[3]&~r;
	assign J3 = j[1]&r | j[2]&r;

endmodule
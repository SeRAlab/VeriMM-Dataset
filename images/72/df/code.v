module top_module (
        input [3:1] u,
        input r,
        output reg U2,
        output reg U3);

	assign U2 = u[1]&r | u[3]&~r;
	assign U3 = u[1]&~r | u[2]&r;

endmodule
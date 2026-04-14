module top_module (
        input [3:1] u,
        input e,
        output reg U2,
        output reg U3);

	assign U2 = u[1]&~e | u[3]&e;
	assign U3 = u[2]&~e | u[1]&e;

endmodule
module top_module (
        input [4:1] u,
        input t,
        output reg U3,
        output reg U4);

	assign U3 = u[1]&t | u[3]&~t;
	assign U4 = u[2]&t | u[4]&~t;

endmodule
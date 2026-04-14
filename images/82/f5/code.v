module top_module (
        input [3:1] k,
        input q,
        output reg K2,
        output reg K3);

	assign K2 = k[1]&~q | k[3]&~q;
	assign K3 = k[1]&q | k[2]&q;

endmodule
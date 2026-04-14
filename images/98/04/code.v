module state_transition (
        input [4:1] k,
        input r,
        output reg K2,
        output reg K3);

	assign K2 = k[1]&~r | k[4]&r;
	assign K3 = k[1]&r | k[2]&~r;

endmodule
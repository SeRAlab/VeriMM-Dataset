module top_module (
        input [3:0] m,
        input k,
        output reg M1,
        output reg M2);assign M1 = (m[0] & k) | (m[3] & k);
	assign M2 = (m[1] & k);

endmodule
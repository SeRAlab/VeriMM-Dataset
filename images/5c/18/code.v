module top_module (
        input [3:1] a,
        input s,
        output reg A2,
        output reg A3);

	assign A2 = a[1]&~s | a[3]&~s;
	assign A3 = a[1]&s | a[2]&s;

endmodule
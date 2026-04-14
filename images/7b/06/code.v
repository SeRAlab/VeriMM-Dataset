module top_module(
    input A,
    input B,
    output reg S
    );always @(A, B)
		S <= A | B;
endmodule
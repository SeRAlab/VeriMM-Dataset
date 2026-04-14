module top_module(
    input [15:0] A,
    input [15:0] B,
    output reg [15:0] R
    );always @ *
	 
	 R = A + B;

endmodule
module top_module(
    input signed [17:0] A,
    input signed [17:0] B,
    output reg signed [35:0] P,
    (* clkbuf_sink *)
    input C,
    input CE,
    input R
);always @(posedge C)
	if (R)
		P <= 0;
	else if (CE)
		P <= A * B;

endmodule
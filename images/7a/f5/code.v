module top_module(in0, in1, in2, in3, Op, MuxOut
    );parameter	W = 32;
		input		[W-1:0]in0, in1, in2, in3;
		input		[1:0]Op;
		output reg	[W-1:0]MuxOut;

always @ (Op, in0, in1, in2, in3)
begin
	if (Op == 2'b00) MuxOut = in0;
	else if (Op == 2'b01) MuxOut = in1;
	else if (Op == 2'b10) MuxOut = in2;
	else if (Op == 2'b11) MuxOut = in3;
end

endmodule
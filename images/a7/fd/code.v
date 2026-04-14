module top_module(input D, input Enable, output reg Q, output reg Qbar);always @ (D or Enable)
		if (Enable)
			begin
				Q <= D;
				Qbar <= ~D;
			end
endmodule
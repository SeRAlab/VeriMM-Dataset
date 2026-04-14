module top_module(
    input [1:0] Select,
    input [15:0] InputA,
    input [15:0] InputB,
    input [15:0] InputC,
	 input [15:0] InputD,
    output reg [15:0] Output
    );always @(*)
	begin
		case(Select)
			2'h0: Output = InputA;
			2'h1: Output = InputB;
			2'h2: Output = InputC;
			2'h3: Output = InputD;
		endcase
	end

endmodule
module top_module(
	input wire[31:0] InputA,
	input wire[31:0] InputB,
	output reg[31:0] Output
    );always @(*) begin
	Output<=InputB+InputA;
end
endmodule
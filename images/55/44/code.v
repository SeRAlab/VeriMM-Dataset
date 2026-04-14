module top_module(
	input [31:0] add1,
	input [31:0] shift,
	output reg [31:0] salida
);always @*
begin
	salida <= add1 + shift;
end
endmodule
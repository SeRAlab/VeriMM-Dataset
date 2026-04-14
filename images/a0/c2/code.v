module top_module(
	output reg dataOut,
	input A,
	input B,
	input C,
	input [1:0] select
	);always @(select)
begin
	if (select==2'b00) dataOut<=A;
	else if (select==2'b01) dataOut <=B;
	else if (select==2'b01) dataOut <=C;
end

endmodule
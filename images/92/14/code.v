module top_module(
REQ,
GRT
);input wire [7:0] REQ;
output reg [7:0] GRT;

always@(*) begin
	GRT = 8'b0000_0000;
	if (REQ[7])
		GRT = 8'b1000_0000;
	else if (REQ[6])
		GRT = 8'b0100_0000;
	else if (REQ[5])
		GRT = 8'b0010_0000;
	else if (REQ[4])
		GRT = 8'b0001_0000;
	else if (REQ[3])
		GRT = 8'b0000_1000;
	else if (REQ[2])
		GRT = 8'b0000_0100;
	else if (REQ[1])
		GRT = 8'b0000_0010;
	else if (REQ[0])
		GRT = 8'b0000_0001;
end

endmodule
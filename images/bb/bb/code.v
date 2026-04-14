module top_module(binary,gray);input [3:0] binary;
output [3:0] gray;
reg [3:0] gray;

always@(binary)
begin
	gray[0]=binary[0]^binary[1];
	gray[1]=binary[1]^binary[2];
	gray[2]=binary[2]^binary[3];
	gray[3]=binary[3];
end

endmodule
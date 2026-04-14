module top_module(
    input [23:0] ZN,
    input [7:0] ZEN,
    input ZS,
	 input CLK,
    output reg [23:0] ZN1,
    output reg [7:0] ZEN1,
    output reg ZS1
    );always @(posedge CLK) begin
ZN1<=ZN;
ZEN1<=ZEN;
ZS1<=ZS;
end
endmodule
module top_module(
    input wire [3:0] x,
    input wire [3:0] y,
    input wire s,
    input wire clk,
    output reg [3:0] q
    );always @(posedge clk) begin
	case(s) 
		3'b000:	q = x & y; 
		3'b001:	q = x | y; 
		3'b010:	q = x ^ y; 
		3'b011:	q = ~(x & y); 
		3'b100:	q = ~(x | y); 
	endcase
end
endmodule
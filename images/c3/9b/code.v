module ALU(clk, rst, A, B, CTRL, RES);

input clk, rst;
input [31:0] A, B;
input [4:0] CTRL;
output reg [31:0] RES;

always @(posedge clk or posedge rst) begin
	if(rst) begin
		RES <= 0;
	end else begin
		case(CTRL)
			5'b00000: // addition
				RES <= A + B;
			5'b00001: // subtraction
				RES <= A - B;
			5'b00010: // bitwise AND
				RES <= A & B;
			5'b00011: // bitwise OR
				RES <= A | B;
			5'b00100: // bitwise XOR
				RES <= A ^ B;
			5'b00101: // logical shift left
				RES <= A << B;
			default:
				RES <= 0;
		endcase
	end
end

endmodule
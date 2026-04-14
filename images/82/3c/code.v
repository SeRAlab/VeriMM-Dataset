module top_module(number, data);input [3:0] number;
output reg [7:0] data;

always @ (number) begin
	case(number)
		4'b0000: data = 8'h30;
		4'b0001: data = 8'h31;
		4'b0010: data = 8'h32;
		4'b0011: data = 8'h33;
		4'b0100: data = 8'h34;
		4'b0101: data = 8'h35;
		4'b0110: data = 8'h36;
		4'b0111: data = 8'h37;
		4'b1000: data = 8'h38;
		4'b1001: data = 8'h39;
		default: data = 8'h20;
	endcase
end

endmodule
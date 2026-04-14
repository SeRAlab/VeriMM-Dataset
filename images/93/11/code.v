module top_module(
		input OF, ZF,
		input [2:0] SW,
		input [31:0] ALU_F,
		output reg [7:0] LED
	);always @(*)
	begin
		case(SW[2:0])
			3'd0: begin
				LED = ALU_F[7:0];
			end
			3'd1: begin
				LED = ALU_F[15:8];
			end
			3'd2: begin
				LED = ALU_F[23:16];
			end
			3'd3: begin
				LED = ALU_F[31:24];
			end
			3'd4: begin
				LED[0] = OF;
				LED[1] = ZF;
				LED[7:2] = 6'd0;
			end
			default: begin
				LED = 8'd0;
			end
		endcase
	end

endmodule
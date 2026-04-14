module top_module(input0, input1, input2, control, out);input [31:0] input0, input1, input2;
	input [2:0] control;
	output reg [31:0] out;
	
	always @(control or input0 or input1 or input2) begin
		case(control[2:1])
			2'b00: out = input0;
			2'b10: out = input2;
			2'b01: begin
				if (control[0] == 0) begin
					out = input0;
				end else begin
					out = input1;
				end
			end
			2'b11: out = input1;
		endcase
	end
endmodule
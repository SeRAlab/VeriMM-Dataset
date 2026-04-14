module top_module(_input0, _input1, _input2, _input3, sel, output_);input [31:0] _input0;				
	input [31:0] _input1;				
	input [31:0] _input2;				
	input [31:0] _input3;				
	input [1:0] sel;					
	output reg[31:0] output_;
	always @ (*) begin
		case(sel)						
			2'b00: output_ <= _input0;
			2'b01: output_ <= _input1;
			2'b10: output_ <= _input2;
			2'b11: output_ <= _input3;
		endcase
	end
endmodule
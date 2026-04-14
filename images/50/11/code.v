module top_module(
    input [1:0] extop,
    input [15:0] imm16,
    output reg[31:0] imm32
    );always@(*)
	begin
	case(extop)
	2'b00:imm32<={16'b0,imm16};
	2'b01:imm32<={{16{imm16[15]}},imm16};
	2'b10:imm32<={imm16,16'b0};
	2'b11:imm32<={imm16[15],15'b0,imm16};
	endcase
	end
endmodule
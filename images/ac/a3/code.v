module top_module(
  output reg signed [31:0] Y,
  output zero,

  input signed [31:0] A,
  input signed [31:0] B,
  input [4:0] opcode
  );assign zero = (Y == 0) ? 1'b1 : 1'b0;

  always@(*) begin
    case(opcode)
      5'b00111: begin    
			Y = A & B;
      end
      5'b00110: begin    
			Y = A | B;
      end
      5'b00000: begin		
			Y = A + B;
      end
      5'b10000: begin		
			Y = A - B;
      end
		5'b01000: begin		
			Y = A * B;
		end
		5'b00001: begin		
			Y = A << B;
		end
		default: Y = A + B;
    endcase
  end

endmodule
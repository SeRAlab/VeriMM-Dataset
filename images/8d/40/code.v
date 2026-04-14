module top_module(
    input [31:0] A,
    input [31:0] B,
    input [3:0] Op,
    output [31:0] C
    );reg [31:0] out = 0;
		assign C = out;
		
		always@(*) begin
			case(Op)
				0: out = A + B;
				1: out = A - B;
				2: out = A & B;
				3: out = A | B;
				4: out = A ^ B;
				5: out = A << B;
				6: out = A >> B;
				7: out = $signed(A) >> B;
				8: out = (A > B);
				9: out = ($signed(A) > $signed(B));
			endcase
		end
endmodule
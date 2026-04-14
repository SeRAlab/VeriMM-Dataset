module top_module(input[1:0] SEL, input[7:0] IN0, input[7:0] IN1, input[7:0] IN2, input[7:0] IN3, output reg[7:0] OUTA, output reg[7:0] OUTB);always @(*) begin
		case(SEL)
			2'd00: begin
				OUTA <= IN0;
				OUTB <= IN3;
			end

			2'd01: begin
				OUTA <= IN1;
				OUTB <= IN2;
			end

			2'd02: begin
				OUTA <= IN2;
				OUTB <= IN1;
			end

			2'd03: begin
				OUTA <= IN3;
				OUTB <= IN0;
			end

		endcase
	end
endmodule
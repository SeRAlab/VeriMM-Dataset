module top_module(
   input wire [4:0] in,
   output reg [2:0] out
   );always @ (*) begin
      out = 3'b000;
      case (in)
	5'b00001: out = 3'b000;
	5'b00010: out = 3'b001;
	5'b00100: out = 3'b010;
	5'b01000: out = 3'b011;
	5'b10000: out = 3'b100;
	default: out = 3'b000;
      endcase // case (in)
   end
endmodule
module top_module(F,
                  CBA);output reg [7:0] F;
input [2:0] CBA;
always @ (*)
  begin
    case (CBA)
      3'b000:
        F = 8'b11111110;
      3'b001:
        F = 8'b11111101;
      3'b010:
        F = 8'b11111011;
      3'b011:
        F = 8'b11110111;
      3'b100:
        F = 8'b11101111;
      3'b101:
        F = 8'b11011111;
      3'b110:
        F = 8'b10111111;
      3'b111:
        F = 8'b01111111;
    endcase
  end
endmodule
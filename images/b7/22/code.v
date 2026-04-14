module top_module(
  input A, B, C, D, E,
  output reg F
);always @(*) begin
    case ({A,B})
      2'b00: begin
        case ({C,D,E})
          3'b000, 3'b001, 3'b011, 3'b010: F = 1;
          3'b110, 3'b111, 3'b101, 3'b100: F = 0;
        endcase
      end
      2'b01: begin
        case ({C,D,E})
          3'b000, 3'b001, 3'b011, 3'b010: F = 1;
          3'b110, 3'b111, 3'b101, 3'b100: F = 0;
        endcase
      end
      2'b11: begin
        case ({C,D,E})
          3'b000, 3'b011, 3'b111, 3'b101: F = 0;
          3'b001, 3'b010, 3'b110, 3'b100: F = 1;
        endcase
      end
      2'b10: begin
        case ({C,D,E})
          3'b000, 3'b011, 3'b111, 3'b101: F = 0;
          3'b001, 3'b010, 3'b110, 3'b100: F = 1;
        endcase
      end
    endcase
  end

endmodule
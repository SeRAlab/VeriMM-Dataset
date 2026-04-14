module top_module(
  input wire A, B, C, D, E,
  output reg F
);always @* begin
    case ({A,B})
      2'b00: begin
        case ({C,D,E})
          3'b000: F = 1'b0;
          3'b001: F = 1'b1;
          3'b010: F = 1'b1;
          3'b011: F = 1'b0;
          3'b100: F = 1'b1;
          3'b101: F = 1'b0;
          3'b110: F = 1'b0;
          3'b111: F = 1'b1;
        endcase
      end
      2'b01: begin
        case ({C,D,E})
          3'b000: F = 1'b1;
          3'b001: F = 1'b0;
          3'b010: F = 1'b0;
          3'b011: F = 1'b1;
          3'b100: F = 1'b0;
          3'b101: F = 1'b1;
          3'b110: F = 1'b1;
          3'b111: F = 1'b0;
        endcase
      end
      2'b10: begin
        case ({C,D,E})
          3'b000: F = 1'b0;
          3'b001: F = 1'b1;
          3'b010: F = 1'b1;
          3'b011: F = 1'b0;
          3'b100: F = 1'b1;
          3'b101: F = 1'b0;
          3'b110: F = 1'b0;
          3'b111: F = 1'b1;
        endcase
      end
      2'b11: begin
        case ({C,D,E})
          3'b000: F = 1'b1;
          3'b001: F = 1'b0;
          3'b010: F = 1'b0;
          3'b011: F = 1'b1;
          3'b100: F = 1'b0;
          3'b101: F = 1'b1;
          3'b110: F = 1'b1;
          3'b111: F = 1'b0;
        endcase
      end
    endcase
  end

endmodule
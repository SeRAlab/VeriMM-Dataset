module top_module(
  input wire A, B, C, D,
  output reg F
);always @(*) begin
    case ({A,B})
      2'b00: begin
        case ({C,D})
          2'b00: F = 1'b0;
          2'b01: F = 1'b1;
          2'b11: F = 1'b1;
          2'b10: F = 1'b0;
        endcase
      end
      2'b01: begin
        case ({C,D})
          2'b00: F = 1'b1;
          2'b01: F = 1'b0;
          2'b11: F = 1'b0;
          2'b10: F = 1'b1;
        endcase
      end
      2'b11: begin
        case ({C,D})
          2'b00: F = 1'b1;
          2'b01: F = 1'b0;
          2'b11: F = 1'b0;
          2'b10: F = 1'b1;
        endcase
      end
      2'b10: begin
        case ({C,D})
          2'b00: F = 1'b0;
          2'b01: F = 1'b1;
          2'b11: F = 1'b1;
          2'b10: F = 1'b0;
        endcase
      end
    endcase
  end

endmodule
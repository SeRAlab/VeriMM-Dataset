module top_module(
  input wire A, B, C, D, E,
  output reg F
);parameter NUM_INPUTS = 5;

always @(*) begin
  case ({A,B,C,D,E})
    5'b00000: F <= 1'b0;
    5'b00001: F <= 1'b1;
    5'b00010: F <= 1'b0;
    5'b00011: F <= 1'b1;
    5'b00100: F <= 1'b1;
    5'b00101: F <= 1'b0;
    5'b00110: F <= 1'b1;
    5'b00111: F <= 1'b0;
    5'b01000: F <= 1'b1;
    5'b01001: F <= 1'b0;
    5'b01010: F <= 1'b1;
    5'b01011: F <= 1'b0;
    5'b01100: F <= 1'b0;
    5'b01101: F <= 1'b1;
    5'b01110: F <= 1'b0;
    5'b01111: F <= 1'b1;
    default: F <= 1'b0;
  endcase
end

endmodule
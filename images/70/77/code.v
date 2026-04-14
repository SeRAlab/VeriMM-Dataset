module top_module(
  input [3:0] in,
  output reg [2:0] out  // Change the output to "reg"
);always @(*) begin
    case (in[2:0])
      3'b000: out = 3'b000; // 0 / 2 = 0
      3'b001: out = 3'b000; // 1 / 2 = 0
      3'b010: out = 3'b001; // 2 / 2 = 1
      3'b011: out = 3'b001; // 3 / 2 = 1
      3'b100: out = 3'b010; // 4 / 2 = 2
      3'b101: out = 3'b010; // 5 / 2 = 2
      3'b110: out = 3'b011; // 6 / 2 = 3
      3'b111: out = 3'b011; // 7 / 2 = 3
      default: out = 3'b000; // default case (should never happen)
    endcase
  end

endmodule
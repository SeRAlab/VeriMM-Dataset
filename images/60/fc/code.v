module top_module(
  input [2:0] w3,
  input [2:0] w2,
  input [6:0] w4,           // Added missing input for w4
  output reg [2:0] v36f80c
);always @(*) begin
    case (w3)
      3'b000: v36f80c = 3'b000;
      3'b001: v36f80c = {1'b0, w2[2], 1'b0};
      3'b010: v36f80c = {1'b0, w2[1], w2[0]};
      3'b011: v36f80c = {1'b0, w2[0], 1'b0};
      3'b100: v36f80c = {1'b0, 1'b0, 1'b0} & w4[6:0]; // Adjusted to use w4 correctly
      3'b101: v36f80c = {1'b0, 1'b0, w4[6]};
      3'b110: v36f80c = {1'b0, 1'b0, w4[5]};
      3'b111: v36f80c = {1'b0, 1'b0, w4[4]};
      default: v36f80c = 3'b000;
    endcase
  end

endmodule
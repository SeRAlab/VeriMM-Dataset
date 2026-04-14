module v1b8919 (
  input [2:0] w3,
  input [2:0] w2,
  output reg [2:0] v36f80c
);

  always @(*) begin
    case (w3)
      0: v36f80c = 3'b000;
      1: v36f80c = {1'b0, w2[2], 1'b0};
      2: v36f80c = {1'b0, w2[1], w2[0]};
      3: v36f80c = {1'b0, w2[0], 1'b0};
      4: v36f80c = {1'b0, 1'b0, 1'b0} & w4;
      5: v36f80c = {1'b0, 1'b0, w4[6]};
      6: v36f80c = {1'b0, 1'b0, w4[5]};
      7: v36f80c = {1'b0, 1'b0, w4[4]};
      default: v36f80c = 3'b000;
    endcase
  end

endmodule
module top_module(
  input [15:0] A,
  input [15:0] B,
  input reset,
  output reg equal,
  output reg greater_than
);always @ (A or B or reset) begin
    if (reset) begin
      equal <= 0;
      greater_than <= 0;
    end else begin
      if (A == B) begin
        equal <= 1;
        greater_than <= 0;
      end else if (A > B) begin
        equal <= 0;
        greater_than <= 1;
      end else begin
        equal <= 0;
        greater_than <= 0;
      end
    end
  end

endmodule
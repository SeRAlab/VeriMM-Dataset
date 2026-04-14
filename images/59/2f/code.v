module top_module(
  input [7:0] in0,
  input [7:0] in1,
  input [7:0] in2,
  input [7:0] in3,
  input sel0,
  input sel1,
  output reg [7:0] out
);always @* begin
    if (sel1 == 0 && sel0 == 0) begin
      out = in0;
    end else if (sel1 == 0 && sel0 == 1) begin
      out = in1;
    end else if (sel1 == 1 && sel0 == 0) begin
      out = in2;
    end else begin
      out = in3;
    end
  end

endmodule
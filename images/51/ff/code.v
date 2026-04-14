module top_module(
  input [7:0] in1,
  input [7:0] in2,
  output reg out_eq,
  output reg out_gt,
  output reg out_lt
);always @(*) begin
    if (in1 == in2) begin
      out_eq = 1;
      out_gt = 0;
      out_lt = 0;
    end else if (in1 > in2) begin
      out_eq = 0;
      out_gt = 1;
      out_lt = 0;
    end else begin
      out_eq = 0;
      out_gt = 0;
      out_lt = 1;
    end
  end

endmodule
module top_module(
    in1,
    in2,
    in3,
    in4,
    en,
    out
);input [3:0] in1, in2, in3, in4;
  input en;
  output reg out;

  always @ (*) begin
    if (en) begin
      out = (in1 & in2 & in3 & in4);
    end else begin
      out = 1'b0;
    end
  end

endmodule
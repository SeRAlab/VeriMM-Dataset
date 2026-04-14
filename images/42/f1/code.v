module top_module(
  input clk,
  input reset,
  input [7:0] in1,
  input [7:0] in2,
  input mode,
  output reg [7:0] out
);reg [7:0] sum;
  reg [7:0] diff;

  always @ (posedge clk, posedge reset) begin
    if (reset) begin
      sum <= 8'b0;
      diff <= 8'b0;
      out <= 8'b0;
    end else begin
      sum <= in1 + in2;
      diff <= in1 - in2;
      if (mode) begin
        out <= diff;
      end else begin
        out <= sum;
      end
    end
  end

endmodule
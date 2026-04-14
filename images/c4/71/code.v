module freq_div (
  input clk_in,
  input reset,
  input [7:0] divider,
  output reg clk_out
);

  reg [7:0] count = 0;

  always @(posedge clk_in or posedge reset) begin
    if (reset) begin
      clk_out <= 0;
      count <= 0;
    end else begin
      count <= count + 1;
      if (count == divider) begin
        clk_out <= ~clk_out;
        count <= 0;
      end
    end
  end

endmodule
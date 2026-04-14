module top_module(
  input clk_in,
  input enable,
  input [7:0] div,
  output reg clk_out
);reg [7:0] counter;

  always @(posedge clk_in) begin
    if (enable) begin
      if (counter == div) begin
        counter <= 0;
        clk_out <= ~clk_out;
      end
      else begin
        counter <= counter + 1;
      end
    end
    else begin
      clk_out <= 1'b0; // Set clk_out to 0 when not enabled (instead of high impedance)
    end
  end

endmodule
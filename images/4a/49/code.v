module top_module(
  input clk_in,
  input resetn,
  output reg clk_out,
  output reg locked
);reg [24:0] counter = 0;
  reg locked_tmp = 0;

  always @(posedge clk_in or negedge resetn) begin
    if (~resetn) begin
      counter <= 0;
      clk_out <= 0;
      locked_tmp <= 0;
    end else begin
      if (counter == 0) begin
        clk_out <= ~clk_out;
        counter <= 24'd249999; // divide by 2
      end else begin
        counter <= counter - 1;
      end
      if (counter == 12'd0) begin
        locked_tmp <= 1;
      end else begin
        locked_tmp <= 0;
      end
    end
  end

  always @(posedge clk_in) begin
    locked <= locked_tmp;
  end

endmodule
module top_module(clk125,
    clk,
    clk_locked);input clk125;
  output reg clk;          // Change to reg to allow assignment in always block
  output clk_locked;

  reg [31:0] counter;
  wire clk125;
  wire clk_locked;

  assign clk_locked = (counter == 0);

  always @(posedge clk125) begin
    if (counter == 0) begin
      counter <= 1;
      clk <= 1;
    end else if (counter == 1) begin
      counter <= 0;
      clk <= 0;
    end else begin
      counter <= counter - 1;
    end
  end
endmodule
module top_module(
  input clk_in,
  input [7:0] phase_shift,
  output clk_out
);reg [7:0] counter;
  reg [7:0] delay;
  reg [7:0] phase_shifted_delay;
  reg clk_out_reg;
  
  always @(posedge clk_in) begin
    counter <= counter + 1;
    if (counter == 255) begin
      counter <= 0;
      delay <= delay + 1;
      if (delay == phase_shift) begin
        delay <= 0;
        clk_out_reg <= ~clk_out_reg;
      end
    end
  end
  
  assign clk_out = clk_out_reg;
  
endmodule
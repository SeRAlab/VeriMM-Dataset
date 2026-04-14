module top_module(
  input clk,
  input [3:0] phase_shift_amount,
  output reg clk_phase_shifted
);reg [3:0] counter;

always @(posedge clk) begin
  counter <= counter + 1;
  if (counter == phase_shift_amount) begin
    counter <= 0;
    clk_phase_shifted <= ~clk_phase_shifted;
  end
end

endmodule